# dotfiles

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io).

## Fresh Mac setup

```sh
sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply lukeholder/dotfiles
```

This single command:
1. Installs a standalone `chezmoi` binary
2. Clones this repo to `~/.local/share/chezmoi`
3. Installs Xcode Command Line Tools (if needed)
4. Installs Homebrew (if needed)
5. Applies all dotfiles
6. Runs `brew bundle --global` to install all packages
7. Installs mise language runtimes
8. Sets up fzf shell integration

## What gets installed

### CLI Tools
| Tool | Purpose |
|------|---------|
| [bat](https://github.com/sharkdp/bat) | Better `cat` |
| [difftastic](https://github.com/Wilfred/difftastic) | Structural diff |
| [eza](https://github.com/eza-community/eza) | Modern `ls` |
| [fd](https://github.com/sharkdp/fd) | Modern `find` |
| [ffmpeg](https://ffmpeg.org) | Audio/video processing |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [gh](https://cli.github.com) | GitHub CLI |
| [git](https://git-scm.com) | Latest Git |
| [jq](https://jqlang.github.io/jq/) | JSON processor |
| [mise](https://mise.jdx.dev) | Runtime version manager |
| [neovim](https://neovim.io) | Text editor |
| [ngrok](https://ngrok.com) | Tunnel local servers |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast `grep` |
| [stripe-cli](https://stripe.com/docs/stripe-cli) | Stripe CLI |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` |

### Apps (via Homebrew cask)
| App | Purpose |
|-----|---------|
| 1Password | Password manager |
| balenaEtcher | Flash OS images to USB |
| Bruno | Open-source API client |
| Claude Code | Anthropic Claude desktop app |
| Firefox | Browser |
| Ghostty | GPU-accelerated terminal |
| Google Chrome | Browser |
| Kaleidoscope | Diff & merge tool |
| Linear | Issue tracker |
| Notion | Notes & wiki |
| Obsidian | Markdown knowledge base |
| OrbStack | Docker / Linux VMs |
| TablePlus | Database GUI |
| Tailscale | VPN mesh network |
| Tower | Git GUI |
| Transmit | File transfer (S3, SFTP…) |
| Visual Studio Code | Code editor |

> **1Password for Safari** is on the Mac App Store — run `mas install 1569813296` after signing in.

### Runtimes (via [mise](https://mise.jdx.dev))
- Node.js (LTS)
- PHP (latest)
- Ruby (latest)
- Zig (latest)
- Crystal (latest)
- Bun (latest)

## Dotfiles

| Source | Target |
|--------|--------|
| `dot_gitconfig.tmpl` | `~/.gitconfig` |
| `dot_zshrc.tmpl` | `~/.zshrc` |
| `dot_zprofile.tmpl` | `~/.zprofile` |
| `dot_mise.toml` | `~/.mise.toml` |
| `dot_tmux.conf` | `~/.tmux.conf` |
| `dot_Brewfile` | `~/.Brewfile` |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `dot_config/nvim/init.lua` | `~/.config/nvim/init.lua` |

## Day-to-day usage

```sh
# Apply dotfile changes (also re-runs any changed scripts)
chezmoi apply

# Edit a dotfile
chezmoi edit ~/.zshrc

# Pull latest from repo and apply
chezmoi update

# Push local changes up to the repo
dotpush              # commits with "update dotfiles"
dotpush "add foo"    # commits with a custom message

# Check for drift
chezmoi status
chezmoi diff

# Update all packages
brew update && brew upgrade && brew upgrade --cask
mise self-update && mise upgrade
```

## Adding packages

Edit `~/.Brewfile` (or `chezmoi edit ~/.Brewfile`), then run `chezmoi apply` — the `brew bundle --global` script runs automatically when the Brewfile changes.
