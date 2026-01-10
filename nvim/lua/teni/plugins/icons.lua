return {
  {
    'nvim-tree/nvim-web-devicons',
    enabled = vim.g.have_nerd_font,
    config = function()
      require('nvim-web-devicons').setup {}
    end,
  },
}
