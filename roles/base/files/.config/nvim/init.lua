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
  { src = 'https://github.com/mhinz/vim-startify' },
}

vim.lsp.config.bashls = {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' }
}
vim.lsp.enable('lua_ls')
vim.lsp.enable('bashls')
vim.lsp.enable('ansiblels')
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

-- TODO: rewrite
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*/playbooks/*.yml', '*/roles/*/tasks/*.yml', '*/roles/*/handlers/*.yml', 'playbook.yml' },
  callback = function()
    vim.bo.filetype = 'yaml.ansible'
  end,
})

require("nvim-tree").setup{
  renderer = { icons = { show = {
    git = false,
    folder = false,
    file = false,
    folder_arrow = false,
  } } }
}

vim.g.startify_lists = { -- Only show Sessions and Recent files
  { type = 'sessions',  header = { 'Sessions' } },
  { type = 'files',     header = { 'Recent files' } },
}
vim.g.startify_custom_header = {} -- Remove header text
vim.g.startify_session_number = 5 -- Limit recent sessions count globally
vim.g.startify_files_number = 5 -- Limit recent files count globally
vim.g.startify_enable_special = 0 -- Disable the standard [q] quit entry at the bottom
vim.g.startify_session_before_save = { 'NvimTreeClose' } -- Exclude nvim-tree buffers from session files
vim.api.nvim_create_autocmd('User', {
  pattern = 'StartifyBufferOpened',
  callback = function()
    require('nvim-tree.api').tree.open()
  end,
})
