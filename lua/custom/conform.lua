return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {},
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      rust = { 'rustfmt' },
      lua = { 'stylua' },
      python = { 'black' },
      json = { 'prettierd' },
      markdown = { 'prettierd' },
      vue = { 'prettierd' },
      svelte = { 'prettierd' },
      html = { 'prettierd' },
      javascript = { 'prettierd', 'prettier' },
      typescript = { 'prettierd', 'prettier' },
      yaml = { 'yamlfmt' },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = 'fallback',
      stop_after_first = true,
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 500 },
    -- Customize formatters
    formatters = {},
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    -- Create a :Format command
    vim.api.nvim_create_user_command('Format', function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      require('conform').format { async = true, lsp_format = 'fallback', range = range }
    end, { range = true })
  end,
}
