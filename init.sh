#! /usr/bin/env bash

# bash
echo -e "---- bash ----\n"
echo "Executing: ln -s $HOME/dotfiles/bash_scripts/bashrc $HOME/.bashrc"
ln -s $HOME/dotfiles/bash_scripts/bashrc $HOME/.bashrc
echo -e "Executing: ln -s $HOME/dotfiles/bash_scripts/bash_profile $HOME/.bash_profile\n"
ln -s $HOME/dotfiles/bash_scripts/bash_profile $HOME/.bash_profile

# dwm
echo -e "---- dwm ----\n"
git clone https://git.suckless.org/dwm $HOME/dwm
ln -s $HOME/dotfiles/dwm/config.h $HOME/dwm/config.h
cd $HOME/dwm
sudo make clean install
sudo make clean

# slstatus
echo -e "---- slstatus ----\n"
git clone https://git.suckless.org/slstatus $HOME/slstatus
ln -s $HOME/dotfiles/slstatus/config.h $HOME/slstatus/config.h
cd $HOME/slstatus
sudo make clean install
sudo make clean
