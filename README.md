# dotfiles

Personal config files, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Fresh machine

```sh
xcode-select --install   # provides git
git clone https://github.com/matkozak/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` installs Homebrew and `just`, then runs `just bootstrap`:
Brewfile packages, stow symlinks, mise tools, shell completions and macOS
preferences. Log out and back in afterwards.

### Manual steps

- `just hostname <name>` to name the machine and pin its hostname
- System Settings that aren't scripted: input sources, keyboard shortcuts and
  modifier keys (see the end of `just macos`), menu bar items
- Not in Homebrew: Rex beta, Things (App Store)
- Sign in: Tailscale, `gh auth login`, Claude, Codex, Zotero sync

### Optional

- `just ssh` enables Remote Login as a fallback to Rex for remote access; add
  the phone's public key (from Blink) to `~/.ssh/authorized_keys` afterwards

## Day to day

```sh
just            # list recipes
just restow     # repair symlinks after adding files
just mise       # install tools added to mise config
```

A new config directory becomes a stow package once it is added to `packages` in
the `justfile`.

## Before wiping a machine

- Commit and push this repo
- Review `brew leaves` and `brew list --cask` against `macos/Brewfile`
