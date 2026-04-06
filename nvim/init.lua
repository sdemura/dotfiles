-- Load core configuration
require("options")
require("keymaps")
require("autocmds")

-- Plugin hooks (must be defined before vim.pack.add)
require("pack-hooks")

-- Install and load plugins
require("plugins")

-- Mock nvim-web-devicons before plugin/ files load
local MiniIcons = require("mini.icons")
MiniIcons.setup({})
MiniIcons.mock_nvim_web_devicons()
