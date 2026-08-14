-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Show a floating window when jumping to diagnostics
vim.diagnostic.config { jump = { float = true } }

-- Load options
require 'options'

-- Load dependencies
require 'config.lazy'

-- Initialise keymaps
require 'keymap'

-- nvim-treesitter `main` does not enable highlighting for you. Start it per filetype.
-- Keep this list in sync with lua/plugins/treesitter.lua's install() list.
--
-- Do not call vim.treesitter.start() unconditionally: a missing parser asserts
-- ("Parser could not be created for buffer N and language X") and blows up
-- FileType autocommands (seen with rust, and via oil.nvim's BufReadPost).
-- language.add() loads the parser; pcall skips highlighting if it is not installed.
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'c',
    'cpp',
    'go',
    'lua',
    'python',
    'rust',
    'javascript',
    'typescript',
    'vimdoc',
    'vim',
    'bash',
    'svelte',
    'markdown',
    'vue',
    'xml',
    'json',
    'html_tags',
    'html',
  },
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    if pcall(vim.treesitter.language.add, lang) then
      vim.treesitter.start(args.buf, lang)
    end
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})
