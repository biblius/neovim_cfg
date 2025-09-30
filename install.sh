# Install all the components necessary for this config
# on an arch linux

# Check if rustc is installed
if ! command -v rustc &> /dev/null; then
    echo "rustc not found. Installing Rust..."
    # Install Rust using rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # Add Rust to the current shell session
    source "$HOME/.cargo/env"
    echo "Rust installed successfully."
else
    echo "rustc is already installed: $(rustc --version)"
fi

sudo pacman -S python-black --noconfirm
sudo pacman -S stylua --noconfirm
sudo pacman -S eslint --noconfirm
sudo pacman -S prettier --noconfirm
sudo pacman -S markdownlint --noconfirm
sudo ln -s /usr/bin/mdl /usr/bin/markdownlint
sudo pacman -S tree-sitter --noconfirm
sudo pacman -S go --noconfirm
sudo pacman -S nodejs --noconfirm
sudo pacman -S npm --noconfirm
