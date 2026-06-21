return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    -- dependencies = {
    --   'nvim-treesitter/nvim-treesitter-textobjects',
    -- },
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    init = function()
      require('nvim-treesitter').install {
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
      }
    end,
  },
}
