# laptop

Idempotent MacBook Pro developer setup script + [chezmoi](https://www.chezmoi.io) dotfiles.

## What it installs

### CLI Tools
| Tool | Purpose |
|------|---------|
| [bat](https://github.com/sharkdp/bat) | Better `cat` |
| [difftastic](https://github.com/Wilfred/difftastic) | Structural diff |
| [eza](https://github.com/eza-community/eza) | Modern `ls` |
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

### Apps (via `brew install --cask`)
| App | Purpose |
|-----|---------|
| 1Password | Password manager |
| balenaEtcher | Flash OS images to USB |
| Bruno | Open-source API client |
| Claude | Anthropic Claude desktop app |
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

> **1Password for Safari** is available on the Mac App Store — run `mas install 1569813296` after signing in.

### Runtimes (via [mise](https://mise.jdx.dev))
- Node.js (LTS)
- PHP (latest)
- Ruby (latest)
- Zig (latest)
- Crystal (latest)
- Bun (latest)

### Claude Code CLI
Installed via `npm install -g @anthropic-ai/claude-code` after Node is available.

### ddev
Local development environment — installed via `brew install ddev/ddev/ddev`.

## Dotfiles managed by chezmoi

| Dotfile | Target |
|---------|--------|
| `dot_gitconfig.tmpl` | `~/.gitconfig` (prompts for name & email) |
| `dot_tmux.conf` | `~/.tmux.conf` |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `dot_config/nvim/init.lua` | `~/.config/nvim/init.lua` |

## Usage

### Fresh Mac setup (one-liner)

```sh
curl -fsSL https://raw.githubusercontent.com/lukeholder/laptop/main/setup.sh | bash
```

### Manual setup

```sh
# Clone this repo
git clone https://github.com/lukeholder/laptop.git ~/laptop
cd ~/laptop

# Run the setup script
bash setup.sh
```

### Apply dotfiles only (after initial setup)

```sh
chezmoi apply
```

### Update everything

```sh
brew update && brew upgrade && brew upgrade --cask
mise self-update && mise upgrade
chezmoi update
```

### Edit a dotfile

```sh
chezmoi edit ~/.config/ghostty/config
chezmoi apply
```

## Customisation

- **Runtimes**: edit `.mise.toml` and run `mise install`
- **Packages**: edit `Brewfile` and run `brew bundle --no-lock`
- **Dotfiles**: edit the `dot_*` files and run `chezmoi apply`
