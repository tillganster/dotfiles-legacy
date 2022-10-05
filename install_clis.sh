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

ask_for_confirmation "install standard cli tools you need"
  if answer_is_yes; then 
    brew install jq
    curl -s "https://get.sdkman.io" | bash
    brew install docker
    brew install go 
    brew install derailed/k9s/k9s
    brew install node
    brew install fzf
    # TODO install k8s fzf plugin
    brew install gh
    gh completion --shell zsh > $ZSH_CUSTOM/plugins/gh.zsh
    #echo "# github" >> ~/.zshrc.local
    #echo "compctl -K _gh gh
     
  fi