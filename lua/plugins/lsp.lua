-- LSP Setup

-- Enable the following language servers
-- Add/remove any LSPs here. They will automatically be installed.
-- Add any additional override configuration in the following tables. They will be passed to
-- the `settings` field of the server config. You must look up that documentation yourself.
-- If you want to override the default filetypes that your language server will attach to you can define the property 'filetypes' to the map in question.
-- Available servers:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},

  rust_analyzer = {
    ['rust-analyzer'] = {
      checkOnSave = true,
      check = {
        enable = true,
        command = 'clippy',
      },
    },
    filetypes = { 'rust' },
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },

  marksman = {},

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#svelte
  svelte = {},

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
  ts_ls = {
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'vue',
    },
    init_options = {
      plugins = {
        -- Necessary for vue-ls to even begin working
        {
          languages = { 'vue' },
          location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
          name = '@vue/typescript-plugin',
        },
      },
    },
  },

  -- https://github.com/vuejs/language-tools/wiki/Neovim
  vue_ls = {},

  html = { filetypes = { 'html', 'twig', 'hbs' } },
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
    opts = {},
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
  },
  init = function()
    require('mason-lspconfig').setup {
      -- Ensure the servers above are installed
      ensure_installed = vim.tbl_keys(servers),
      -- They are enabled in the below loop
      automatic_enable = false,
    }

    for name, config in pairs(servers) do
      vim.lsp.config(name, config)
      vim.lsp.enable(name)
    end
  end,
}
