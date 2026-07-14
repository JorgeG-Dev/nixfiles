local parsers = {
	"c",
	"python",
	"rust",
	"make",
	"gleam",
	"elixir",
	"zig",
	"nix",
	"lua",
	"bash",
	"dockerfile",
	"go",
	"cpp",
	"toml",
}

-- Not every tree-sitter parser is the same as the file type detected
-- So the patterns need to be registered more cleverly
local patterns = {}
for _, parser in ipairs(parsers) do
	local parser_patterns = vim.treesitter.language.get_filetypes(parser)
	for _, pp in pairs(parser_patterns) do
		table.insert(patterns, pp)
	end
end

vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo[0][0].foldmethod = "expr"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.api.nvim_create_autocmd("FileType", {
	pattern = patterns,
	callback = function()
		vim.treesitter.start()
	end,
})
