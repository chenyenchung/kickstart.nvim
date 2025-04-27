M = {}

M.count_loaded_bufs = function()
  local buflist = vim.api.nvim_list_bufs()
  local abuflen = 0
  for i = 1, #buflist do
    if vim.api.nvim_get_option_value('buflisted', { buf = buflist[i] }) then
      abuflen = abuflen + 1
    end
  end
  return abuflen
end

return M
