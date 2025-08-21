$pdf_previewer = 'start zathura';
$pdflatex = 'lualatex %O %S';
$aux_dir = "build";
$out_dir = ".";

# Ensure build dir exists before compilation
mkdir "build" unless -d "build";

