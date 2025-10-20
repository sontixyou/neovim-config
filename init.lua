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
opt.autoread = true -- Automatically read files when changed outside of Neovim

-- Auto reload files when they are changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})

-- Highlight yanked text with orange color
vim.api.nvim_set_hl(0, 'YankHighlight', { bg = '#ff9e64', fg = '#000000' })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({
      higroup = 'YankHighlight',
      timeout = 300,
    })
  end,
})


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

-- Copy file path to clipboard
keymap.set("n", "<leader>cp", function()
  local path = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':.')
  vim.fn.setreg('+', path)
  vim.notify('Copied relative path: ' .. path)
end, { desc = 'Copy relative file path to clipboard' })

keymap.set("n", "<leader>cP", function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify('Copied absolute path: ' .. path)
end, { desc = 'Copy absolute file path to clipboard' })

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

-- Configure telescope.nvim
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { ".git/" }
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', function()
  builtin.find_files({ hidden = true })
end, { desc = 'Telescope find files' })
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
  direction = 'vertical', -- 'horizontal' | 'vertical' | 'float' | 'tab'
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


-- Treesj
require('treesj').setup({})


-- Configure seeker.nvim keybinding
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'DenopsReady',
--   callback = function()
--     vim.keymap.set('n', '<leader><leader>', function()
--       vim.fn['denops#notify']('seeker', 'findFiles', {})
--     end, { desc = 'Find Files', noremap = true, silent = true })
--   end,
-- })

-- Configure autoclose.nvim
require("autoclose").setup()

-- Configure bufferline.nvim
require('bufferline').setup {
  options = {
    mode = "buffers",
    themable = true,
    numbers = "none",
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = '▎',
      style = 'icon',
    },
    buffer_close_icon = '󰅖',
    modified_icon = '● ',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    truncate_names = true,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_update_on_event = true,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        text_align = "left",
        separator = true
      }
    },
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    show_duplicate_prefix = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    hover = {
      enabled = true,
      delay = 200,
      reveal = {'close'}
    },
    sort_by = 'insert_after_current',
  }
}

-- Bufferline keybindings
keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' })
keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<cr>', { desc = 'Toggle pin buffer' })
keymap.set('n', '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', { desc = 'Delete non-pinned buffers' })
keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Delete other buffers' })
keymap.set('n', '<leader>br', '<cmd>BufferLineCloseRight<cr>', { desc = 'Delete buffers to the right' })
keymap.set('n', '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', { desc = 'Delete buffers to the left' })
keymap.set('n', 'gb', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffer' })

-- Configure gitsigns.nvim
require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  base = 'HEAD',  -- Always show diff against HEAD (not index), so staged changes remain visible
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = 'Next hunk'})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = 'Previous hunk'})
  end
}

