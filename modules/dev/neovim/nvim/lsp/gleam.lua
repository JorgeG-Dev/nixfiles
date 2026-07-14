return {
	cmd = {
		"gleam",
		"lsp",
	},
	filetypes = {
		"gleam",
	},
	root_markers = {
		".git",
		"gleam.toml",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}
