require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "~/Documents/mindspace/content",
    },
  },
  completion = {
    nvim_cmp = true,  -- integrates with nvim-cmp
  },
  templates = {
    folder = "reference/templates",
    date_format="%Y-%m-%d",
    time_format="%X",
  },
})
vim.opt.conceallevel = 2