require("neo-tree").setup({
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = {
      always_show = {
        ".gitignore",
        ".dockerignore",
        ".dockleignore",
        ".editorconfig",
        ".env",
        ".github",
        ".gitignore",
        ".husky",
        ".irb_history",
        ".irbrc",
        ".prettierrc",
        ".rspec",
        ".rubocop.yml",
        ".ruby-lsp",
        ".tool-versions",
        ".vscode",
      },
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  window = {
    mappings = {
      ["<space>"] = "none",
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    file_size = {
      enabled = false,
    },
    type = {
      enabled = false,
    },
    last_modified = {
      enabled = false,
    },
  },
})


-- key binding
-- Neo-tree keybinds
vim.keymap.set("n", "<leader>e", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
end, { desc = "Toggle file tree" })

vim.keymap.set("n", "<leader>ge", function()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git Explorer" })

vim.keymap.set("n", "<leader>E", function()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git Status" })

-- vim-test configuration for Jest
-- Remove --test-file option and pass file path directly as argument
vim.g['test#javascript#runner'] = 'jest'
vim.g['test#typescript#runner'] = 'jest'
vim.g['test#typescriptreact#runner'] = 'jest'  -- For .tsx files
vim.g['test#javascriptreact#runner'] = 'jest'  -- For .jsx files
vim.g['test#javascript#jest#file_pattern'] = '\\v(test|spec)\\.(js|jsx|ts|tsx)$'
vim.g['test#typescript#jest#file_pattern'] = '\\v(test|spec)\\.(ts|tsx)$'
vim.g['test#typescriptreact#jest#file_pattern'] = '\\v(test|spec)\\.tsx$'
vim.g['test#javascriptreact#jest#file_pattern'] = '\\v(test|spec)\\.jsx$'
vim.g['test#javascript#jest#executable'] = 'npx jest'
vim.g['test#typescript#jest#executable'] = 'npx jest'
vim.g['test#typescriptreact#jest#executable'] = 'npx jest'
vim.g['test#javascriptreact#jest#executable'] = 'npx jest'

-- vim-test keybinds
vim.keymap.set("n", "<leader>tt", "<cmd>TestNearest -strategy=neovim<cr>", { desc = "Test nearest" })
vim.keymap.set("n", "<leader>tT", "<cmd>TestFile -strategy=neovim<cr>", { desc = "Test file" })
vim.keymap.set("n", "<leader>tl", "<cmd>TestLast -strategy=neovim<cr>", { desc = "Test last" })
vim.keymap.set("n", "<leader>ta", "<cmd>TestSuite -strategy=neovim<cr>", { desc = "Test all" })

-- diffview.nvim keybinds
vim.keymap.set("n", "<leader>dvo", "<cmd>DiffviewOpen<cr>", { desc = "Open diff view" })
vim.keymap.set("n", "<leader>dvc", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })
vim.keymap.set("n", "<leader>dvh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history (current file)" })
vim.keymap.set("n", "<leader>dvf", "<cmd>DiffviewFileHistory<cr>", { desc = "File history (all)" })
vim.keymap.set("n", "<leader>dvr", "<cmd>DiffviewRefresh<cr>", { desc = "Refresh diff view" })

-- Configure blink.cmp
require('blink.cmp').setup({
  keymap = { preset = 'enter' },
  appearance = {
    nerd_font_variant = 'mono'
  },
  completion = {
    documentation = { auto_show = false },
    list = {
      selection = {
        preselect = false
      }
    }
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' }
  }
})

-- Configure conform.nvim
require("conform").setup({
  formatters_by_ft = {
    ruby = { "rubocop", lsp_format = "fallback" },
    -- JavaScript/TypeScript: run the first available formatter
    javascript = { "prettier" },
    javascriptreact = { "prettier"},
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    -- CSS/SCSS/Sass: use stylelint
    css = { "stylelint" },
    scss = { "stylelint" },
    sass = { "stylelint" },
    -- Rust with LSP fallback
    rust = { "rustfmt", lsp_format = "fallback" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = true, -- Disable auto-format on save (use manual <leader>f instead)
  }) 


-- LSP Configuration
-- LSP keymaps (set up when LSP attaches to buffer)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = bufnr, noremap = true, silent = true }

    -- Navigation
    keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
    keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Show references' }))
    keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))

    -- Documentation
    keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Show hover documentation' }))
    keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature help' }))

    -- Code actions
    keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
    keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))

    -- Diagnostics
    keymap.set('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
    keymap.set('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
    keymap.set('n', '<leader>d', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Show diagnostic' }))

    -- Formatting with conform.nvim
    keymap.set('n', '<leader>f', function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, vim.tbl_extend('force', opts, { desc = 'Format buffer' }))

    -- Inline completion (for Copilot)
    -- Only enable if the API is available (Neovim 0.11+)
    if not vim.lsp.inline_completion.get() then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

      vim.keymap.set('i', '<tab>', function()
        if not vim.lsp.inline_completion.get() then
          return '<tab>'
        end
      end, { expr = true })
    end
  end,
})

-- Configure ruby_lsp
vim.lsp.config('ruby_lsp', {
  cmd = { "ruby-lsp" },
  filetypes = { "ruby", "eruby" },
  init_options = {
    formatter = "auto"
  },
  root_markers = { "Gemfile", ".git" },
  capabilities = require('blink.cmp').get_lsp_capabilities()
})

-- Enable ruby_lsp
vim.lsp.enable('ruby_lsp')

-- Configure ts_ls
vim.lsp.config('ts_ls', {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  init_options = {
    hostInfo = "neovim"
  },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  capabilities = require('blink.cmp').get_lsp_capabilities()
})

-- Enable ts_ls
vim.lsp.enable('ts_ls')

-- Configure copilot
local copilot_capabilities = require('blink.cmp').get_lsp_capabilities()
copilot_capabilities.textDocument = copilot_capabilities.textDocument or {}
copilot_capabilities.textDocument.inlineCompletion = {
  dynamicRegistration = false,
}
copilot_capabilities.workspace = copilot_capabilities.workspace or {}
copilot_capabilities.workspace.configuration = true

vim.lsp.config('copilot', {
  cmd = { "copilot-language-server", "--stdio" },
  filetypes = {
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "python", "ruby", "go", "rust", "java", "c", "cpp", "lua",
    "vim", "sh", "bash", "zsh", "html", "css", "scss", "json",
    "yaml", "markdown", "php", "swift", "kotlin", "scala"
  },
  root_markers = { ".git" },
  capabilities = copilot_capabilities,
})

-- Enable copilot
vim.lsp.enable('copilot')

