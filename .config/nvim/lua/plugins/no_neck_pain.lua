local M = {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  -- "VeryLazy" hides splash screen
  event = "BufReadPre",
}

M.config = function()
  require("no-neck-pain").setup({
    fallbackOnBufferDelete = true,
    autocmds = {
        enableOnVimEnter = false,
        enableOnTabEnter = false,
        reloadOnColorSchemeChange = false,
    },
    mappings = {
        enabled = true,
        toggle = "<leader>zn",
    },
    buffers = {
        left = {
            bo = {
                filetype = "md",
            },
            scratchPad = {
                enabled = false,
                fileName = "notes",
                location = "~/",
            },
        },
        right = {
            enabled = false,
        },
    },
  })
end
return M
