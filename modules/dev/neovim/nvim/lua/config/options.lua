-- First character for plugin commands
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Keep thick cursor for insert mode
vim.opt.guicursor = ""

-- Enable line numbers and relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Set tab options
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Indent settings
vim.opt.smartindent = true

-- Keep everything on one line instead of wrapping
vim.opt.wrap = false

-- Undo settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'
vim.opt.undofile = true

-- Search options
vim.opt.hlsearch = false -- don't keep search highlighted
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
