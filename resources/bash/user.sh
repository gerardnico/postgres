#!/bin/bash


# This script is called by `/etc/profile`
# Run on non-interactive, ie when the terminal starts


USER_UID=$(id -u)
# User is needed to change the permissions with supervisor on the socket
export USER
USER=$(whoami 2> /dev/null || echo 'noname')
export USER_GROUPS
USER_GROUPS=$(groups 2> /dev/null || echo 'nogroup')
echo_info "User: $USER, UID: $USER_UID, GID: $(id -g), Groups: $USER_GROUPS"
echo_info "To add a new group to the logged in user, use the '--add-group' option of docker"
if [ "$HOME" == '/' ] && [ "$USER_UID" != '0' ]; then
  # to avoid error with the HOME directory
  # such as `error: could not lock config file //.gitconfig: Permission denied`
  # Issue: https://gitlab.com/gitlab-org/gitlab-runner/-/issues/37408
  export HOME=/home/$USER
  echo "HOME: $HOME"
  if [ ! -d "$HOME" ]; then
      echo_info "Creating HOME=$HOME"
      mkdir -p "$HOME"
  fi
fi


