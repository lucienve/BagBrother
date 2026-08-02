# Developer Guide: Static Typing in BagBrother

To improve code reliability, prevent nil-indexing issues, and enable IDE autocomplete/IntelliSense, this repository uses **static type annotations** configured via the **Lua Language Server (LuaLS)**.

---

## 1. Tooling Overview

*   **Lua Language Server (LuaLS)**: The engine that processes code and annotations to perform static analysis and detect type mismatches.
*   **EmmyLua / LuaCATS Format**: A standard format for writing types within normal Lua comments.
*   **vscode-wow-api**: A community-maintained collection of Lua annotations representing Blizzard's World of Warcraft API (functions, events, frame widget objects).

---

## 2. Local Development Setup

To enable type checking and autocompletion in your local editor, follow these steps:

### Step 1: Download WoW API Annotations
Run the setup script at the root of the repository to clone the required API annotations:
```bash
bash scripts/setup_types.sh
```
This downloads only the necessary `Annotations` directory from `vscode-wow-api` to a local `.types/` folder, which is ignored in Git.

### Step 2: Configure Your Editor & Install the Language Server
*   **VS Code**: Install the official **Lua** extension by Sumneko. **No manual server installation is required**, as the extension automatically manages the language server binary for you.
*   **Neovim**: Install the language server via **Mason** using `:MasonInstall lua-language-server`.
*   **IntelliJ / WebStorm**: Install the **EmmyLua** plugin.

#### CLI Installation (WSL / Ubuntu)
If you want to run type checks directly from the command line in WSL/Ubuntu:
1. Download the latest Linux x64 release tarball:
   ```bash
   curl -L -O https://github.com/LuaLS/lua-language-server/releases/download/3.13.5/lua-language-server-3.13.5-linux-x64.tar.gz
   ```
2. Extract it to a local folder:
   ```bash
   mkdir -p ~/.local/share/lua-language-server
   tar -xzf lua-language-server-3.13.5-linux-x64.tar.gz -C ~/.local/share/lua-language-server
   ```
3. Symlink the binary to your path:
   ```bash
   mkdir -p ~/.local/bin
   ln -s ~/.local/share/lua-language-server/bin/lua-language-server ~/.local/bin/lua-language-server
   ```
4. Clean up the downloaded archive:
   ```bash
   rm lua-language-server-3.13.5-linux-x64.tar.gz
   ```

Your editor and CLI will automatically read the `.luarc.json` configuration file at the root.

---

## 3. Writing and Using Types

Types are added inside standard Lua comments.

### Type vararg arguments (`...`)
At the top of your addon files, type the captured varargs so LuaLS knows the addon namespace (`Addon`):
```lua
---@type string, BagBrotherAddon
local ADDON, Addon = ...
```

### Annotating Functions
Annotate function parameters and return values:
```lua
---Retrieves if the frame is positioned on the far right of the screen.
---@return boolean isFarRight
function Base:IsFarRight()
    return self:GetRight() > (GetScreenWidth() / self:GetEffectiveScale() / 2)
end
```

### Declaring Classes
Declare classes and their custom fields:
```lua
---@class Base : Object
---@field Scripts string[]
local Base = Addon:NewModule('Base', LibStub('Poncho-2.0')(), 'MutexDelay-1.0')
```

---

## 4. Running Type Checks

### Local Verification
If you have `lua-language-server` installed on your command line, you can perform a static analysis check of the entire codebase by running:
```bash
lua-language-server --check . --checklevel=Warning
```

### CI/CD Verification
Type checks are executed automatically via GitHub Actions on every Pull Request and commit to `master` and `feature/lua-typing`. The CI workflow:
1. Runs `scripts/setup_types.sh` to download WoW API annotations.
2. Invokes the `mrcjkb/lua-typecheck-action` to analyze the workspace and report any errors/warnings.
