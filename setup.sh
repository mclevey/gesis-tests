#!/bin/bash

# Setup script for dev container
# Installs git, poetry, quarto, and starship

set -e  # Exit on any error

echo "🚀 Setting up development environment..."

# Update package manager
echo "📦 Updating package manager..."
pacman -Syu --noconfirm

# Install git and wget
echo "🔧 Installing git and wget..."
pacman -S --noconfirm git wget

# Install poetry
echo "📝 Installing poetry..."
curl -sSL https://install.python-poetry.org | python3 -
# Add poetry to PATH for current session
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Install quarto
echo "📊 Installing quarto..."
# Download latest quarto release for Linux
QUARTO_VERSION=$(curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
wget -O quarto.tar.gz "https://github.com/quarto-dev/quarto-cli/releases/latest/download/quarto-${QUARTO_VERSION#v}-linux-amd64.tar.gz"
tar -xzf quarto.tar.gz -C /opt/
ln -sf /opt/quarto-${QUARTO_VERSION#v}/bin/quarto /usr/local/bin/quarto
rm quarto.tar.gz

# Install starship
echo "⭐ Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes
# Add starship to bashrc
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Verify installations
echo "✅ Verifying installations..."
echo "Git version:"
git --version
echo "Poetry version:"
$HOME/.local/bin/poetry --version
echo "Quarto version:"
quarto --version
echo "Starship version:"
starship --version

echo "🎉 Setup complete! Please restart your shell or run 'source ~/.bashrc' to apply changes."