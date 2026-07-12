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
      -- 初回表示は元画像の 50% とし、キー操作でウィンドウ全体まで拡大できるようにする。
      scale_factor = 0.5,
      max_height_window_percentage = 100,
      hijack_file_patterns = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.webp",
        "*.avif",
      },
    },
    config = function(_, opts)
      require("image").setup(opts)

      local function current_image()
        return require("image").get_images({
          window = vim.api.nvim_get_current_win(),
          buffer = vim.api.nvim_get_current_buf(),
        })[1]
      end

      local function resize_image(delta)
        local image = current_image()

        if not image then
          return
        end

        local width = image.geometry.width
        if not width or width == 0 then
          width = image.rendered_geometry.width
        end

        image:render({
          width = math.max(1, width + delta),
          height = 0, -- 縦横比を維持する
        })

        -- image.nvim が上限に合わせて実際に描画した幅を次の基準値にする。
        -- これにより、上限を超えて拡大を試みた後も 1 回の縮小で小さくなる。
        local rendered_width = image.rendered_geometry.width
        if rendered_width and rendered_width ~= image.geometry.width then
          image:render({ width = rendered_width, height = 0 })
        end
      end

      local group = vim.api.nvim_create_augroup("image_nvim_keymaps", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "image_nvim",
        callback = function(event)
          vim.keymap.set("n", "+", function()
            resize_image(5)
          end, { buffer = event.buf, desc = "画像を拡大" })
          vim.keymap.set("n", "-", function()
            resize_image(-5)
          end, { buffer = event.buf, desc = "画像を縮小" })
          vim.keymap.set("n", "0", function()
            local image = current_image()
            if image then
              image:render({ width = 0, height = 0 })
            end
          end, { buffer = event.buf, desc = "画像サイズをリセット" })
        end,
      })
    end,
  },
}
