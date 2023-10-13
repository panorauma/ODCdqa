#zsh script to render vignette
echo "This script will render the vignette from .qmd to .html"

quarto render index.qmd --to html

echo "Completed"