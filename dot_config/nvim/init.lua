-- Neovim Configuration
-- Location: ~/.config/nvim/init.lua
-- Managed by chezmoi — edit with: chezmoi edit ~/.config/nvim/init.lua

-- ---------------------------------------------------------------------------
-- Options
-- ---------------------------------------------------------------------------
local opt = vim.opt

opt.number         = true          -- Show line numbers
opt.relativenumber = true          -- Relative line numbers
opt.cursorline     = true          -- Highlight current line
opt.signcolumn     = "yes"         -- Always show sign column

opt.tabstop        = 2             -- Tab width
opt.shiftwidth     = 2             -- Indent width
opt.expandtab      = true          -- Spaces instead of tabs
opt.smartindent    = true

opt.wrap           = false         -- No line wrapping
opt.scrolloff      = 8             -- Keep 8 lines above/below cursor
opt.sidescrolloff  = 8

opt.hlsearch       = false         -- No persistent search highlight
opt.incsearch      = true          -- Incremental search
opt.ignorecase     = true          -- Case-insensitive search …
opt.smartcase      = true          -- … unless capital letters used

opt.splitright     = true          -- Vertical splits open to the right
opt.splitbelow     = true          -- Horizontal splits open below

opt.termguicolors  = true          -- Full colour support
opt.background     = "dark"

opt.undofile       = true          -- Persistent undo history
opt.updatetime     = 250           -- Faster completion
opt.timeoutlen     = 300

opt.clipboard      = "unnamedplus" -- Use system clipboard

-- ---------------------------------------------------------------------------
-- Leader key
-- ---------------------------------------------------------------------------
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ---------------------------------------------------------------------------
-- Key Maps
-- ---------------------------------------------------------------------------
local map = vim.keymap.set

-- Easier split navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Keep visual selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Centre cursor when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n",     "nzzzv")
map("n", "N",     "Nzzzv")

-- Quick save & quit
map("n", "<leader>w", "<cmd>w<CR>",  { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>",  { desc = "Quit" })

-- Buffer navigation
map("n", "[b", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- ---------------------------------------------------------------------------
-- Bootstrap lazy.nvim (plugin manager)
-- ---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------------------
-- Plugins
-- ---------------------------------------------------------------------------
require("lazy").setup({
  -- Colour scheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "catppuccin" } })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files,  { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,   { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers,     { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags,   { desc = "Help tags" })
    end,
  },

  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "php", "ruby", "javascript", "typescript",
                             "json", "yaml", "markdown", "bash", "zig" },
        auto_install    = true,
        highlight       = { enable = true },
        indent          = { enable = true },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "intelephense", "ruby_lsp", "ts_ls" },
        automatic_installation = true,
      })
    end,
  },

  -- Auto-completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, { name = "luasnip" },
        }, {
          { name = "buffer" }, { name = "path" },
        }),
      })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "]h", gs.next_hunk, opts)
          vim.keymap.set("n", "[h", gs.prev_hunk, opts)
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
          vim.keymap.set("n", "<leader>hb", gs.blame_line, opts)
        end,
      })
    end,
  },

  -- Auto pairs
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

  -- Comment toggling
  { "numToStr/Comment.nvim", config = true },

  -- Which-key (keybinding hints)
  { "folke/which-key.nvim",  event = "VeryLazy",    config = true },
}, {
  ui = { border = "rounded" },
})
