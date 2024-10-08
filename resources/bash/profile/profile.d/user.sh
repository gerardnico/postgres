#!/bin/bash

# This script is called by `/etc/profile`
source bashlib-echo.sh

USER_UID=$(id -u)
# User is needed to change the permissions with supervisor on the socket
export USER
USER=$(whoami 2> /dev/null || echo 'noname')
export USER_GROUPS
USER_GROUPS=$(groups 2> /dev/null || echo 'nogroup')
#echo::info "To add a new group to the logged in user, use the '--add-group' option of docker"
if [ "$HOME" == '/' ] && [ "$USER_UID" != '0' ]; then
  # to avoid error with the HOME directory
  # such as `error: could not lock config file //.gitconfig: Permission denied`
  # Issue: https://gitlab.com/gitlab-org/gitlab-runner/-/issues/37408
  export HOME=/home/$USER
  echo::info "HOME: $HOME"
  if [ ! -d "$HOME" ]; then
      echo::info "Creating HOME=$HOME"
      mkdir -p "$HOME"
  fi
fi


