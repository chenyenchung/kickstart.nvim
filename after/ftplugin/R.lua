vim.bo.shiftwidth = 2

M = {}

function M.start_r()
  local winnr = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(winnr)
  local root = vim.fn.input('Starting R session at: ', vim.uv.cwd(), 'dir')

  vim.cmd.vnew()
  vim.cmd.wincmd 'l'
  local term_winnr = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(term_winnr, 80)

  local success, chan = pcall(vim.fn.jobstart, 'R --no-save', {
    cwd = root,
    term = true,
    on_exit = function(jobid, data, event)
      if M.channel == jobid then
        M.channel = nil
        M.term_bufnr = nil
      end
    end,
  })

  if success then
    M.channel = chan
    M.term_bufnr = vim.api.nvim_get_current_buf()
  end

  if success then
    vim.api.nvim_set_current_win(winnr)
    vim.api.nvim_win_set_cursor(winnr, cursor_pos)
  end

  return success
end

function M.send2term(code)
  if M.channel then
    vim.fn.chansend(M.channel, code)
    local term_winnr = vim.fn.win_findbuf(M.term_bufnr)
    local lastline = vim.api.nvim_buf_line_count(M.term_bufnr)
    vim.api.nvim_win_set_cursor(term_winnr[1], { lastline, 1 })
  else
    vim.notify('[ERROR] Is there an R session running?', ERROR)
  end
end

vim.keymap.set('n', '<S-CR>', function()
  local line = vim.api.nvim_get_current_line()
  local winnr = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(winnr))
  local is_comment, _ = string.find(line, '#')

  while line == '' or is_comment == 1 do
    row = row + 1
    col = 1
    vim.api.nvim_win_set_cursor(winnr, { row, col })
    line = vim.api.nvim_get_current_line()
    is_comment, _ = string.find(line, '#')
  end

  if M.channel == nil then
    M.start_r()
  end

  local sent, _ = pcall(M.send2term, { line, '' })
  if sent == false then
    vim.notify('[ERROR] Cannot send the line to R session', ERROR)
  end

  local stepforward = 1
  if row == (vim.api.nvim_buf_line_count(bufnr)) then
    stepforward = 0
  end
  vim.api.nvim_win_set_cursor(winnr, { row + stepforward, col })
end)

return M
