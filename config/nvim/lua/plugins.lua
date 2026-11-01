-- File tree
require("nvim-tree").setup({
  view = { width = 30 },
  renderer = { group_empty = true },
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File tree" })

-- Statusline and buffer tabs
require("lualine").setup({ options = { theme = "auto" } })
require("bufferline").setup({
  options = {
    offsets = { { filetype = "NvimTree", text = "Files", separator = true } },
  },
})
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Search
local tb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", tb.live_grep,  { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", tb.buffers,    { desc = "Buffers" })

-- Treesitter highlighting
vim.api.nvim_create_autocmd("FileType", {
  callback = function() pcall(vim.treesitter.start) end,
})

-- Misc
require("gitsigns").setup()
require("nvim-autopairs").setup()
require("which-key").setup()

-- Completion
require("blink.cmp").setup({
  keymap = { preset = "super-tab" },
  completion = { documentation = { auto_show = true } },
})

-- LSP
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
vim.lsp.enable({ "nil_ls" })
vim.diagnostic.config({ virtual_text = true })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

