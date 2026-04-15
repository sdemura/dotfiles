require("mini.indentscope").setup({
	symbol = "│",
	draw = { animation = require("mini.indentscope").gen_animation.none() },
})
require("mini.cursorword").setup({ delay = 50 })
require("mini.ai").setup({})
require("mini.bracketed").setup({})
require("mini.diff").setup({})
require("mini.trailspace").setup({})
require("mini.surround").setup({
	mappings = { add = "ys", delete = "ds", replace = "cs", find = "", find_left = "", highlight = "", update_n_lines = "" },
	n_lines = 50,
})
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = "Surround visual selection" })

require("mini.jump2d").setup({
	labels = "etovxqpdygfblzhckisuran",
	mappings = { start_jumping = "s" },
	view = { dim = true },
})

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

require("mini.pairs").setup({})

require("mini.tabline").setup({
	show_icons = false,
	tabpage_section = "right",
})
vim.api.nvim_create_autocmd({ "TabNew", "TabClosed", "VimEnter" }, {
	callback = function()
		vim.o.showtabline = #vim.api.nvim_list_tabpages() > 1 and 2 or 0
	end,
})
vim.o.showtabline = 0

local MiniMisc = require("mini.misc")
MiniMisc.setup({})
MiniMisc.setup_restore_cursor()
