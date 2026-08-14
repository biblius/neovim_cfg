-- LSP Setup
--
-- Each entry is passed as-is to `vim.lsp.config(name, config)`.
-- Server-specific options MUST live under `settings` (e.g. settings['rust-analyzer']).
-- Top-level keys like `filetypes` / `init_options` are Neovim LSP client config, not server settings.
-- Available servers:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},

  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        -- Default `cargo check` does not emit Clippy lints. Use clippy so those
        -- warnings show up as LSP diagnostics / highlights.
        checkOnSave = true,
        check = {
          command = 'clippy',
        },
      },
    },
  },

  lua_ls = {
    settings = {
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },

  marksman = {},

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#svelte
  svelte = {},

  -- Vue 3 hybrid mode (vue_ls >= 3):
  --   vue_ls  = HTML/CSS in .vue files
  --   ts_ls   = TypeScript in <script>, via @vue/typescript-plugin
  -- vue_ls does NOT look for the typescript-language-server binary. It looks for
  -- a ts_ls *client already attached to the same .vue buffer*. If ts_ls's
  -- filetypes omit 'vue', you get: "Could not find ts_ls lsp client required by vue_ls".
  -- https://github.com/vuejs/language-tools/wiki/Neovim
  ts_ls = {
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'vue', -- required so ts_ls attaches to SFCs for vue_ls to talk to
      'svelte',
    },
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          -- Mason v2 path. Must be the @vue/language-server package dir, not the
          -- typescript-plugin package. configNamespace is required by current Vue LS.
          location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
          languages = { 'vue' },
          configNamespace = 'typescript',
        },
      },
    },
  },

  -- Empty table is fine: nvim-lspconfig's default vue_ls config already forwards
  -- tsserver/request to an attached ts_ls client.
  vue_ls = {},

  html = { filetypes = { 'html', 'twig', 'hbs' } },

  tailwindcss = { filetypes = { 'svelte', 'html', 'javascript', 'typescript' } },
}

return {
  -- Essentially a package manager for LSP and formatting stuff
  -- https://github.com/mason-org/mason.nvim
  {
    'mason-org/mason.nvim',
    opts = {},
  },

  -- Automatically installs servers with Mason from nvim-lspconfig
  -- https://github.com/mason-org/mason-lspconfig.nvim
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      -- Ensure the servers above are installed
      ensure_installed = vim.tbl_keys(servers),
      -- Do not vim.lsp.enable() from Mason. If Mason enables first, servers start
      -- with nvim-lspconfig defaults and our tables (clippy, vue filetypes, …) never apply.
      automatic_enable = false,
    },
    -- This MUST be `config`, not a top-level `init` next to the plugin specs.
    -- lazy.nvim only loads array entries from this file; a sibling `init = function()`
    -- key is ignored, which is how the Vue/clippy overrides silently stopped working.
    config = function(_, opts)
      require('mason-lspconfig').setup(opts)

      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      -- vue_ls (since 3.0.2) owns Vue semantic tokens. ts_ls still sends its own
      -- tokens on .vue buffers; those have higher priority than treesitter and
      -- wash out SFC highlighting. Disable ts_ls tokens on Vue only.
      -- https://github.com/vuejs/language-tools/wiki/Neovim#custom-component-highlight
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          if client.name == 'ts_ls' and vim.bo[args.buf].filetype == 'vue' then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      -- Vue reports token type "component" for custom tags (<MyButton>). Most
      -- colorschemes do not define @lsp.type.component, so they render as plain text.
      local function vue_lsp_highlights()
        vim.api.nvim_set_hl(0, '@lsp.type.component', { link = '@type' })
      end

      vue_lsp_highlights()

      -- Re-apply on ColorScheme so a theme switch does not drop the link.
      vim.api.nvim_create_autocmd('ColorScheme', { callback = vue_lsp_highlights })
    end,
  },
}
