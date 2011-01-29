# Check for an interactive session
[ -z "$PS1" ] && return

# Aliases
alias ll='ls -AhlF'
alias la='ls -A'
alias lla='ls -hlA'
alias l='ls -CF'
alias ls='ls --color=auto'

# Securities
alias rm='rm -vi'
alias mv='mv -vi'
alias cp='cp -vi'

#other aliases
alias yupdate='sudo yaourt -Syu'
alias update='sudo pacman -Syu'
#alias pacman='pacman-color'
alias grep='grep --color'
alias du='du -h'

# set a fancy prompt (non-color, unless we know we "want" color)
PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# PATH export
#export http_proxy='http://cache.cite-u.univ-nantes.fr:3128'
export EDITOR="vim"


