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
    mkdir -p ~/Downloads/fonts
    cd ~/Downloads/fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    
    ;;

  2)
    echo "Making stuff pretty..."


    mv ~/.zshrc ~/.zshrc.bak
    touch ~/.zshrc

    {
    echo "ZINIT_HOME='${XDH_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git'"
    echo "if [ ! -d \"\$ZINIT_HOME\" ]; then"
    echo "mkdir -p \"\$(dirname \$ZINIT_HOME)\""
    echo "git clone https://github.com/zdharma-continuum/zinit.git '$ZINIT_HOME'"
    echo "fi"

    echo "source \${ZINIT_HOME}/zinit.zsh "
    echo "zinit ice depth=1; zinit light romkatv/powerlevel10k"

    echo "zinit light zsh-users/zsh-syntax-highlighting"
    echo "zinit light zsh-users/zsh-completions"
    echo "zinit light zsh-users/zsh-autosuggestions"
    echo "zinit snippet OMZP::git"
    echo "zinit snippet OMZP::sudo"
    echo "zinit snippet OMZP::kubectl"
    echo "zinit snippet OMZP::kubectx"
    echo "zinit snippet OMZP::command-not-found"


    echo "autoload -U compinit && compinit"

    echo "zinit cdreplay -q"

    echo "HISTSIZE=5000" 
    echo "HISTFILE=~/.zsh_history" 
    echo "SAVEHIST=$HISTSIZE" 
    echo "HISTDUP=erase" 
    echo "setopt appendhistory" 
    echo "setopt sharehistory" 
    echo "setopt hist_ignore_space" 
    echo "setopt hist_ignore_all_dups" 
    echo "setopt hist_save_no_dups" 
    echo "setopt hist_ignore_dups" 
    echo "setopt hist_find_no_dups"

    
    echo "alias ls=ls --color"

    } >> ~/.zshrc
    
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
    
    ;;  
  4)
    {
    echo "alias kn=kubens"
    echo "alias switch=kubectx"
    } >> ~/.zshrc
    echo "Aliases set. Restart the terminal or run 'source ~/.zshrc'"
    ;;

  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac
