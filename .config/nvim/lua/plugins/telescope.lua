-- ~/.config/nvim/lua/plugins/telescope.lua
return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",  -- ensure Treesitter loads first
        },
        config = function()
            local ts_ok, ts_utils = pcall(require, "telescope.previewers.utils")
            if ts_ok and ts_utils then
                -- override ts_highlighter to prevent ft_to_lang errors
                local original_ts_highlighter = ts_utils.ts_highlighter
                ts_utils.ts_highlighter = function(...)
                    local ok, _ = pcall(original_ts_highlighter, ...)
                    if not ok then
                        return -- silently ignore unsupported filetypes
                    end
                end
            end

            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    preview = {
                        treesitter = true,  -- keep TS preview
                    },
                },
                extensions = {
                    ["ui-select"] = require("telescope.themes").get_dropdown({}),
                },
            })
            telescope.load_extension("ui-select")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", builtin.find_files)
            vim.keymap.set("n", "<A-f>", builtin.live_grep)

            -- Global function for folder search
            _G.search_and_scope_into_directory = function()
                builtin.find_files({
                    prompt_title = "Search Directories",
                    find_command = { "fd", "--type", "d", "--hidden", "--follow" },
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require("telescope.actions")
                        actions.select_default:replace(function()
                            local selection = require("telescope.actions.state").get_selected_entry()
                            vim.cmd("cd " .. selection.path)
                            actions.close(prompt_bufnr)
                        end)
                        return true
                    end,
                })
            end
            vim.keymap.set("n", "<A-d>", _G.search_and_scope_into_directory)
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
}
