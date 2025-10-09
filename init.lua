-- require("config.lazy")
-- require("config.autocmds")
-- require("config.format")

local opt = vim.opt
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
opt.swapfile = false
-- 新しい行を追加したいときに、一つ上の行のインデント引き継ぎます
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.expandtab = true
opt.softtabstop = 2
opt.spelllang = "en_us"
opt.spell = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.splitright = true -- Put new windows right of current
opt.termguicolors = true -- True color support
opt.undofile = true
opt.undolevels = 10000
opt.smoothscroll = true


-- keymap
keymap.set("i", "jj", "<ESC>", opts)
keymap.set("n", ";", ":", opts)
-- Terminal
keymap.set("t", "jj", "<c-\\><c-n>:close<cr>", { nowait = true })
-- Window
keymap.set("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split window equal width
keymap.set("n", "<leader>sx", ":close<CR>", opts) -- close current split window
-- 簡易的にbinding.bを入力できるようにする
keymap.set("n", ",b", "odebugger<Esc>", opts)
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

vim.g['denops#deno'] = '/opt/homebrew/bin/deno'

-- Load necromancer plugins
local plugin_dir = vim.fn.expand('~/.local/share/nvim/necromancer/plugins')

-- Load denops.vim first (required by other denops plugins)
local denops_path = plugin_dir .. '/denops.vim'
if vim.fn.isdirectory(denops_path) == 1 then
  vim.opt.runtimepath:prepend(denops_path)
end

-- Load other plugins
for _, plugin in ipairs(vim.fn.readdir(plugin_dir)) do
  if plugin ~= 'denops.vim' then
    vim.opt.runtimepath:append(plugin_dir .. '/' .. plugin)
  end
end

-- Configure nvim-treesitter
require'nvim-treesitter'.setup {
  -- Ensure these parsers are installed for the specified languages
  ensure_installed = { "lua", "rust", "ruby", "typescript" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true
  },
}

-- Configure LSP
local lspconfig = require('lspconfig')

-- Setup lua_ls (Lua Language Server)
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- LSP keymaps (only set when LSP is attached)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings
    local opts = { buffer = ev.buf }
    keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
