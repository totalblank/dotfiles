$pdf_previewer = 'start zathura';
$pdf_mode = 4; # lualatex
$lualatex = 'lualatex -interaction=nonstopmode -synctext=1 %O %S';
$aux_dir = "build";
$out_dir = ".";

# Ensure build dir exists before compilation
mkdir "build" unless -d "build";

