-- lazy.nvim
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    explorer = {
      -- your explorer configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = true,
          exclude = {
            "node_modules",
            ".git",
            "__pycache__",
            ".venv",
            ".mypy_cache",
            ".hypothesis",
            ".pytest_cache",
            ".ruff_cache",
            "target",
          },
        },
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { "__pycache__" },
        },
      },
    },
  },
}
