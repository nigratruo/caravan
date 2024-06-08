# Add...
# source ~/.mysh/bootstrap.sh
# in your *rc file.
#

if test -n "$ZSH_VERSION"; then
  current_shell=zsh
elif test -n "$BASH_VERSION"; then
  current_shell=bash
elif test -n "$KSH_VERSION"; then
  current_shell=ksh
elif test -n "$FCEDIT"; then
  current_shell=ksh
elif test -n "$PS3"; then
  current_shell=unknown
else
  current_shell=sh
fi

# Information

echo "Home: ""$HOME"
echo "Using Shell: ""$current_shell"
echo "- - - - - - - - - - - - - - - - - - - -"

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH="$HOME/.mysh/bin":$PATH
export VISUAL=vim


mysh_bootstrap(){

  if [ -f "$HOME/.mysh/setup/shell/$current_shell.sh" ]; then
    echo "Loading current shell setup file."
    source "$HOME/.mysh/setup/shell/$current_shell.sh"
  else
    echo ".mysh cant handle shell:""$current_shell"
    exit 1
  fi

  #
  # User Custom files....
  #

  echo "Loading .mysh/setup/common files."
  for f in ~/.mysh/setup/common/*;
  do
    case "${f}" in
      *".sh")
        source "${f}"
      ;;
    esac
  done


  echo "Loading .mysh/setup/vendor files."
  for f in ~/.mysh/setup/vendor/*;
  do
    case "${f}" in
      *".sh") source "${f}";;
    esac
  done


  echo "Loading User extension files."
  if [ ! -e "$HOME/.mysh/extension" ]; then
    mkdir "$HOME/.mysh/extension"
  fi
  for f in ~/.mysh/extension/*;
  do
    case "${f}" in
      *".sh") source "${f}";;
    esac
  done


  touch ~/.shrc.local
}


# Runs bootstrap
mysh_bootstrap

export XDG_CONFIG_HOME=~/.config
