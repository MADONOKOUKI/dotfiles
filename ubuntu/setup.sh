#!/bin/bash -eu

formulas=(
          zsh
          rbenv
          mysql
          postgresql
          )

apps=(
      )

read -p "dotfilesは~/に置かれていますか？ (y/N): " yn0
case "$yn0" in [yY]*) ;; *) echo "abort." ; exit ;; esac

if ! type brew >/dev/null 2>&1; then
  echo "----------------------------------------------------------------------------"
  echo "installing brew..."
  sudo apt-get -y install build-essential curl git python-setuptools ruby
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"
  brew tap athrunsun/binaries
fi

echo "----------------------------------------------------------------------------"
echo "installing oh-my-zsh..."
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
ln -sf ~/dotfiles/mac/zshrc ~/.zshrc
ln -sf ~/dotfiles/mac/vimrc ~/.vimrc
mkdir ~/.zsh
cd ~/.zsh
git clone git://github.com/hchbaw/auto-fu.zsh.git
cd auto-fu.zsh
git checkout -b pu origin/pu
source ~/.zshrc
git secrets --register-aws --global
cd ~

echo "----------------------------------------------------------------------------"
echo "installing brew formula..."
brew install ${formulas[@]}

echo "----------------------------------------------------------------------------"
echo "installing apps..."
brew install ${apps[@]}

echo "----------------------------------------------------------------------------"
echo "cleanup brew cask..."
brew cask cleanup

echo "----------------------------------------------------------------------------"
echo "install aplle store apps..."
mas install ${appleapps[@]}

echo "----------------------------------------------------------------------------"
echo "set up rbenv..."
mkdir -p "$(rbenv root)/plugins"
git clone https://github.com/znz/rbenv-plug.git "$(rbenv root)/plugins/rbenv-plug"
rbenv plug rbenv-update
rbenv plug rbenv-gem-rehash
rbenv plug rbenv-communal-gems
rbenv communize --all
rbenv rehash

echo "----------------------------------------------------------------------------"
echo "symbolic link of sublime text..."
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

echo "----------------------------------------------------------------------------"
echo "please set up iTerm2"
echo "please set up sublime text and lisence key"
echo "setup karabiner-elements (caps-lock-to-ctrl and vim-mode)"
echo "setup chrome(vimium React Developer Tool)"

echo "----------------------------------------------------------------------------"
echo "Success!"