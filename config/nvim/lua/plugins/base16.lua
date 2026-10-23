return {
  "RRethy/base16-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local colors = dofile(vim.fn.expand("~/.local/share/nvim/matugen-colors.lua"))
    require("base16-colorscheme").setup(colors)
  end,
}
