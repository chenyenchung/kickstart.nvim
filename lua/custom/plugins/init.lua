-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
M = {}

require 'custom.plugins.keymap'

vim.filetype.add {
  extension = {
    nf = 'nextflow',
    ['nf.test'] = 'nextflow',
    config = 'nextflow',
  },
}
vim.treesitter.language.register('groovy', 'nextflow')

return M
