Install software on this machine using the correct workflow: chezmoi + Homebrew Brewfile.

The package to install is: $ARGUMENTS

## Rules

- Always add packages to the chezmoi source directly: `~/.local/share/chezmoi/dot_Brewfile`
- Never edit `~/.Brewfile` directly
- Use `cask` for GUI apps, `brew` for CLI tools
- Use `tap` if the package requires a non-standard tap — add the tap entry too
- Place the entry in the correct section of the Brewfile (CLI Tools, Cask Applications, etc.) with a short inline comment
- After editing, run `chezmoi apply` to install (this triggers `brew bundle`)
- Commit the change in `~/.local/share/chezmoi` with a short commit message

## Steps

1. If you don't know whether the package is a cask or formula, run `brew info <package>` to check
2. Edit `~/.local/share/chezmoi/dot_Brewfile` to add the entry
3. Run `chezmoi apply`
4. Commit the change: `cd ~/.local/share/chezmoi && git add dot_Brewfile && git commit -m "Add <package> to Brewfile"`
