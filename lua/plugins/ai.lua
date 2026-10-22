return {
	{
		"ThePrimeagen/99",
		config = function()
			local _99 = require("99")

            -- For logging that is to a file if you wish to trace through requests
            -- for reporting bugs, i would not rely on this, but instead the provided
            -- logging mechanisms within 99.  This is for more debugging purposes
            local cwd = vim.uv.cwd()
            local basename = vim.fs.basename(cwd)
			_99.setup({
                -- provider = _99.Providers.ClaudeCodeProvider,  -- default: OpenCodeProvider
				logger = {
					level = _99.DEBUG,
					path = "/tmp/" .. basename .. ".99.debug",
					print_on_error = true,
				},
                -- When setting this to something that is not inside the CWD tools
                -- such as claude code or opencode will have permission issues
                -- and generation will fail refer to tool documentation to resolve
                -- https://opencode.ai/docs/permissions/#external-directories
                -- https://code.claude.com/docs/en/permissions#read-and-edit
                tmp_dir = "./tmp",

                --- Completions: #rules and @files in the prompt buffer
                completion = {
                    -- I am going to disable these until i understand the
                    -- problem better.  Inside of cursor rules there is also
                    -- application rules, which means i need to apply these
                    -- differently
                    -- cursor_rules = "<custom path to cursor rules>"

                    --- A list of folders where you have your own SKILL.md
                    --- Expected format:
                    --- /path/to/dir/<skill_name>/SKILL.md
                    ---
                    --- Example:
                    --- Input Path:
                    --- "scratch/custom_rules/"
                    ---
                    --- Output Rules:
                    --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
                    --- ... the other rules in that dir ...
                    ---
                    custom_rules = {
                      "scratch/custom_rules/",
                    },

                    --- Configure @file completion (all fields optional, sensible defaults)
                    files = {
                        -- enabled = true,
                        -- max_file_size = 102400,     -- bytes, skip files larger than this
                        -- max_files = 5000,            -- cap on total discovered files
                        -- exclude = { ".env", ".env.*", "node_modules", ".git", ... },
                    },
                    --- File Discovery:
                    --- - In git repos: Uses `git ls-files` which automatically respects .gitignore
                    --- - Non-git repos: Falls back to filesystem scanning with manual excludes
                    --- - Both methods apply the configured `exclude` list on top of gitignore

                    --- What autocomplete engine to use. Defaults to native (built-in) if not specified.
                    source = "native", -- "native" (default), "cmp", or "blink"
                },

                --- WARNING: if you change cwd then this is likely broken
                --- ill likely fix this in a later change
                ---
                --- md_files is a list of files to look for and auto add based on the location
                --- of the originating request.  That means if you are at /foo/bar/baz.lua
                --- the system will automagically look for:
                --- /foo/bar/AGENT.md
                --- /foo/AGENT.md
                --- assuming that /foo is project root (based on cwd)
				md_files = {
					"AGENT.md",
				},
			})

            -- take extra note that i have visual selection only in v mode
            -- technically whatever your last visual selection is, will be used
            -- so i have this set to visual mode so i dont screw up and use an
            -- old visual selection
            --
            -- likely ill add a mode check and assert on required visual mode
            -- so just prepare for it now
			vim.keymap.set("v", "<leader>9v", function()
				_99.visual()
			end)

            --- if you have a request you dont want to make any changes, just cancel it
			vim.keymap.set("n", "<leader>9x", function()
				_99.stop_all_requests()
			end)

			vim.keymap.set("n", "<leader>9s", function()
				_99.search()
			end)
		end,
	},
  -- {
  --   "nickjvandyke/opencode.nvim",
  --   version = "*", -- Latest stable release.
  --   dependencies = {
  --     {
  --       -- `snacks.nvim` integration is recommended, but optional.
  --       ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
  --       "folke/snacks.nvim",
  --       optional = true,
  --       opts = {
  --         -- Enhances `ask()`.
  --         input = {},
  --         -- Enhances `select()`.
  --         picker = {
  --           actions = {
  --             opencode_send = function(...)
  --               return require("opencode").snacks_picker_send(...)
  --             end,
  --           },
  --           win = {
  --             input = {
  --               keys = {
  --                 ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
  --               },
  --             },
  --           },
  --         },
  --         -- Enables the `snacks` provider.
  --         terminal = {},
  --       },
  --     },
  --   },
  --   config = function()
  --     ---@type opencode.Opts
  --     vim.g.opencode_opts = {
  --       -- Your configuration, if any; goto definition on the type or field for details.
  --     }
  --
  --     -- Required for `opts.events.reload`.
  --     vim.o.autoread = true
  --
  --     -- Recommended/example keymaps.
  --     vim.keymap.set({ "n", "x" }, "<C-a>", function()
  --       require("opencode").ask("@this: ", { submit = true })
  --     end, { desc = "Ask opencode…" })
  --     vim.keymap.set({ "n", "x" }, "<C-x>", function()
  --       require("opencode").select()
  --     end, { desc = "Execute opencode action…" })
  --     vim.keymap.set({ "n", "t" }, "<C-.>", function()
  --       require("opencode").toggle()
  --     end, { desc = "Toggle opencode" })
  --
  --     vim.keymap.set({ "n", "x" }, "go", function()
  --       return require("opencode").operator("@this ")
  --     end, { desc = "Add range to opencode", expr = true })
  --     vim.keymap.set("n", "goo", function()
  --       return require("opencode").operator("@this ") .. "_"
  --     end, { desc = "Add line to opencode", expr = true })
  --
  --     vim.keymap.set("n", "<S-C-u>", function()
  --       require("opencode").command("session.half.page.up")
  --     end, { desc = "Scroll opencode up" })
  --     vim.keymap.set("n", "<S-C-d>", function()
  --       require("opencode").command("session.half.page.down")
  --     end, { desc = "Scroll opencode down" })
  --
  --     -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap).
  --     vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
  --     vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  --   end,
  -- },
  -- {
  --   "ravitemer/mcphub.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
  --   },
  --   build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
  --   config = function()
  --     require("mcphub").setup({
  --       -- Required options
  --       port = 3999, -- Port for MCP Hub server
  --       config = vim.fn.expand("~/mcpservers.json"), -- Absolute path to config file
  --
  --       -- Optional options
  --       on_ready = function(hub)
  --         -- Called when hub is ready
  --       end,
  --       on_error = function(err)
  --         -- Called on errors
  --       end,
  --       shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
  --       log = {
  --         level = vim.log.levels.WARN,
  --         to_file = false,
  --         file_path = nil,
  --         prefix = "MCPHub",
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "yetone/avante.nvim",
  --   opts = {
  --     -- add any opts here
  --     provider = "claude",
  --     -- cursor_applying_provider = "groq",
  --     auto_suggestions_provider = "ollama",
  --     behaviour = {
  --       --- ... existing behaviours
  --       -- enable_cursor_planning_mode = true, -- enable cursor planning mode!
  --       -- enable_claude_text_editor_tool_mode = true,
  --     },
  --     providers = {
  --       ollama = {
  --         endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
  --         model = "qwen2.5-coder:1.5b",
  --       },
  --     },
  --     rag_service = {
  --       enabled = false, -- Enables the RAG service
  --       host_mount = os.getenv("HOME") .. "/Workspace", -- Host mount path for the rag service
  --       runner = "docker",
  --       llm = {
  --         provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
  --         endpoint = "http://host.docker.internal:11434", -- The API endpoint for RAG service
  --         api_key = "",
  --         model = "qwen2.5-coder:1.5b", -- The LLM model to use for RAG service
  --         extra = nil,
  --       },
  --       embed = {
  --         provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
  --         endpoint = "http://host.docker.internal:11434", -- The API endpoint for RAG service
  --         api_key = "",
  --         model = "nomic-embed-text", -- The embedding model to use for RAG service
  --         extra = { -- Extra configuration options for the Embedding model (optional)
  --           embed_batch_size = 10,
  --         },
  --       },
  --     },
  --     -- other config
  --     -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
  --     -- system_prompt = function()
  --     --   local hub = require("mcphub").get_hub_instance()
  --     --
  --     --   if hub == nil then
  --     --     return ""
  --     --   end
  --     --
  --     --   return hub:get_active_servers_prompt()
  --     -- end,
  --     -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
  --     -- custom_tools = function()
  --     --   return {
  --     --     require("mcphub.extensions.avante").mcp_tool(),
  --     --   }
  --     -- end,
  --     -- disabled_tools = {
  --     --   "list_files", -- Built-in file operations
  --     --   "search_files",
  --     --   "read_file",
  --     --   "create_file",
  --     --   "rename_file",
  --     --   "delete_file",
  --     --   "create_dir",
  --     --   "rename_dir",
  --     --   "delete_dir",
  --     --   "bash", -- Built-in terminal access
  --     -- },
  --   },
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "nvim-mini/mini.pick", -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "ravitemer/mcphub.nvim",
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        tools = {
          opencode = {
            cmd = { "opencode", "--port", "4000", "--hostname", "0.0.0.0" },
            env = {
              OPENCODE_THEME = "system",
              OPENCODE_EXPERIMENTAL_WORKSPACES = "true"
            },
          },
        },
        win = {
          keys = {
            escape_twice = {
              "<Esc><Esc>",
              function(term)
                vim.api.nvim_chan_send(term.job, "\027\027")
              end,
              mode = "t",
              desc = "send double escape to the terminal",
            },
            escape = {
              "<Esc>",
              function(term)
                vim.api.nvim_chan_send(term.job, "\027")
              end,
              mode = "t",
              desc = "send escape to the terminal",
            },
          },
        },
      },
    },
    keys = {
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
        desc = "Sidekick Toggle OpenCode",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
        desc = "Sidekick Toggle OpenCode",
      },
    },
  },
}
