#!/bin/bash

echo "Enter desired setup:"
echo "1. start - Basic setup (wget, curl, git, zsh, set zsh as default shell)"
echo "2. prettify - Downloading fonts and setting powerlevel10k theme"
echo "3. tools - Install tools like kubectl, kubens, kubectx"
echo "4. alias - Set aliases k, kn, switch, g"
read -p "Enter what to do [1-4]: " choice

case $choice in
  1)
    echo "Installing wget, curl, git, and zsh..."
    sudo apt install wget curl git zsh -y
    echo "Setting zsh as default shell (password prompt may appear)"
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ;;

  2)
    echo "Making stuff pretty..."
    mkdir -p ~/Downloads/fonts
    cd ~/Downloads/fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' ~/.zshrc
    echo "Remember to change the font for Ubuntu terminal!"
    echo "Restart the terminal window!"
    ;;
  
  3)
    echo "Installing tools..."
    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens

    kubectl_url=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    curl -LO "https://dl.k8s.io/release/$kubectl_url/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin

    mkdir -p ~/.oh-my-zsh/completions
    chmod -R 755 ~/.oh-my-zsh/completions
    ln -sf /opt/kubectx/completion/kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
    ln -sf /opt/kubectx/completion/kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
    ;;  
  4)
    {
    echo "alias k=kubectl"
    echo "alias kn=kubens"
    echo "alias switch=kubectx"
    echo "alias g=git"
    } >> ~/.zshrc
    echo "Aliases set. Restart the terminal or run 'source ~/.zshrc'"
    ;;

  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac
