local lspconfig = require("lspconfig")

-- Add nvim-cmp capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "rust_analyzer" }, -- preload your faves
})

-- Hook mason-installed servers to lspconfig
require("mason-lspconfig").setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities,
    })
  end,
})

require('lspconfig').rust_analyzer.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
