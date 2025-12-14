# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/runtime-$USER}"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- set the directory we want to store zinit and plugins ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# --- download zinit, if it's not there yet ---
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# --- source/Load zinit ---
source "${ZINIT_HOME}/zinit.zsh"

# --- add powerlevel10k ---
zinit ice depth=1; zinit light romkatv/powerlevel10k

# --- zsh plugins ---
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light clavelm/eza-omz-plugin
zinit light jessarcher/zsh-artisan

# --- snippets ---
zinit snippet OMZP::git
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# --- path setup ---

export GOPATH=$HOME/go
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.config/composer/vendor/bin
export PATH=$BUN_INSTALL/bin:$PATH
export PATH=$HOME/.turso:$PATH
export PATH=$PATH:./node_modules/.bin
export PATH=$HOME/.bin:$PATH
export PATH="$PATH:$HOME/.local/share/yabridge"
export PATH=$HOME/.cargo/bin:$PATH


# --- load completions ---
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit
eval "$(dnspyre --completion-script-zsh)"
[ -s "/home/jschillem/.bun/_bun" ] && source "/home/jschillem/.bun/_bun"

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export XDG_DATA_DIRS='/var/lib/flatpak/exports/share':$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS

if which ruby >/dev/null && which gem >/dev/null; then
    export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

export PATH=/home/jschillem/.opam/default/bin:$PATH

if command -v brew &> /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- keybindings ---
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- aliases --- 
alias vim=nvim
alias svim="sudo -E nvim"
alias c=clear
alias lg=lazygit
alias tree="eza --group-directories-first --tree -L 3"
alias pbcopy="xsel -ib"
alias pbpaste="xsel -ob"
alias ssh="kitten ssh"

# --- history ---
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --- styling ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --group-directories-first --icons --color=always $realpath'
zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview 'ls --color --group-directories-first $realpath'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#2e3c64 \
  --color=bg:#1f2335 \
  --color=border:#29a4bd \
  --color=fg:#c0caf5 \
  --color=gutter:#1f2335 \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#29a4bd \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

zstyle ':fzf-tab:*' fzf-flags \
  --color=fg:#c0caf5,bg:#1f2335,hl:#2ac3de,fg+:#c0caf5,bg+:#2e3c64,hl+:#2ac3de \
  --color=info:#545c7e,prompt:#2ac3de,pointer:#ff007c,marker:#ff007c,spinner:#ff007c \
  --color=header:#ff9e64,border:#29a4bd,label:#c0caf5,query:#c0caf5 \
  --border=sharp \
  --preview-window=border-sharp \
  --prompt='► ' \
  --marker='»' \
  --pointer='➔' \
  --separator='─' \
  --scrollbar='│' \
  --border-label=''

# --- shell integrations ---
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# --- editor setup ---
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# --- bun ---
export BUN_INSTALL="$HOME/.bun"

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# --- opam ---
OPAM_SWITCH_PREFIX='/home/jschillem/.opam/default'; export OPAM_SWITCH_PREFIX;
CAML_LD_LIBRARY_PATH='/home/jschillem/.opam/default/lib/stublibs:/home/jschillem/.opam/default/lib/ocaml/stublibs:/home/jschillem/.opam/default/lib/ocaml'; export CAML_LD_LIBRARY_PATH;
OCAML_TOPLEVEL_PATH='/home/jschillem/.opam/default/lib/toplevel'; export OCAML_TOPLEVEL_PATH;
MANPATH=':/home/jschillem/.opam/default/man'; export MANPATH;



# pnpm
export PNPM_HOME="/home/jschillem/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
export RESOLVE_SCRIPT_API="/opt/resolve/Developer/Scripting/"
export RESOLVE_SCRIPT_LIB="/opt/resolve/libs/Fusion/fusionscript.so"
export PYTHONPATH="$PYTHONPATH:$RESOLVE_SCRIPT_API/Modules/"
