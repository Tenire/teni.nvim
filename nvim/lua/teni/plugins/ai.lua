-- Gemini AI Integration via ToggleTerm
-- This module manually sets up the Gemini terminal and keymaps immediately.

local gemini_term = nil

local function get_or_create_term()
  if gemini_term then return gemini_term end

  -- Ensure toggleterm is loaded
  local status_ok, _ = pcall(require, "toggleterm")
  if not status_ok then
    vim.notify("ToggleTerm not found!", vim.log.levels.ERROR)
    return nil
  end

  local Terminal = require('toggleterm.terminal').Terminal

  gemini_term = Terminal:new({
    cmd = 'gemini',
    direction = 'vertical',
    size = function(term)
      if term.direction == "horizontal" then
        return 20 -- default height
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.45)
      end
    end,
    hidden = true, -- Keep running in background
    on_open = function(term)
      vim.cmd('startinsert!')
      -- Ensure buffer hides instead of closing to preserve history
      vim.api.nvim_buf_set_option(term.bufnr, 'bufhidden', 'hide')
      
      -- FORCE RESIZE
      if term.direction == "vertical" then
         local width = math.floor(vim.o.columns * 0.45)
         vim.api.nvim_win_set_width(term.window, width)
      end

      -- Special Keymaps for Gemini Terminal ONLY
      local opts = { noremap = true, silent = true, buffer = term.bufnr }
      vim.keymap.set('t', '<Esc>', '<cmd>lua _G.toggle_gemini()<CR>', opts)

      -- AUTO-FOCUS (i回焦)
      vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        buffer = term.bufnr,
        callback = function()
          vim.schedule(function()
            if term:is_open() then
              vim.cmd('startinsert!')
            end
          end)
        end,
      })
    end,
  })

  return gemini_term
end

-- Smart Diff Function: Extract code from terminal and diff with current buffer
function _G.gemini_diff()
  local term = get_or_create_term()
  
  if not term or not term.bufnr or not vim.api.nvim_buf_is_valid(term.bufnr) then
    vim.notify("Gemini terminal not active", vim.log.levels.WARN)
    return
  end

  -- Helper to strip ANSI escape codes (Robust)
  local function strip_ansi(str)
    -- 1. Remove CSI sequences (colors, cursor, etc)
    str = str:gsub("\27%[[0-9;?]*[a-zA-Z]", "")
    -- 2. Remove OSC sequences (title setting etc)
    str = str:gsub("\27%].-\7", "")
    return str
  end

  -- Get all lines from Gemini buffer
  local lines = vim.api.nvim_buf_get_lines(term.bufnr, 0, -1, false)
  local code_lines = {}
  local in_block = false
  local block_end_found = false

  -- Search from bottom to find the last code block ```...```
  for i = #lines, 1, -1 do
    local line = lines[i]
    local clean_line = strip_ansi(line)
    
    -- Relaxed check: just look for triple backticks anywhere in the line
    if clean_line:find("```") then
      if not in_block then
        in_block = true -- Found the closing ``` (bottom one)
      else
        -- Found the opening ``` (top one)
        block_end_found = true
        break 
      end
    elseif in_block then
      table.insert(code_lines, 1, strip_ansi(line))
    end
  end

  if #code_lines == 0 then
    vim.notify("No code block found in visible Gemini history. Make sure the code is on screen!", vim.log.levels.WARN)
    return
  end

  -- Prepare for diff
  local current_buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[current_buf].filetype

  -- Create a scratch buffer for the AI code
  vim.cmd("vnew")
  local diff_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, code_lines)
  vim.bo[diff_buf].filetype = ft
  vim.bo[diff_buf].buftype = "nofile"
  vim.api.nvim_buf_set_name(diff_buf, "Gemini_Suggestion")

  -- Start diff
  vim.cmd("diffthis")
  -- Return to original window to set it as diff target too
  local win_ids = vim.api.nvim_list_wins()
  for _, win in ipairs(win_ids) do
    if vim.api.nvim_win_get_buf(win) == current_buf then
      vim.api.nvim_set_current_win(win)
      vim.cmd("diffthis")
      break
    end
  end
  
  vim.notify("Diffing with last detected code block...", vim.log.levels.INFO)
end

-- Function to move the terminal around
function _G.move_gemini(dir)
  local term = get_or_create_term()
  if term then
    if term:is_open() then
      term:close()
    end
    term.direction = dir
    -- Reset size logic based on new direction will happen on next open
    term:open()
  end
end

-- Global toggle function
function _G.toggle_gemini()
  local term = get_or_create_term()
  if term then
    term:toggle()
  end
end

-- Global send function
function _G.send_to_gemini()
  local mode = vim.api.nvim_get_mode().mode
  -- Support Visual mode (v), Visual Line (V), and Block (\22)
  if mode == 'v' or mode == 'V' or mode == '\22' then
    vim.cmd('noau normal! "vy') -- Yank selection to register v
    local text = vim.fn.getreg('v')
    
    local term = get_or_create_term()
    if not term then return end

    if not term:is_open() then
       term:open()
    end
    
    -- Send the text safely
    pcall(function() term:send(text) end)
  else
    print("Please select text first")
  end
end

-- Set Keymaps IMMEDIATELY
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>lua _G.toggle_gemini()<CR>', vim.tbl_extend('force', opts, { desc = 'Toggle Gemini AI' }))
vim.api.nvim_set_keymap('v', '<leader>gs', '<cmd>lua _G.send_to_gemini()<CR>', vim.tbl_extend('force', opts, { desc = 'Send selection to Gemini' }))
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>lua _G.gemini_diff()<CR>', vim.tbl_extend('force', opts, { desc = 'Diff last Gemini code block' }))

-- Move Gemini Window Keys (Lowercase for ergonomics)
vim.api.nvim_set_keymap('n', '<leader>gh', '<cmd>lua _G.move_gemini("vertical")<CR>', vim.tbl_extend('force', opts, { desc = 'Move Gemini Right' }))
vim.api.nvim_set_keymap('n', '<leader>gl', '<cmd>lua _G.move_gemini("vertical")<CR>', vim.tbl_extend('force', opts, { desc = 'Move Gemini Right' }))
vim.api.nvim_set_keymap('n', '<leader>gj', '<cmd>lua _G.move_gemini("horizontal")<CR>', vim.tbl_extend('force', opts, { desc = 'Move Gemini Down' }))
vim.api.nvim_set_keymap('n', '<leader>gk', '<cmd>lua _G.move_gemini("horizontal")<CR>', vim.tbl_extend('force', opts, { desc = 'Move Gemini Down' }))
-- Note: ToggleTerm mainly supports 'vertical' (right) and 'horizontal' (bottom) easily. 
-- True Left/Top requires more work, but 'vertical' usually defaults to right split.

-- Return empty table because we've done everything manually
return {}