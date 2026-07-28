-- Path for lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.cmd("set number")
require("vim-options")
vim.opt.termguicolors = true
require("lazy").setup("plugins")

if vim.env.CODEX_SHELL == "1" then
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
end
