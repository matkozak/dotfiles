# ~/.config/zsh/.zshrc

# Part 1: p10k instant prompt (keep at the top)
#
if [[ -r "${XDG_CACHE_HOME}/zsh/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME}/zsh/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Part 2: History
#
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS       # don't record consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS   # remove older duplicate from history
setopt HIST_IGNORE_SPACE      # prefix command with space to omit from history
setopt HIST_REDUCE_BLANKS     # trim whitespace
setopt EXTENDED_HISTORY       # save timestamp + duration
setopt INC_APPEND_HISTORY     # write immediately, don't wait for shell exit
setopt SHARE_HISTORY          # share history across sessions in real time

# Part 3: Directory navigation
#
setopt AUTO_CD              # type directory name to cd into it
setopt AUTO_PUSHD           # cd pushes old dir onto stack
setopt PUSHD_IGNORE_DUPS    # no duplicates in dir stack
setopt PUSHD_SILENT         # don't print stack after pushd/popd
setopt PUSHD_MINUS          # cd -N to go back N

# Part 4: General shell behavior
#
setopt INTERACTIVE_COMMENTS  # allow comments in interactive shell
setopt NO_BEEP               # never beep
setopt NO_FLOW_CONTROL       # disable ctrl-s/ctrl-q (frees them for keybinds)
setopt GLOB_DOTS             # globs match dotfiles without explicit dot
setopt EXTENDED_GLOB         # enable # ~ ^ as glob operators

# Part 5: Completions
#
typeset -U fpath
fpath=(
    "$XDG_DATA_HOME/zsh/completions"
    $fpath
)

autoload -Uz compinit

# only regenerate .zcompdump once a day (same optimization OMZ does)
local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump-${HOST}-${ZSH_VERSION}"

if [[ -n "$zcompdump"(#qN.mh+24) ]]; then
    compinit -d "$zcompdump"
else
    compinit -C -d "$zcompdump"
fi

# case-insensitive, partial-word, then substring completion
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# menu and display
zstyle ':completion:*' menu select                      # arrow-key menu selection
zstyle ':completion:*' group-name ''                    # group results by type
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # colored like ls
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# misc polish
zstyle ':completion:*' squeeze-slashes true     # // treated as /
zstyle ':completion:*' complete-options true    # complete option flags
zstyle ':completion:*:*:kill:*' menu yes select # nice menu for kill
zstyle ':completion:*:kill:*' force-list always

# Part 6: Key bindings
#
bindkey -e # disable vi mode

bindkey '^[[H'    beginning-of-line  # Home
bindkey '^[[F'    end-of-line        # End
bindkey '^[[3~'   delete-char        # Delete
bindkey '^[[1;5C' forward-word       # Ctrl+Right
bindkey '^[[1;5D' backward-word      # Ctrl+Left

bindkey '^[[A' up-line-or-search     # Up arrow: search history
bindkey '^[[B' down-line-or-search   # Down arrow: search back

# fzf
source <(fzf --zsh)
bindkey '^F' fzf-cd-widget           # CTRL-F, prevents shadowing ALT-C (ć)


fzf-edit-widget() {
    # open file in nvim
    local file=$(eval "$FZF_DEFAULT_COMMAND" | fzf)
    [[ -n "$file" ]] && nvim "$file"
    zle reset-prompt
}
zle -N fzf-edit-widget
bindkey '^B' fzf-edit-widget

# Part 7: Aliases
#
alias vim="nvim"

# ls
alias ls="ls -lh --color=auto"
alias la="ls -lhA --color=auto"

# git
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline -20"
alias gs="git status"

# safety nets
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# python
alias venv="source .venv/bin/activate"

# claude code
alias claude="claude --allow-dangerously-skip-permissions"

# reload .zshrc
alias reload="source $ZDOTDIR/.zshrc"

# t <session, default: main> for tmux
t() { tmux new -A -s "${1:-main}"; }

# Part 8: Prompt
#
[[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"

# redirect instant prompt cache
# https://github.com/romkatv/powerlevel10k/issues/1817#issuecomment-2587706854
() {
  local XDG_CACHE_HOME="$XDG_CACHE_HOME/zsh"
  source "$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme"
}
