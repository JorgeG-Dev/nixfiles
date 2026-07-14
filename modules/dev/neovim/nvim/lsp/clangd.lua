return {
	cmd = {
		"clangd",
	},
	filetypes = {
		"c",
	},
	root_markers = {
		".git",
		".clang-format",
		"CMakeLists.txt",
		"Makefile",
		"compile-commands.json",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}
