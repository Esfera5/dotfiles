#!/bin/sh
set -x
rm .bashrc ; ln -s dotfiles/.bashrc
ln -s dotfiles/.vimrc
ln -s dotfiles/.vim
ln -s dotfiles/.tmux.conf
ln -s dotfiles/bin
