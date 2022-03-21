#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
sleep 1

# install git
sudo apt-get install git

sleep 1

# install neofetch
sudo apt-get install neofetch

sleep 1

# install screenfetch
sudo apt-get install screenfetch

sleep 1

# install neovim
sudo apt-get install neovim

# crear carpeta para configuraciones nvim
mkdir -p ~/.config/nvim/
cp init.vim ~/.config/nvim/

sleep 1

# install tmux
sudo apt-get install tmux

sleep 1

# install oh-my-bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# done
echo ""
echo "DONE!"
