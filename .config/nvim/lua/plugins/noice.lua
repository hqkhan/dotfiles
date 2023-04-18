local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
}

function M.config()
  require("noice").setup({
    views = {
      cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
      }
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = false
      }
    },
    cmdline = {
      enabled = true, -- enables the Noice cmdline UI
      view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    },

    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      cmdline_output_to_split = false,
      lsp_doc_border = true,
    },
  })
end

return M
