return {

    --[[
    {

        'shaunsingh/nord.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            -- Example config in lua
            vim.g.nord_contrast = false
            vim.g.nord_borders = true
            vim.g.nord_disable_background = true
            vim.g.nord_italic = false
            vim.g.nord_uniform_diff_background = true
            vim.g.nord_bold = false

            -- Load the colorscheme
            require('nord').set()
        end
    }
    --]]
    {
{
		'sainnhe/gruvbox-material',
		name = 'gruvbox-material',
        priority = 1000,
		config = function()
			vim.g.gruvbox_material_better_performance = 1
			-- Fonts
			vim.g.gruvbox_material_disable_italic_comment = 1
			vim.g.gruvbox_material_enable_italic = 0
			vim.g.gruvbox_material_enable_bold = 0
			vim.g.gruvbox_material_transparent_background = 1
			-- Themes
			--vim.g.gruvbox_material_foreground = 'mix'
			--vim.g.gruvbox_material_background = 'hard'
			--vim.g.gruvbox_material_ui_contrast = 'high' -- The contrast of line numbers, indent lines, etc.
			--vim.g.gruvbox_material_float_style = 'dim' -- Background of floating windows

            vim.cmd('colorscheme gruvbox-material')
            end
        },
    }
}

