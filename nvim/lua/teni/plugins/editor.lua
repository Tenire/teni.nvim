return {
  -- Add/Change/Delete surrounding delimiter pairs with ease
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {}
    end,
  },

  -- Smart comments
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('Comment').setup()
    end,
  },

  -- Jump anywhere in the document
  {
    'smoka7/hop.nvim',
    version = '*',
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
    end,
    keys = {
      {
        'e',
        function()
          require('hop').hint_words()
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Hop Word',
      },
      {
        'E',
        function()
          require('hop').hint_patterns()
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Hop Pattern',
      },
    },
  },

  -- Terminal management
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<C-\\>', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal (Float)' },
      { '<leader>tt', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle Terminal (Float)' },
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', desc = 'Toggle Terminal (Horizontal)' },
      { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=60<cr>', desc = 'Toggle Terminal (Vertical)' },
    },
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)

      function _G.set_terminal_keymaps()
        local map_opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], map_opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], map_opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], map_opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], map_opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], map_opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], map_opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], map_opts)
        -- Allow toggling even in terminal mode
        vim.keymap.set('t', '<C-\\>', [[<Cmd>ToggleTerm<CR>]], map_opts)
      end

      -- if you only want these mappings for toggle term use term open
      vim.api.nvim_create_autocmd('TermOpen', {
        pattern = 'terminal*',
        callback = function()
          set_terminal_keymaps()
        end,
      })
    end,
  },

  -- Pretty diagnostics list
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xq', '<cmd>Trouble quickfix toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },

  -- Highlight TODOs
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VimEnter',
    opts = { signs = false },
  },
}
