-- return {
-- 	"ellisonleao/gruvbox.nvim",
-- 	lazy = false,
-- 	name = "gruvbox",
-- 	priority = 997,
-- 	config = function()
-- 		vim.cmd.colorscheme("gruvbox")
-- 	end,
-- }



return {
    "AlphaTechnolog/pywal.nvim",
    lazy = false,
    priority = 1000,
    enabled = vim.env.CODEX_SHELL ~= "1",
    config = function()
        -- Set up pywal and load the colors
        require("pywal").setup()

    end,
}
