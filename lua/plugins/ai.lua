return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    config = function()
      require("mcphub").setup({
        -- Required options
        port = 3999, -- Port for MCP Hub server
        config = vim.fn.expand("~/mcpservers.json"), -- Absolute path to config file

        -- Optional options
        on_ready = function(hub)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
        end,
        shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    enabled = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
      provider = "claude",
      -- cursor_applying_provider = "groq",
      auto_suggestions_provider = "ollama",
      behaviour = {
        --- ... existing behaviours
        -- enable_cursor_planning_mode = true, -- enable cursor planning mode!
        -- enable_claude_text_editor_tool_mode = true,
      },
      providers = {
        claude = {
          model = "claude-sonnet-4-20250514",
          extra_request_body = {
            max_tokens = 64000,
          },
        },
        ollama = {
          endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
          model = "qwen2.5-coder:1.5b",
        },
        groq = {

          __inherited_from = "openai",
          api_key_name = "GROQ_API_KEY",
          endpoint = "https://api.groq.com/openai/v1/",
          model = "llama-3.3-70b-versatile",
          max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
        },
        llama_openrouter = { -- define groq provider
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1",
          model = "meta-llama/llama-3.3-70b-instruct:nitro",
          max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
        },
        google_openrouter = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1",
          model = "google/gemini-2.0-flash-001",
          max_tokens = 8192, -- remember to increase this value, otherwise it will stop generating halfway
        },
      },
      rag_service = {
        enabled = false, -- Enables the RAG service
        host_mount = os.getenv("HOME") .. "/Workspace", -- Host mount path for the rag service
        runner = "docker",
        llm = {
          provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
          endpoint = "http://host.docker.internal:11434", -- The API endpoint for RAG service
          api_key = "",
          model = "qwen2.5-coder:1.5b", -- The LLM model to use for RAG service
          extra = nil,
        },
        embed = {
          provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
          endpoint = "http://host.docker.internal:11434", -- The API endpoint for RAG service
          api_key = "",
          model = "nomic-embed-text", -- The embedding model to use for RAG service
          extra = { -- Extra configuration options for the Embedding model (optional)
            embed_batch_size = 10,
          },
        },
      },
      -- other config
      -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()

        if hub == nil then
          return ""
        end

        return hub:get_active_servers_prompt()
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      disabled_tools = {
        "list_files", -- Built-in file operations
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash", -- Built-in terminal access
      },
    },
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "ravitemer/mcphub.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
