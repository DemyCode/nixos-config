return {
  -- plugin: auto-save.nvim
  -- function: auto save changes
  -- src: https://github.com/pocco81/auto-save.nvim
  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    opts = {
      debounce_delay = 1000,
      trigger_events = { "InsertLeave" },
      enable = true,
    },
  },
}
