# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

PS1="\`if [ \$? = 0 ]; then echo \[\e[33m\]\t\[\e[0m\]; else echo \[\e[31m\]\t\[\e[0m\]; fi\`\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

alias d='date "+%j/%Y [%m/%d] %H:%M:%S (%I:%M%p) %Z"'
alias c='clear; cal -j; d'
alias t="top -M -u ${USER}; c"

