return {
	cmd = {
		"rust-analyzer",
	},
	filetypes = {
		"rust",
	},
	root_markers = {
		".git",
		"Cargo.lock",
		"Cargo.toml",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
			checkOnSave = true,
			procMacro = {
				enable = true,
			},
		},
	},
}
