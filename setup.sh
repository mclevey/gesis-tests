#!/bin/bash

# Setup script for dev container
# Installs git, poetry, quarto, and starship

set -e  

echo "🔥 Setting up development environment..."

echo "Updating package manager..."
pacman -Syu --noconfirm

echo "Installing git, wget, and curl..."
pacman -S --noconfirm git wget curl

echo "Installing poetry..."
curl -sSL https://install.python-poetry.org | python3 -

echo "Adding poetry to PATH for current session..."
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

echo "Installing poetry dependencies..."
poetry install

echo "Registering Poetry environment as a Jupyter kernel..."
poetry run python -m ipykernel install --user --name=gesis-tests --display-name="GESIS Tests (Poetry)"

echo "Installing quarto..."
QUARTO_VERSION=$(curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
wget -O quarto.tar.gz "https://github.com/quarto-dev/quarto-cli/releases/latest/download/quarto-${QUARTO_VERSION#v}-linux-amd64.tar.gz"
tar -xzf quarto.tar.gz -C /opt/
ln -sf /opt/quarto-${QUARTO_VERSION#v}/bin/quarto /usr/local/bin/quarto
rm quarto.tar.gz

echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes
echo 'eval "$(starship init bash)"' >> ~/.bashrc

echo "Verifying installations..."

echo "Git version:"
git --version

echo "Poetry version:"
$HOME/.local/bin/poetry --version

echo "Quarto version:"
quarto --version

echo "Starship version:"
starship --version

echo "Setup complete! Please restart your shell or run 'source ~/.bashrc' to apply changes."