return {
  {
    -- Highlight, edit, and navigate code
    -- `main` branch (Nvim 0.12+): this plugin only installs parsers. Highlighting is
    -- started from the FileType autocmd in init.lua via vim.treesitter.start().
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    -- :TSUpdate only refreshes parsers that are ALREADY installed. It will not
    -- install missing ones; that is what the install() list below is for.
    build = ':TSUpdate',
    config = function()
      -- Keep this list in sync with the FileType autocmd in init.lua, plus extra
      -- parsers that are not filetypes but get injected into other languages.
      --
      -- Vue/Svelte: the `vue`/`svelte` parser only understands SFC structure
      -- (<template>, <script>, <style>). Script/style bodies are highlighted by
      -- injecting javascript/typescript/css/scss. Installing `vue` alone leaves
      -- those blocks uncolored.
      --
      -- markdown_inline is injected into markdown. html is used by vue queries.
      -- tsx covers <script lang="tsx">.
      require('nvim-treesitter').install {
        'c',
        'cpp',
        'go',
        'lua',
        'python',
        'rust',
        'javascript',
        'typescript',
        'tsx',
        'vimdoc',
        'vim',
        'bash',
        'svelte',
        'markdown',
        'markdown_inline',
        'vue',
        'xml',
        'json',
        'html',
        'css',
        'scss',
      }
    end,
  },
}
