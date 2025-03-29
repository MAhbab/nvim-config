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
})
vim.opt.conceallevel = 2
