return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
      -- I find auto open annoying, keep in mind setting this option will require setting
      -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
      vim.g.molten_auto_open_output = false

      -- this guide will be using image.nvim
      -- Don't forget to setup and install the plugin if you want to view image outputs
      vim.g.molten_image_provider = "image.nvim"

      -- optional, I like wrapping. works for virt text and the output window
      vim.g.molten_wrap_output = true

      -- Output as virtual text. Allows outputs to always be shown, works with images, but can
      -- be buggy with longer images
      vim.g.molten_virt_text_output = true

      -- this will make it so the output shows up below the \`\`\` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { "<localleader>e", "<cmd>MoltenEvaluateOperator<CR>", desc = "evaluate operator" },
      { "<localleader>os", "<cmd>noautocmd MoltenEnterOutput<CR>", desc = "open output window" },
      { "<localleader>oh", "<cmd>MoltenHideOutput<CR>", desc = "close output window" },
      { "<localleader>rr", "<cmd>MoltenReevaluateCell<CR>", desc = "re-eval cell" },
      { "<localleader>r", "<cmd>MoltenEvaluateVisual<CR>", desc = "execute visual selection" },
      { "<localleader>md", "<cmd>MoltenDelete<CR>", desc = "delete Molten cell" },
      { "<localleader>mx", "<cmd>MoltenOpenInBrowser<CR>", desc = "open output in browser" },
    },
    dependencies = {
      { "3rd/image.nvim" },
    },
    lazy = false,
  },
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    config = true,
  },
}
