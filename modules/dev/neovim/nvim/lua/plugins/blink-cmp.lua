require("blink.cmp").setup({
	-- 'default' for super-tab like behavior (Tab for next/select)
	-- 'enter' to use Enter to select and accept completions
	-- 'super-tab' can be configured for more advanced mappings
	keymap = { preset = "default" },

	appearance = {
		-- Sets the fallback highlight groups to nvim-cmp's or blink's defaults
		nerd_font_variant = "mono",
	},

	completion = { documentation = { auto_show = false } },

	sources = {
		-- Enable desired completion providers
		default = { "lsp", "path", "snippets", "buffer" },
	},

	fuzzy = { implementation = "prefer_rust_with_warning" },
})
