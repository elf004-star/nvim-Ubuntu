# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- **Format Lua**: `stylua lua/` (config: 4 spaces, 120 col width in `stylua.toml`)
- **Check config validity**: `nvim --headless -c 'Lazy! sync' -c 'qa!'`
- **Check clipboard setup**: `nvim --headless -c 'lua print(vim.o.clipboard)' -c 'qa!'`
- **Update plugins**: `nvim --headless -c 'Lazy! sync' -c 'qa!'`
- **View plugin updates**: `nvim -c 'Lazy'`

## Architecture

This is a **LazyVim**-based Neovim configuration using **lazy.nvim** as the plugin manager. All config is Lua.

### Structure

```
init.lua              Entry point: clipboard (xclip local / OSC52 over SSH) + lazy bootstrap
lua/
  config/
    lazy.lua          Plugin manager bootstrap + specs entrypoint
    options.lua       Editor options (indent=4spaces, diagnostics, spell off)
    keymaps.lua       Custom keymaps (clipboard, surround, bracket jump, undo/redo)
    autocmds.lua      Autocmds (disable spell checking globally)
    utils.lua         Utility helpers (LSP attach check, OS detection, window ops)
    debugging.lua     DAP config for C/C++, CUDA, Python
  plugins/
    example.lua       Reference spec for adding/overriding LazyVim plugins (disabled)
    surround.lua      tpope/vim-surround
    rainbow-delimiters.lua  HiPhish/rainbow-delimiters.nvim
    markdown.lua      Markdown LSP disabling + markview.nvim preview
    debugging.lua     DAP plugin dependencies declaration
```

### Key patterns

- **Plugin specs** in `lua/plugins/*.lua` return a list for lazy.nvim's `import` mechanism. Each file adds, overrides, or disables plugins. See `example.lua` for patterns.
- **LazyVim extras** are declared in `lazyvim.json`: `lang.clangd` and `lang.python`.
- **DAP block** (`lua/config/debugging.lua`) is loaded by the dap plugin spec via `config = function() require("config.debugging") end`.

### Notable workarounds

- **Clipboard (OSC52 over SSH, xclip local)**: `init.lua` only sets `vim.g.clipboard = "osc52"` inside an SSH session (`SSH_CONNECTION`/`SSH_TTY`). Locally nvim auto-detects `xclip` — do NOT force OSC52 unconditionally, because GNOME Terminal (VTE) doesn't support OSC 52 and yank silently fails. `vim.o.clipboard = "unnamedplus"` must run in a `VeryLazy` autocmd because LazyVim clears it on SSH connections during its own VeryLazy handler.
- **Surround vs flash**: `keymaps.lua` remaps `S` and `s` in visual mode to `VSurround` to prevent flash.nvim from intercepting them.
- **Diagnostics disabled**: `options.lua` sets `virtual_text = false` and `underline = false` for diagnostics — only gutter signs remain.
