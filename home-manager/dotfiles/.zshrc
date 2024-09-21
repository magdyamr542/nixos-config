# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
 DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# prevents ZSH from adding a % sign to the end of lines. https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol
PROMPT_EOL_MARK=''

# Uncomment the following line to change how often to auto-update (in days).
 export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  docker-compose
  autojump
  colored-man-pages
  history-substring-search
  fd
  kubectl
)
source $ZSH/oh-my-zsh.sh
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'



# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -s /home/amr/.autojump/etc/profile.d/autojump.sh ]] && source /home/amr/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit
export VISUAL=nvim
export EDITOR="$VISUAL"
# vim
bindkey jj vi-cmd-mode 

# fzf commands
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type file --follow --hidden --exclude .git'
# fall back to find
if ! type "fd" > /dev/null; then
  export FZF_DEFAULT_COMMAND='find . -type f'
  export FZF_CTRL_T_COMMAND='find . -type f'
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# kubectl auto completion
[[ -s "$HOME/.kubectl-auto-complete.zsh" ]] && source "$HOME/.kubectl-auto-complete.zsh"

# helm auto completion
[[ -s "$HOME/.helm-auto-complete.zsh" ]] && source "$HOME/.helm-auto-complete.zsh"


# source my custom bin
export PATH=$HOME/bin:$PATH

# >>> coursier install directory >>>
if [ -f "$HOME/.local/share/coursier/bin/scala" ]; then
  export PATH="$PATH:$HOME/.local/share/coursier/bin"
fi
# <<< coursier install directory <<<

command -v pyenv &> /dev/null && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &> /dev/null && eval "$(pyenv init -)"
command -v pyenv &> /dev/null && export PYENV_ROOT="$HOME/.pyenv"


if [ -f "$HOME/.proot/entryPoint.sh" ]; then
  source "$HOME/.proot/entryPoint.sh"
fi

if [ -f "$HOME/.aliases.sh" ]; then
  source "$HOME/.aliases.sh"
fi

if [ -f "$HOME/.funcs.sh" ]; then
  source "$HOME/.funcs.sh"
fi

if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
fi

if [ -f "$HOME/.gvm/scripts/gvm" ]; then
  source "$HOME/.gvm/scripts/gvm"
fi

if [ -d "/usr/local/texlive/2023/bin/x86_64-linux" ]; then
  export PATH="$PATH:/usr/local/texlive/2023/bin/x86_64-linux"
fi

# link ~/go to the current go version used
command -v gvm &> /dev/null && ln -sfn $HOME/.gvm/gos/$(gvm list | grep '=>' | awk '{print $2}') $HOME/go

SUDO_EDITOR=$HOME/bin/nvim

autoload -U +X bashcompinit && bashcompinit
# aws cli completion
complete -C '/usr/local/bin/aws_completer' aws

complete -o nospace -C /usr/bin/terraform terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/amr/.gvm/pkgsets/go1.20/global/bin/ssh-tunnel-manager ssh-tunnel-manager

# >>>> Vagrant command completion (start)
fpath=(/opt/vagrant/embedded/gems/gems/vagrant-2.4.1/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)

export AWS_PAGER=""
