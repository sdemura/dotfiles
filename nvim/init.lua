-- Load core configuration
require("options")
require("keymaps")
require("autocmds")

-- Plugin hooks (must be defined before vim.pack.add)
require("pack-hooks")

-- Install and load plugins
require("plugins")
