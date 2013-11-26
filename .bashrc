# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

export MACHINE="${HOSTNAME/\.*/}"

function __update_prompt() {
  export GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  local p_root="\[\e[0m\]${debian_chroot:+($debian_chroot)}"
  local p_time="\[\e[1;30m\]\t"
  local p_host="\[\e[1;32m\]$MACHINE"
  local p_path="\[\e[1;34m\]${PWD/#$HOME/~}"
  if [[ ! "$p_path" =~ /$ ]]; then
    p_path="$p_path/"
  fi
  local p_git=""
  if [ -n "$GIT_BRANCH" ]; then
    p_git="\[\e[1;33m\][$GIT_BRANCH]"
  fi
  local p_end="\[\e[0m\]$ "
  # Exporting values.
  PS1="${p_root}${p_time} ${p_host}:${p_path}${p_git}${p_end}"
  export PROMPT_TEXT=""
  if [ -n "$TMUX" ]; then
    export PROMPT_TEXT="\033k$(echo $GIT_BRANCH)\033\\"
  elif [[ "$TERM" =~ "xterm" ]]; then
    export PROMPT_TEXT="\e]0;$MACHINE:${PWD/$HOME/~}$\007"
  fi
}

export PROMPT_COMMAND='__update_prompt ; echo -ne "$(echo $PROMPT_TEXT)"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias vi='vim -X'
alias vim='vim -X'
alias vimdiff='vimdiff -X'
alias less='less -S'
alias rmorig='find . -name *.orig -delete'
alias rmpyc='find . -name *.pyc -delete'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i \
"$([ $? = 0 ] && echo terminal || echo error)" \
"$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Make bash autocomplete with up arrow.
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

export EDITOR='vim -X'
[ -d "$HOME/bin" ] && export PATH="$HOME/bin/:$PATH"
[ -d "$HOME/bin_local" ] && export PATH="$HOME/bin_local/:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin/:$PATH"

# TMUX stuff.
export DEPOT="$HOME/depot"
# It's OK to list sessions while in TMUX session.
function lsc() {
  $HOME/bin/tmux-complete.py
}
if [ -z "$TMUX" ]; then
  # Not in TMUX session, adding TMUX attach commands.
  function rsc() {
    local client="$1"
    [ -z "$client" ] && echo "Usage: $FUNCNAME <foo>" && return
    pushd "$DEPOT/$client" > /dev/null || return
    if [ ! $(tmux list-sessions | grep --quiet "^$client:") ]; then
      tmux -q new-session -d -s "$client" > /dev/null
    fi
    local sessionid="$client.$$"
    tmux -q new-session -t "$client" -s "$sessionid" \;\
        set-option destroy-unattached \;\
        set-option default-path "$DEPOT/$client" \;\
        attach-session -t "$sessionid" > /dev/null
    popd > /dev/null
  }
  complete -o nospace -C "$HOME/bin/tmux-complete.py" rsc
fi

# Local stuff.
[ -f $HOME/.bashrc_local ] && source $HOME/.bashrc_local

