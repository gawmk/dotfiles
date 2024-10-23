return {

    {

        'williamboman/mason.nvim',
        lazy = false,
        config = function()
            require("mason").setup()
        end

    },

    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        config = function()
            require("mason-lspconfig").setup()
        end

    },

    {

        'neovim/nvim-lspconfig',

        config = function()
            local function load_standard_keymaps()
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
                vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
                vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = 0 })
                vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = 0 })
                vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>" , { buffer = 0 })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename , { buffer = 0 })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })

            end

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup{

                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                },

                on_attach = function()
                    load_standard_keymaps()
                end
            }

            lspconfig.clangd.setup{
                on_attach = function()
                    load_standard_keymaps()
                end
            }


        end

    },

    -- jdtls setup
    { 'mfussenegger/nvim-jdtls' },
}
