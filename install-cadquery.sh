#!/bin/bash
set -e
set -u
set -o pipefail

microdnf -y update
microdnf -y install curl git libglvnd-glx python3-pip python3-virtualenv python3-NLopt
microdnf clean all

python3 -m ensurepip
python3 -m pip install --root-user-action=ignore --upgrade pip black ruff
python3 -m pip install --root-user-action=ignore --upgrade ocp_vscode cadquery
python3 -m pip install --root-user-action=ignore --upgrade build123d
python3 -m pip install --root-user-action=ignore --upgrade git+https://github.com/gumyr/bd_warehouse
curl -fsSL https://code-server.dev/install.sh | sh

bash /install_vsix.sh "ms-python" "python"
bash /install_vsix.sh "ms-python" "black-formatter"
bash /install_vsix.sh "ms-vscode" "vs-keybindings"
bash /install_vsix.sh "charliermarsh" "ruff"
bash /install_vsix.sh "bernhard-42" "ocp-cad-viewer"
