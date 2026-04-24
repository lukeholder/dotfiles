# Luke's Laptop — Claude Context

## Instructions for Claude

When editing this file (`~/CLAUDE.md`), always edit the source in the chezmoi repo at `~/.local/share/chezmoi/CLAUDE.md`, then run `chezmoi apply` to propagate the change to `~/CLAUDE.md`.

## Machine setup

macOS on Apple Silicon. Developer machine used for web/SaaS development.

## Dotfile management — chezmoi

All dotfiles are managed with [chezmoi](https://chezmoi.io).

- **Source directory:** `~/.local/share/chezmoi` (a git repo)
- **Remote:** https://github.com/lukeholder/dotfiles
- **Apply changes:** `chezmoi apply`
- **Check drift:** `chezmoi status` / `chezmoi diff`

### Managed files

| File | Notes |
|------|-------|
| `~/.Brewfile` | Homebrew bundle — all apps and CLI tools |
| `~/.zprofile` | Login shell: Homebrew, OrbStack, JetBrains Toolbox paths |
| `~/.zshrc` | Interactive shell config |
| `~/.gitconfig` | Git config (templated — name/email from chezmoi data) |
| `~/.tmux.conf` | tmux config |
| `~/.config/ghostty/config` | Ghostty terminal config |
| `~/.config/nvim/init.lua` | Neovim config |

### Workflow for making changes

```sh
# Edit a managed file
chezmoi edit ~/.zshrc

# Or edit directly, then pull the change into chezmoi
chezmoi add ~/.zshrc

# Apply the source to the home directory
chezmoi apply

# Commit and push
cd ~/.local/share/chezmoi
git add -A && git commit -m "..." && git push
```

### .chezmoiignore

`LICENSE`, `README.md`, and `setup.sh` exist in the repo but are excluded from
being copied to `~` via `.chezmoiignore`.

## Package management — Homebrew

All apps and tools are declared in `~/.Brewfile` (managed by chezmoi).

```sh
# Install everything
brew bundle --global

# Add a new package — edit ~/.Brewfile then run chezmoi add and bundle
chezmoi add ~/.Brewfile
brew bundle --global
```

### Key CLI tools

| Tool | Purpose |
|------|---------|
| `mise` | Runtime version manager (node, python, etc.) |
| `gh` | GitHub CLI |
| `ripgrep` / `fd` | Fast search and find |
| `fzf` + `zoxide` | Fuzzy finder + smart cd |
| `delta` | Better git diffs |
| `lazygit` | TUI git client |
| `bat` / `eza` | Better cat / ls |
| `neovim` | Editor |
| `tmux` | Terminal multiplexer |
| `ddev` | Local dev environment (PHP/WordPress) |
| `stripe` | Stripe CLI |
| `ngrok` | Expose local servers |

### Key apps

| App | Purpose |
|-----|---------|
| Ghostty | Terminal |
| OrbStack | Docker / Linux VMs |
| TablePlus | Database GUI |
| Tower + Kaleidoscope | Git GUI + diff/merge |
| Bruno | API client |
| 1Password | Password manager |
| Tailscale | VPN mesh |
| JetBrains Toolbox | IDE manager |
| CleanShot | Screenshots |
| Transmit | File transfer (S3, SFTP) |

## Shell

- **Shell:** zsh
- **Login shell** (`~/.zprofile`): Homebrew shellenv → OrbStack init → JetBrains Toolbox PATH
- **Runtime versions:** managed by `mise`

## Git

- Editor: `nvim`
- Pager: `delta` (side-by-side diffs)
- Diff tool: `difftastic` (structural) + Kaleidoscope (GUI)
- Merge tool: Kaleidoscope
- Default branch: `main`
- Pull strategy: rebase
