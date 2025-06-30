local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
   vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
   }
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
   -- LSP
   { "neovim/nvim-lspconfig" },
   {
      "mason-org/mason.nvim",
      version = "v1.32.0",
   },
   {
      "mason-org/mason-lspconfig.nvim",
      version = "v1.32.0",
   },
   { "hrsh7th/nvim-cmp" }, -- Completion
   { "hrsh7th/cmp-nvim-lsp" },
   { "hrsh7th/cmp-buffer" },
   { "hrsh7th/cmp-path" },
   { "L3MON4D3/LuaSnip" },

   -- File browsing
   {
      "stevearc/oil.nvim",
      version = "v2.10.0",
   },
}

require("plugins.oil_configuration")
require("plugins.lsp-configuration")

local settings = {
   number = true,
   cursorline = true,
   relativenumber = false,
   ignorecase = true,     -- ignore case
   smartcase = true,      -- but don't ignore it, when search string contains upper letters
   incsearch = true,
   visualbell = true,
   expandtab = true,
   ruler = true,
   smartindent = true,
   hlsearch = true,
   autoindent = true,
   swapfile = false,
   virtualedit = "all",
   backspace = { "indent", "eol", "start" }, -- allow backspacing over everything in insert mode
   mouse = "a",                              -- mouse support
   listchars = { tab = "--", extends = ">", precedes = "<", space = "·"},
   list = true,
   tabstop = 4,
   shiftwidth = 4,
   backup = false,
   writebackup = false,
   signcolumn = "yes",
}

for k, v in pairs(settings) do
   vim.opt[k] = v
end
