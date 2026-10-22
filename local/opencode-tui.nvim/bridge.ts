import crypto from "node:crypto"
import fs from "node:fs"
import net from "node:net"
import os from "node:os"
import path from "node:path"
import readline from "node:readline"
import { WebSocket, WebSocketServer } from "ws"

const IDE_NAME = "opencode-tui.nvim"
const MCP_PROTOCOL_VERSION = "2025-11-25"
const MAX_PENDING_MENTIONS = 100
const LOCK_DIR = path.join(os.homedir(), ".claude", "ide")

type Method = "at_mentioned" | "selection_changed"
type Notification = {
  jsonrpc: "2.0"
  method: Method
  params: unknown
}
type EditorMessage = {
  method: Method
  params: unknown
  workspace?: string
  broadcastAll?: boolean
}
type Endpoint = {
  workspace: string
  token: string
  server: WebSocketServer
  lockFile: string
  latestSelection?: Notification
  pendingMentions: Notification[]
}

const endpoints = new Map<string, Endpoint>()

function output(message: unknown) {
  process.stdout.write(`${JSON.stringify(message)}\n`)
}

function processExists(pid: unknown) {
  if (!Number.isInteger(pid) || (pid as number) <= 0) return false
  try {
    process.kill(pid as number, 0)
    return true
  } catch (error) {
    return (error as NodeJS.ErrnoException).code === "EPERM"
  }
}

function pruneStaleLocks() {
  for (const entry of fs.readdirSync(LOCK_DIR)) {
    if (!entry.endsWith(".lock")) continue
    const file = path.join(LOCK_DIR, entry)
    try {
      const value = JSON.parse(fs.readFileSync(file, "utf8")) as { ideName?: unknown; pid?: unknown }
      if (value.ideName === IDE_NAME && !processExists(value.pid)) fs.rmSync(file, { force: true })
    } catch {
      // Other editors own their lock files; malformed entries are ignored by OpenCode too.
    }
  }
}

function authorized(actual: string | undefined, expected: string) {
  if (!actual) return false
  const left = Buffer.from(actual)
  const right = Buffer.from(expected)
  return left.length === right.length && crypto.timingSafeEqual(left, right)
}

function clientCount() {
  let count = 0
  for (const endpoint of endpoints.values()) count += endpoint.server.clients.size
  return count
}

function reportClients() {
  output({ event: "clients", count: clientCount() })
}

function send(client: WebSocket, message: Notification | Record<string, unknown>) {
  if (client.readyState === WebSocket.OPEN) client.send(JSON.stringify(message))
}

function createEndpoint(workspace: string) {
  return new Promise<void>((resolve, reject) => {
    const token = crypto.randomBytes(32).toString("hex")
    const pendingMentions: Notification[] = []
    const server = new WebSocketServer({
      host: "127.0.0.1",
      port: 0,
      verifyClient(info, done) {
        done(authorized(info.req.headers["x-claude-code-ide-authorization"] as string | undefined, token), 401)
      },
    })

    server.once("error", reject)
    server.once("listening", () => {
      server.removeListener("error", reject)
      server.on("error", (error) => console.error(`WebSocket server error for ${workspace}: ${error.message}`))

      const address = server.address() as net.AddressInfo
      const lockFile = path.join(LOCK_DIR, `${address.port}.lock`)
      const endpoint: Endpoint = { workspace, token, server, lockFile, pendingMentions }

      fs.writeFileSync(
        lockFile,
        JSON.stringify({
          pid: process.pid,
          transport: "ws",
          workspaceFolders: [workspace],
          ideName: IDE_NAME,
          authToken: token,
        }),
        { mode: 0o600 },
      )
      endpoints.set(workspace, endpoint)

      server.on("connection", (client) => {
        reportClients()
        if (endpoint.latestSelection) send(client, endpoint.latestSelection)
        for (const mention of endpoint.pendingMentions.splice(0)) send(client, mention)

        client.on("message", (data, isBinary) => {
          if (isBinary) return
          try {
            const message = JSON.parse(data.toString()) as { id?: unknown; method?: unknown }
            if (message.method !== "initialize" || message.id === undefined) return
            send(client, {
              jsonrpc: "2.0",
              id: message.id,
              result: {
                protocolVersion: MCP_PROTOCOL_VERSION,
                serverInfo: { name: IDE_NAME, version: "0.1.0" },
              },
            })
          } catch (error) {
            console.error(`Invalid JSON-RPC message: ${(error as Error).message}`)
          }
        })
        client.on("close", reportClients)
        client.on("error", (error) => console.error(`WebSocket client error: ${error.message}`))
      })
      resolve()
    })
  })
}

function publish(endpoint: Endpoint, notification: Notification) {
  if (endpoint.server.clients.size > 0) {
    for (const client of endpoint.server.clients) send(client, notification)
    return
  }

  if (notification.method === "selection_changed") {
    endpoint.latestSelection = notification
    return
  }

  endpoint.pendingMentions.push(notification)
  if (endpoint.pendingMentions.length > MAX_PENDING_MENTIONS) endpoint.pendingMentions.shift()
  output({ event: "queued", workspace: endpoint.workspace })
}

function handleEditorMessage(line: string) {
  let message: EditorMessage
  try {
    message = JSON.parse(line) as EditorMessage
  } catch (error) {
    console.error(`Invalid editor message: ${(error as Error).message}`)
    return
  }
  if (message.method !== "at_mentioned" && message.method !== "selection_changed") return

  const notification: Notification = { jsonrpc: "2.0", method: message.method, params: message.params }
  if (message.broadcastAll) {
    for (const endpoint of endpoints.values()) publish(endpoint, notification)
    return
  }
  if (!message.workspace) {
    console.error(`Missing workspace for ${message.method}`)
    return
  }

  const endpoint = endpoints.get(path.resolve(message.workspace))
  if (!endpoint) console.error(`Unknown workspace: ${message.workspace}`)
  else publish(endpoint, notification)
}

function cleanup() {
  for (const endpoint of endpoints.values()) {
    fs.rmSync(endpoint.lockFile, { force: true })
    for (const client of endpoint.server.clients) client.terminate()
    endpoint.server.close()
  }
  endpoints.clear()
}

async function main() {
  const input = JSON.parse(process.argv[2] || "[]") as unknown
  if (!Array.isArray(input) || input.some((workspace) => typeof workspace !== "string")) {
    throw new Error("Expected a JSON array of workspace paths")
  }
  const workspaces = [...new Set(input.map((workspace) => path.resolve(workspace as string)))]
  if (workspaces.length === 0) throw new Error("At least one workspace is required")

  fs.mkdirSync(LOCK_DIR, { recursive: true })
  pruneStaleLocks()
  await Promise.all(workspaces.map(createEndpoint))
  output({ event: "ready", workspaces })

  readline.createInterface({ input: process.stdin }).on("line", handleEditorMessage)
  process.stdin.on("end", () => process.exit(0))
}

for (const signal of ["SIGTERM", "SIGINT", "SIGHUP"] as const) {
  process.once(signal, () => process.exit(0))
}
process.once("exit", cleanup)

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error))
  process.exit(1)
})
