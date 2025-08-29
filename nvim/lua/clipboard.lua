require("img-clip").setup({
  default = {
    dir_path = "assets",                      -- save images in ./assets
    file_name = function()
      return os.date("%Y-%m-%d-%H%M%S")       -- timestamped filenames
    end,
    prompt_for_file_name = false,
    template = {
      markdown = "![$CURSOR]($FILE_PATH)",    -- what gets inserted
      tex      = "\\includegraphics[width=\\linewidth]{$FILE_PATH}",
      neorg    = "{image:$FILE_PATH}",
      asciidoc = "image::$FILE_PATH[]",
    },
  },
})
