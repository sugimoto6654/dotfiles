return {
  {
    "3rd/image.nvim",
    -- 画像ファイルを直接開いた場合にも表示を差し替えるため、起動時に読み込む
    lazy = false,
    opts = {
      -- WezTerm では Kitty Graphics Protocol が完全には対応されていないため、
      -- 安定して利用できる Sixel を使う
      backend = "sixel",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "popup",
        },
      },
      hijack_file_patterns = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.webp",
        "*.avif",
      },
    },
  },
}
