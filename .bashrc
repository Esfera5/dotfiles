#!/bin/bash
# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

shopt -s histappend
export HISTCONTROL=ignorespace:ignoredups
export HISTSIZE=1000
export HISTFILESIZE=2000

# Keep track of LINES and COLUMNS after each command.
shopt -s checkwinsize

# Prompt and terminal title.
export PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w/\[\033[00m\]\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}: ${PWD/$HOME/~}/\007"'
export MACHINE=$HOSTNAME

export EDITOR='vim -X'
[ -d $HOME/bin/export ] && export PATH=$HOME/bin/:$PATH

# make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# make bash autocomplete with up arrow.
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias ..='cd ..'
alias vi='vim -X'
alias vim='vim -X'
alias vimdiff='vimdiff -X'

# Tmux stuff.
function mksc() { export WORKDIR=$PWD ; tmux new-session -s $1 ; }
function rsc() { tmux attach-session -t $1 ; }
function lsc() { $HOME/bin/tmux-complete.py ; }
complete -o nospace -C "$HOME/bin/tmux-complete.py" mksc
complete -o nospace -C "$HOME/bin/tmux-complete.py" rsc

# Local stuff.
[ -f $HOME/.bashrc_local ] && source $HOME/.bashrc_local

# Last thing to do: change directory if this is a TMUX session.
[ -n "$WORKDIR" ] && [ -d "$WORKDIR" ] && cd "$WORKDIR"