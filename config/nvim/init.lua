-- Leader
vim.g.mapleader = " "

-- Номера строк
vim.opt.number = true
vim.opt.relativenumber = true

-- Отступы
vim.opt.expandtab = true      -- табы заменяются пробелами
vim.opt.shiftwidth = 2        -- размер автоотступа
vim.opt.tabstop = 2           -- сколько пробелов показывает таб
vim.opt.softtabstop = 2       -- сколько пробелов при нажатии Tab
vim.opt.smartindent = true    -- умный автоотступ

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Интерфейс
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Буфер обмена
vim.opt.clipboard = "unnamedplus"

-- Отступ при переносе строк
vim.opt.breakindent = true

-- Не создавать swap-файлы
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Скорость обновления
vim.opt.updatetime = 250


vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi CursorLineNr guibg=NONE ctermbg=NONE
  hi FoldColumn guibg=NONE ctermbg=NONE
]])
