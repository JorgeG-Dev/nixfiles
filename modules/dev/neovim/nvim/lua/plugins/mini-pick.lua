local pick = require("mini.pick")
pick.setup()
vim.keymap.set("n", "<leader>ff", pick.builtin.files)
vim.keymap.set("n", "<leader>fg", pick.builtin.grep_live)
