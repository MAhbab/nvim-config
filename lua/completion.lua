-- lua/completion.lua
local cmp = require('cmp')
local luasnip = require('luasnip')
require('user.obsidian.patch')

local vault_root = "/Users/mahfuj/Documents/mindspace/content"

local function extract_relative_markdown_path(full_path)
  if not full_path or not full_path:match("%.md$") then
    return nil
  end
  local rel = full_path:gsub("^" .. vim.pesc(vault_root) .. "/", ""):gsub("%.md$", "")
  return rel
end

cmp.setup({
  completion = {
    keyword_pattern = [[\k\+]],
    keyword_length = 1,
  },
  experimental = {
    ghost_text = false,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      if entry.source.name == "obsidian" then
        vim_item.abbr = entry.completion_item.label or vim_item.abbr
      end
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        local entry = cmp.get_selected_entry()
        local doc = entry.completion_item.documentation
        local source = entry.source.name

        if source == "obsidian" and doc and type(doc) == "table" and doc.value then
          local full_path = doc.value:match("%*%*path:%*%* `%s*(.-)%s*`")
          print("📄 Full path from doc: " .. tostring(full_path))
          local relative_path = extract_relative_markdown_path(full_path)
          print("🧭 Relative path: " .. tostring(relative_path))

          if relative_path then
            -- Get current cursor position
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            local line = vim.api.nvim_get_current_line()

            -- Assume nvim-cmp inserted a filename (the word under cursor), replace it entirely
            local start_col = col
            while start_col > 0 and line:sub(start_col, start_col):match("[%w%-%_/]") do
              start_col = start_col - 1
            end

            local before = line:sub(1, start_col)
            local after = line:sub(col + 1)
            local new_line = before .. "[[" .. relative_path .. "]]" .. after

            vim.api.nvim_set_current_line(new_line)
            vim.api.nvim_win_set_cursor(0, { row, start_col + 3 + #relative_path })
            cmp.close()
            return
          else
            print("⚠️ Could not compute relative path")
          end
        end

        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      else
        fallback()
      end
    end),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'obsidian' },
  }),
})

-- Trigger completion after typing `[[`
vim.keymap.set("i", "[", function()
  local col = vim.fn.col('.') - 1
  local line = vim.fn.getline('.')
  if col >= 1 and line:sub(col, col) == '[' then
    vim.api.nvim_feedkeys('[', 'n', false)
    require("cmp").complete()
  else
    vim.api.nvim_feedkeys('[', 'n', false)
  end
end, { noremap = true, silent = true })
