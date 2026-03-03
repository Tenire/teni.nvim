return {
  -- Fcitx5 integration for Chinese input
  {
    'h-hg/fcitx.nvim',
    lazy = false,
  },

  -- Markdown Rendering (in-editor preview)
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      -- Render headings with different highlights
      headings = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      -- Render code blocks with background
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        width = 'full',
      },
      -- Render checkboxes
      checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰱒 ' },
      },
    },
    keys = {
      {
        '<leader>mp',
        '<cmd>RenderMarkdown toggle<cr>',
        desc = 'Toggle Markdown Rendering',
      },
    },
  },

  -- Xmake build system integration
  {
    'Mythos-404/xmake.nvim',
    version = '^3',
    lazy = true,
    event = 'BufReadPost',
    config = true,
  },
}
