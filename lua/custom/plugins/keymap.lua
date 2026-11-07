local utils = require 'custom.plugins.utils'

-- Comment toggle
vim.keymap.set('n', '<C-/>', 'gcc', { desc = '[ ] Toggle comment', remap = true })
vim.keymap.set('v', '<C-/>', 'gc', { desc = '[ ] Toggle comment', remap = true })

-- (doom)emacs-flavored keymaps
-- Run current line with lua interpreter
vim.keymap.set('n', '<C-x><C-e>', '<Cmd>.lua<CR>', { desc = 'Evaluate current line' })
vim.keymap.set('v', '<C-x><C-e>', '<Cmd>lua<CR>', { desc = 'Evaluate selected region' })

-- Buffer-related
vim.keymap.set('n', '<leader>bk', function()
  if utils.count_loaded_bufs() == 1 then
    vim.api.nvim_create_buf(true, true)
  end
  vim.bo.buflisted = false
  vim.api.nvim_buf_delete(0, { unload = true })
end, { desc = 'Kill current buffer' })
vim.keymap.set('n', '<leader>b]', '<Cmd>bnext<CR>', { desc = 'Go to the next buffer' })
vim.keymap.set('n', '<leader>b[', '<Cmd>bprevious<CR>', { desc = 'Go to the previous buffer' })

-- Window-related
vim.keymap.set('n', '<leader>wd', '<C-w>c', { desc = '[C]lose split' })
vim.keymap.set('n', '<leader>wv', '<Cmd>vsplit<CR>', { desc = '[V]ertical split' })
vim.keymap.set('n', '<leader>ws', '<Cmd>split<CR>', { desc = 'Horizontal [s]plit' })
