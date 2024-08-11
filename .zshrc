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

# --- load completions ---
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- path setup ---

export GOPATH=$HOME/go
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.config/composer/vendor/bin
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/home/jschillem/.turso:$PATH"
export PATH=$PATH:./node_modules/.bin


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
alias c=clear
alias lg=lazygit
alias tree="eza --group-directories-first --tree -L 3"
alias pbcopy="xsel -ib"
alias pbpaste="xsel -ob"

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
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ":fzf-tab:complete:cd:*" fzf-preview 'ls --color --group-directories-first $realpath'
zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview 'ls --color --group-directories-first $realpath'

export BAT_THEME="kanagawa"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#C8C093,fg+:#DCD7BA,bg:#1F1F28,bg+:#2A2A37
  --color=hl:#938AA9,hl+:#FF9E3B,info:#FF9E3B,marker:#76946A
  --color=prompt:#54546D,spinner:#C8C093,pointer:#FF9E3B,header:#87afaf
  --color=border:#363646,label:#DCD7BA,query:#DCD7BA
  --border="sharp" --border-label="" --preview-window="border-sharp" --padding="1"
  --prompt=" " --marker="" --pointer="󰄾"
  --separator="─" --scrollbar="│"'

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
# bun completions
[ -s "/home/jschillem/.bun/_bun" ] && source "/home/jschillem/.bun/_bun"
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
