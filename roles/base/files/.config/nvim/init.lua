vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.cmd([[
  highlight Normal guibg=none ctermbg=none
  highlight LineNr guibg=none ctermbg=none
  highlight SignColumn guibg=none ctermbg=none
]])

vim.o.autocomplete = true
vim.opt.complete:append('o')
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' }, -- TODO: remove and switch to ranger integration if possible
}

vim.lsp.enable('lua_ls')
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
    end
  end,
})

require("nvim-tree").setup()
