-- require("config.lazy")
-- require("config.autocmds")
-- require("config.format")

-- Set leader key to Space (must be set before any <leader> mappings)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

-- Start denops and discover plugins on startup
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.defer_fn(function()
      if vim.fn.exists('*denops#plugin#discover') == 1 then
        vim.fn['denops#plugin#discover']()
      end
    end, 100)
  end,
})

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

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Configure toggleterm.nvim
require("toggleterm").setup({
  -- size can be a number or function which is passed the current terminal
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  direction = 'float', -- 'horizontal' | 'vertical' | 'float' | 'tab'
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved',
    -- width = <value>,
    -- height = <value>,
    winblend = 3,
  }
})

-- Toggleterm keymaps
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' })
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'Toggle floating terminal' })
vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', { desc = 'Toggle horizontal terminal' })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<cr>', { desc = 'Toggle vertical terminal' })


-- Configure seeker.nvim keybinding
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'DenopsReady',
--   callback = function()
--     vim.keymap.set('n', '<leader><leader>', function()
--       vim.fn['denops#notify']('seeker', 'findFiles', {})
--     end, { desc = 'Find Files', noremap = true, silent = true })
--   end,
-- })
