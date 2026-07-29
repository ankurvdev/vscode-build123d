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
  /app/vscodium-web/bin/codium-server --install-extension ${publisher}.${name}.vsix
  rm ${publisher}.${name}.vsix
}

install_vscodium() {
  if [[ -e  /app/vscodium-web/bin/codium-server ]]; then
    return
  fi
  CODE_RELEASE=$(curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | jq -r '. | .tag_name')
  mkdir -p /app/vscodium-web
  curl -o /tmp/vscodium-web.tar.gz -L "https://github.com/VSCodium/vscodium/releases/download/${CODE_RELEASE}/vscodium-reh-web-linux-x64-${CODE_RELEASE}.tar.gz"
  tar xf /tmp/vscodium-web.tar.gz -C /app/vscodium-web/ --strip-components=1
}

microdnf -y update
microdnf -y install curl git libglvnd-glx python3.14 python3-pip jq tar gzip

python3.14 -m ensurepip
python3.14 -m pip install --root-user-action=ignore --upgrade pip
python3.14 -m pip install --root-user-action=ignore --upgrade black ruff ocp_vscode cadquery build123d==0.11.1
# python3.14 -m pip install --root-user-action=ignore --upgrade git+https://github.com/gumyr/bd_warehouse
# syntax=docker/dockerfile:1

install_vsix "ms-python" "python"
install_vsix "ms-python" "black-formatter"
install_vsix "ms-vscode" "vs-keybindings"
install_vsix "charliermarsh" "ruff"
install_vsix "bernhard-42" "ocp-cad-viewer"

microdnf clean all
