-- Load core configuration modules
require 'teni.options'
require 'teni.keymaps'
require 'teni.autocmds'

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup({
  -- UI Modules
  require 'teni.plugins.ui',           -- Lualine, Bufferline, Noice, ZenMode
  require 'teni.plugins.icons',        -- Devicons
  require 'teni.plugins.greeter',      -- Dashboard
  require 'teni.plugins.indent_line',  -- Indent guides
  require 'teni.plugins.neo-tree',     -- File explorer

  -- Editor Modules
  require 'teni.plugins.editor',       -- Surround, Comment, Hop, Toggleterm, Trouble
  require 'teni.plugins.telescope',    -- Fuzzy finder
  require 'teni.plugins.gitsigns',     -- Git integration
  require 'teni.plugins.autopairs',    -- Auto pairs
  
  -- Coding Modules
  require 'teni.plugins.lsp',          -- LSP, Mason, Conform, Blink.cmp
  require 'teni.plugins.treesitter',   -- Syntax highlighting
  require 'teni.plugins.coding',       -- Fcitx, Markdown
  require 'teni.plugins.lint',         -- Linting
  require 'teni.plugins.debug',        -- DAP (Debug)
  require 'teni.plugins.ai',           -- AI features

  -- Additional standalone plugins
  {
    'NMAC427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = { Transparent = true },
    config = function()
      vim.cmd.colorscheme 'tokyonight'
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', ctermbg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'NONE', ctermbg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'NONE', ctermbg = 'NONE' })
    end,
  },
  {
    'xiyaowong/transparent.nvim',
    priority = 999,
  },
  {
    'ggandor/leap.nvim',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
      vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    cmd = { 'TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight', 'TmuxNavigatePrevious' },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  {
    'NeogitOrg/neogit',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim', 'nvim-telescope/telescope.nvim' },
    cmd = 'Neogit',
    keys = { { '<leader>ng', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' } },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙', keys = '🗝', plugin = '🔌',
      runtime = '💻', require = '🌙', source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
})
-- vim: ts=2 sts=2 sw=2 et