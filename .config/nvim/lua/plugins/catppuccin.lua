return {
    'catppuccin/nvim',
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            transparent_background = true,

            styles = {
                floats = "normal",
            },

            custom_highlights = function(colors)
                return {
                    FloatBorder = { fg = "#B7BDF8" },
                }
            end,

            overrides = function(colors)
                return {
                    ["@markup.link.url.markdown_inline"] = { link = "Special" },
                    ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" },
                    ["@markup.italic.markdown_inline"] = { link = "Exception" }, 
                    ["@markup.raw.markdown_inline"] = { link = "String" }, 
                    ["@markup.list.markdown"] = { link = "Function" },
                    ["@markup.quote.markdown"] = { link = "Error" },
                    ["@markup.list.checked.markdown"] = { link = "WarningMsg" },
                }
            end,
        })

        vim.cmd.colorscheme "catppuccin"
    end,
}

