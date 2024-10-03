#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -f "$SCRIPT_DIR"/color.sh ]; then
  source "$SCRIPT_DIR"/color.sh
fi


function cli_name(){
  # caller return the LINE, the function and the script
  # example: 10 main /opt/dokuwiki-docker/bin/dokuwiki-docker-entrypoint
  CLI_NAME=""
  if read -r _ _ CALLING_SCRIPT < "$(caller 1)"; then
    # Name of the calling script
    CLI_NAME=$(basename "$CALLING_SCRIPT")
  fi
  if [ "$CLI_NAME" == "echo.sh" ] || [ "$CLI_NAME" == "" ]; then
    if read -r _ _ CALLING_SCRIPT < "$(caller 0)"; then
      CLI_NAME=$(basename "$CALLING_SCRIPT")
    fi
  fi

  if [ "$CLI_NAME" == "echo.sh" ] || [ "$CLI_NAME" == "" ]; then
    echo "main"
  fi
  echo "$CLI_NAME - yolo"

}


# Echo an info message
function echo_info() {

  echo -e "$(cli_name) apo: ${1:-}"

}

# Print the error message $1
echo_err() {
  echo_info "${RED}Error: $1${NC}"
}

# Function to echo text in green (for success messages)
echo_success() {
    echo_info -e "${GREEN}Success: $1${NC}"
}

# Function to echo text in yellow (for warnings)
echo_warn() {
    echo_info -e "${YELLOW}Warning: $1${NC}"
}

#export -f echo_info
#export -f echo_err
#export -f echo_warn
#export -f cli_name