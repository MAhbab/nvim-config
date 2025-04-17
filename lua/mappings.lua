local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
map("n", "<leader>ld", "<cmd>Telescope lsp_document_symbols<cr>", opts)

-- Copy file path + line number to clipboard
map("n", "<leader>y", [[:let @+ = expand("%:p") . ":" . line(".")<CR>]], { noremap = true })

-- Codeium
vim.g.codeium_disable_bindings = 1
map("i", "<C-g>", 'codeium#Accept()', { expr = true, silent = true })
map("i", "<C-h>", 'codeium#AcceptNextWord()', { expr = true, silent = true })
map("i", "<C-j>", 'codeium#AcceptNextLine()', { expr = true, silent = true })
map("i", "<C-;>", '<Cmd>call codeium#CycleCompletions(1)<CR>', opts)
map("i", "<C-,>", '<Cmd>call codeium#CycleCompletions(-1)<CR>', opts)
map("i", "<C-x>", '<Cmd>call codeium#Clear()<CR>', opts)

-- LSP navigation bindings
map('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = 'Go to definition' })
map('n', 'gp', vim.lsp.buf.hover, { noremap = true, silent = true, desc = 'Peek (hover) definition' })
map('n', '<leader>ld', '<cmd>Telescope lsp_document_symbols<cr>', { noremap = true, silent = true, desc = 'List document symbols' })
map('n', '<leader>lw', '<cmd>Telescope lsp_workspace_symbols<cr>', { noremap = true, silent = true, desc = 'List workspace symbols' })
map('n', '<Leader>K', vim.diagnostic.open_float, { desc = 'Show diagnostics in floating window' })
