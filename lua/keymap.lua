-- See `:help vim.keymap.set()`

-- Set leader to no-op
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Replace all
-- Selects the word under the cursor and inserts it into the global substitution command
vim.keymap.set('n', '<leader>ra', function()
  -- Get the word under the cursor
  local word = vim.fn.expand '<cword>'
  vim.api.nvim_input(':%s/' .. word .. '//g<LEFT><LEFT>')
end, { noremap = true, silent = true, desc = 'Select word and [R]eplace [A]ll occurrences in buffer' })

-- Sets CTRL+Backspace to delete previous word
-- C-H is what the terminal sends when Ctrl+Backspace is pressed
vim.keymap.set('i', '<C-H>', '<C-W>', { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Codeium
vim.keymap.set('i', '<Tab>', function()
  return vim.fn['codeium#Accept']() or '  '
end, { expr = true, silent = true })

-- Oil
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory (oil)' })

-- Dadbod
vim.keymap.set('n', '<leader>db', '<CMD> tabnew | DBUI <CR>', { desc = 'Open [D]ad[B]od UI' })

-- Window resizing
vim.keymap.set('n', '<C-Left>', ':vertical resize +3<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize -3<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<C-Up>', ':resize -3<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<C-Down>', ':resize +3<CR>', { silent = true, noremap = true })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true, noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true, noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true, noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true, noremap = true })

-- In-buffer horizontal scrolling with Ctrl+Shift+L/R
vim.keymap.set('n', '<C-S-Right>', 'z30l', { silent = true, noremap = true })
vim.keymap.set('n', '<C-S-Left>', 'z30h', { silent = true, noremap = true })

-- Doc comment generation
vim.keymap.set('n', '<Leader>cd', ":lua require('neogen').generate()<CR>", { noremap = true, silent = true, desc = '[C]ode [D]ocumentation comment' })

-- Closes all buffers except current one,
-- %bd = delete all buffers.
-- e# = open the last buffer for editing (current buffer).
-- bd# deletes [No Name] buffer that gets created when you use %bd.
vim.keymap.set('n', '<leader>br', ':%bd|e#|bd#<CR>', { desc = '[B]uffer [R]eset (close all except current)', silent = true, noremap = true })

-- Neotree
vim.keymap.set('n', '<leader>bs', ':Neotree toggle show buffers right<CR>', { desc = '[B]uffer [S]how in Neotree', silent = true, noremap = true })
vim.keymap.set('n', 'gd', ':Neotree float reveal_file=<cfile> reveal_force_cwd<CR>', { desc = '[G]oto [D]efinition in Neotree', silent = true, noremap = true })
vim.keymap.set('n', '<leader>n', ':Neotree toggle left reveal_force_cwd<CR>', {
  desc = '[N]eotree toggle in current directory',
  silent = true,
  noremap = true,
})

-- Lazygit
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- When lyf give you lemons
vim.keymap.set('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>')
