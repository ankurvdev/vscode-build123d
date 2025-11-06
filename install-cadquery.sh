#!/bin/bash
set -e
set -u
set -o pipefail

install_vsix() {
  publisher=$1
  name=$2
  version=$(curl -s -c cookies.txt "https://marketplace.visualstudio.com/items?itemName=${publisher}.${name}" | grep -o 'VersionValue":"\([^"]*\)' | cut -c 16-)
  echo "Installing $1.$2:$version"
  curl -s --compressed -j -b cookies.txt -o ${publisher}.${name}.vsix  https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher}/vsextensions/${name}/${version}/vspackage
  /usr/bin/code-server --install-extension ${publisher}.${name}.vsix
  rm ${publisher}.${name}.vsix
}

microdnf -y update
microdnf -y install curl git libglvnd-glx python3.13 python3-pip python3-virtualenv python3-NLopt
microdnf clean all

python3.13 -m ensurepip
python3.13 -m pip install --root-user-action=ignore --upgrade pip
python3.13 -m pip install --root-user-action=ignore --upgrade black ruff ocp_vscode cadquery build123d
python3.13 -m pip install --root-user-action=ignore --upgrade git+https://github.com/gumyr/bd_warehouse

curl -fsSL https://code-server.dev/install.sh | sh

install_vsix "ms-python" "python"
install_vsix "ms-python" "black-formatter"
install_vsix "ms-vscode" "vs-keybindings"
install_vsix "charliermarsh" "ruff"
install_vsix "bernhard-42" "ocp-cad-viewer"
