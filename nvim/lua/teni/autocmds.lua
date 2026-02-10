local api = vim.api

-- Fcitx5 auto-switch with state restoration
local fcitx_group = api.nvim_create_augroup('FcitxAutoSwitch', { clear = true })
local fcitx_state = 1 -- Default to 1 (Inactive/English)

api.nvim_create_autocmd('InsertLeave', {
  group = fcitx_group,
  callback = function()
    if vim.fn.executable('fcitx5-remote') == 1 then
      -- Get current state (1=Inactive, 2=Active)
      local current_state = tonumber(vim.fn.system('fcitx5-remote'))
      fcitx_state = current_state
      
      -- If active (Chinese), switch to inactive (English) for Normal mode
      if current_state == 2 then
        vim.fn.system('fcitx5-remote -c')
      end
    end
  end,
  desc = 'Switch fcitx to English when leaving insert mode',
})

api.nvim_create_autocmd('InsertEnter', {
  group = fcitx_group,
  callback = function()
    if vim.fn.executable('fcitx5-remote') == 1 then
      -- Restore previous state
      if fcitx_state == 2 then
        vim.fn.system('fcitx5-remote -o')
      end
    end
  end,
  desc = 'Restore fcitx state when entering insert mode',
})

api.nvim_create_autocmd('VimLeave', {
  group = fcitx_group,
  callback = function()
    if vim.fn.executable('fcitx5-remote') == 1 then
      -- If we were in Chinese mode before, restore it on exit
      -- so the user isn't stuck in English in the terminal
      if fcitx_state == 2 then
        vim.fn.system('fcitx5-remote -o')
      end
    end
  end,
  desc = 'Restore fcitx state when exiting Neovim',
})

-- Indentation overrides
api.nvim_create_autocmd('FileType', {
  pattern = { 'yaml' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = 'Set indentation to 2 spaces for specific filetypes',
})