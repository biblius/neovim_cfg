# Install all the components necessary for this config
# on an arch linux

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo pacman -S python-black --noconfirm
sudo pacman -S stylua --noconfirm
sudo pacman -S eslint --noconfirm
sudo pacman -S prettier --noconfirm
sudo pacman -S markdownlint --noconfirm
sudo pacman -S tree-sitter --noconfirm
sudo pacman -S go --noconfirm
sudo pacman -S nodejs --noconfirm
sudo pacman -S npm --noconfirm
