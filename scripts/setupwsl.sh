##!/bin/bash
echo "Enter desired setup:"
echo "start - for basic setup (wget, curl, git and zsh, sets zsh as default shell"
echo "tools - for great tools like kubectl, kubens, kubectx:"
echo "alias - for aliases k, kn, switch, g:"
read -p "Enter what to do: " stuff

if test "$stuff" = "start"
then
  echo "Installing wget, curl and git\n\n\n"
  sudo apt install wget curl git zsh -y
  "Set zsh as default shell for logged in user, prompts for password!"
  chsh -s $(which zsh) 
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

fi

if test "$stuff" = "tools"
then
  echo "Installing tools"
  echo "Installing kubens and kubectx"
  sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

  echo "Fixing autocompletes"
  mkdir -p ~/.oh-my-zsh/completions
  chmod -R 755 ~/.oh-my-zsh/completions
  ln -s /opt/kubectx/completion/kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
  ln -s /opt/kubectx/completion/kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh

echo "Making things pretty..."
mkdir ~/Downloads
cd ~/Downloads
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
echo "Set powerlevel theme"
cd ~
sed -i 's/robbyrussel/powerlevel10k\/powerlevel10k/g' .zshrc
echo "Glöm inte att ändra font för ubuntu"
echo "Starta om fönstret!"
fi
if test "$stuff" = "alias"
then
  cd ~
  echo "alias k=kubectl" >> .zshrc
  echo "alias kn=kubens" >> .zshrc
  echo "alias switch=kubectx" >> .zshrc
  echo "alias g=git" >> .zshrc
  echo "Starta om asdf!"
fi
