require("oil").setup {
   default_file_explorer = true,
   view_options = {
      show_hidden = true,
   },
}

vim.keymap.set("n", "_", "<CMD>Oil<CR>", { desc = "Open parent directory" })
