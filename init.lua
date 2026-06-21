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
  },
  callback = function()
    vim.treesitter.start()
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
