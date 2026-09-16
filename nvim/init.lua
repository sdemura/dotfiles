-- Load core configuration
require("options")
require("keymaps")
require("autocmds")

-- Install and load plugins
require("plugins")

-- Mock nvim-web-devicons before plugin/ files load
local MiniIcons = require("mini.icons")
MiniIcons.setup({})
MiniIcons.mock_nvim_web_devicons()

-- Experimental core UI (0.12+): fewer "Press ENTER" prompts, cmdline highlighting, etc.
pcall(function() require("vim._core.ui2").enable() end)
