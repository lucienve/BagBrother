#!/bin/bash
# setup_types.sh - Clones WoW API annotations locally for LuaLS type checking.
set -e

TYPES_DIR=".types"
WOW_API_DIR="${TYPES_DIR}/wow-api"

echo "Setting up type definitions..."

# Create types directory if not exists
mkdir -p "${TYPES_DIR}"

if [ ! -d "${WOW_API_DIR}" ]; then
  echo "Cloning vscode-wow-api annotations..."
  # Try sparse clone first (requires Git 2.25+)
  if git clone --depth 1 --filter=blob:none --sparse https://github.com/Ketho/vscode-wow-api.git "${WOW_API_DIR}" 2>/dev/null; then
    cd "${WOW_API_DIR}"
    git sparse-checkout set Annotations
    cd - > /dev/null
  else
    # Fallback to standard shallow clone if sparse checkout fails
    echo "Sparse clone failed or unsupported. Performing regular shallow clone..."
    git clone --depth 1 https://github.com/Ketho/vscode-wow-api.git "${WOW_API_DIR}"
  fi
else
  echo "WoW API annotations already exist. Updating..."
  cd "${WOW_API_DIR}"
  # Check if it is a sparse checkout directory
  if git config core.sparseCheckout >/dev/null; then
    git pull origin master
    git sparse-checkout set Annotations
  else
    git pull origin master
  fi
  cd - > /dev/null
fi

# Set up FrameXML annotations (which are a Git submodule in the original repository)
FRAMEXML_DIR="${WOW_API_DIR}/Annotations/FrameXML"
if [ ! -d "${FRAMEXML_DIR}/.git" ]; then
  echo "Cloning FrameXML annotations..."
  rm -rf "${FRAMEXML_DIR}"
  git clone --depth 1 -b live https://github.com/NumyAddon/FramexmlAnnotations.git "${FRAMEXML_DIR}"
else
  echo "FrameXML annotations already exist. Updating..."
  cd "${FRAMEXML_DIR}"
  git pull origin live || echo "Failed to update FrameXML annotations, using existing version."
  cd - > /dev/null
fi

echo "Type definitions successfully set up in ${WOW_API_DIR}/Annotations."
