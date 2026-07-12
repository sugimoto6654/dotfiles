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
    config = function(_, opts)
      require("image").setup(opts)

      local function resize_image(delta)
        local image = require("image").get_images({
          window = 0,
          buffer = vim.api.nvim_get_current_buf(),
        })[1]

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
            local image = require("image").get_images({
              window = 0,
              buffer = event.buf,
            })[1]
            if image then
              image:render({ width = 0, height = 0 })
            end
          end, { buffer = event.buf, desc = "画像サイズをリセット" })
        end,
      })
    end,
  },
}
