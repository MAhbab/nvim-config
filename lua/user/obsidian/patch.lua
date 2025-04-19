vim.schedule(function()
  local ok, cmp_obsidian = pcall(require, "cmp_obsidian")
  if not ok then
    vim.notify("cmp_obsidian not available", vim.log.levels.WARN)
    return
  end

  local original_complete = cmp_obsidian.complete

  --- Check if the cursor is currently inside a wikilink (after [[)
  local function is_inside_wikilink()
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col(".")
    return line:sub(col - 2, col - 1) == "[["
  end

  cmp_obsidian.complete = function(self, request, callback)
    original_complete(self, request, function(items)
      for _, item in ipairs(items) do
        if is_inside_wikilink() then
          -- For wikilinks, we want to replace the entire [[...]] content
          if item.insertText then
            -- Remove any existing [[ and ]] from the insertText
            item.insertText = item.insertText:gsub("^%[%[", ""):gsub("%]%]$", "")
            -- Set the word to match the label for filtering
            item.word = item.label
            -- Add the relative path to the documentation
            if item.documentation and item.documentation.value then
              local full_path = item.documentation.value:match("%*%*path:%*%* `%s*(.-)%s*`")
              if full_path then
                local vault_root = "/Users/mahfuj/Documents/mindspace/content"
                local relative_path = full_path:gsub("^" .. vim.pesc(vault_root) .. "/", ""):gsub("%.md$", "")
                item.insertText = relative_path
              end
            end
          end
        end
      end
      callback(items)
    end)
  end
end)
