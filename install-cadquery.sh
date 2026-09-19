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
microdnf -y install curl git libglvnd-glx python3.14 python3-pip jq tar gzip

python3.14 -m ensurepip
python3.14 -m pip install --root-user-action=ignore --upgrade pip
python3.14 -m pip install --root-user-action=ignore --upgrade ruff ocp_vscode cadquery build123d==0.12.0
python3.14 -m pip install --root-user-action=ignore --upgrade git+https://github.com/gumyr/bd_warehouse@4006fb03b2a022d11abd41fc4c24a3a042f25ea0

curl -fsSL https://code-server.dev/install.sh | sh

install_vsix "ms-python" "python"
install_vsix "ms-python" "black-formatter"
install_vsix "ms-vscode" "vs-keybindings"
install_vsix "charliermarsh" "ruff"
install_vsix "bernhard-42" "ocp-cad-viewer"

microdnf clean all
