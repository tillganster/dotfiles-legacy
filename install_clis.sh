#! /bin/bash
print_success() {
  if [[ $BUILD ]]; then
    # Print output in green
    printf "\e[0;32m  [✔] %s\e[0m\n" "$1"
  else
    # Print output in cyan
    printf "\e[0;36m  [✔] Unlinked %s\e[0m\n" "$1"
  fi
}

print_error() {
  if [[ $BUILD ]]; then
    # Print output in red
    printf "\e[0;31m  [✖] %s %s\e[0m\n" "$1" "$2"
  else
    # Print output in red
    printf "\e[0;31m  [✖] Failed to unlink %s %s\e[0m\n" "$1" "$2"
  fi
}

print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] %s\e[0m" "$1"
}

execute() {
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}

print_result() {
  if [ "$1" -eq 0 ]; then
    print_success "$2"
  else
    print_error "$2"
  fi

  [ "$3" == "true" ] && [ "$1" -ne 0 ] && exit
}

ask_for_confirmation() {
  print_question "$1 [y/N] "
  read -r -n 1
  printf "\n"
}

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}


install_krew(){
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" 
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" 
  KREW="krew-${OS}_${ARCH}" 
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" 
  tar zxvf "${KREW}.tar.gz" 
  ./"${KREW}" install krew 

}
ask_for_confirmation "install standard cli tools you need"
  if answer_is_yes; then 
    brew install jq
    curl -s "https://get.sdkman.io" | bash
    brew install docker
    brew install go 
    brew install derailed/k9s/k9s
    brew install node
    brew install nvm
    brew install fzf
    curl https://raw.githubusercontent.com/bonnefoa/kubectl-fzf/main/shell/kubectl_fzf.plugin.zsh -O ~/.kubectl_fzf.plugin.zsh
    echo "You have to install kubectl-fzf-server to get this plugin to work"
    echo -e '\e]8;;https://github.com/bonnefoa/kubectl-fzf\aSee here\e]8;;\a'
    # TODO install k8s fzf plugin
    brew install gh
    brew install go-task/tap/go-task
    brew install kubectl 
    brew install helm
    gh completion --shell zsh > $ZSH_CUSTOM/plugins/gh.zsh
    #echo "# github" >> ~/.zshrc.local
    #echo "compctl -K _gh gh    
    install_krew

  fi;
