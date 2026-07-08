return {
  ----- Lazy.nvim -----
  {
    "folke/lazy.nvim",
    version = false,
    priority = 1000,
  },

  ----- Catppuccin Theme -----
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 999,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = true,
          mini = true,
          neotree = true,
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  ------ Devicons ------
  {
    "nvim-tree/nvim-web-devicons",
  },

  ----- Lualine -----
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function os_icon()
        local sysname = vim.uv.os_uname().sysname
        if sysname == "Darwin" then
          return ""
        elseif sysname == "Linux" then
          return ""
        elseif sysname:match("Windows") then
          return ""
        end
        return sysname
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          symbols = {
            modified = " ●",      -- Text to show when the buffer is modified
            readonly = "",     -- Text to show when the buffer is non-modifiable or readonly
            alternate_file = "", -- Text to show to identify the alternate file
            unnamed = "[No Name]", -- Text to show for unnamed buffers
            newfile = "[New]",   -- Text to show for new created file before first write
          },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 32, -- ~120fps
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", os_icon, "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },

  ----- Barbar Bufferline -----
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = false,
      exclude_ft = { "neo-tree" },
      focus_on_close = "previous",
      highlight_inactive_file_icons = true,
      highlight_visible = true,
      maximum_length = 28,
      maximum_padding = 2,
      minimum_padding = 1,
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = "×",
        filetype = { enabled = true },
        modified = { button = "●" },
        separator = { left = "│", right = "│" },
        separator_at_end = false,
        scroll = { left = "‹", right = "›" },
        current = { separator = { left = "│", right = "│" } },
        inactive = { separator = { left = "│", right = "│" } },
        visible = { separator = { left = "│", right = "│" } },
      },
    },
    lazy = false,
    version = "^1.0.0",
  },

  ----- Which-Key -----
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({})
    end,
  },
}
