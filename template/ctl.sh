#!/bin/bash

set -e

PROJECT_DIR="$( cd "$( dirname "$0" )" && pwd )"
COMMAND="$1"

if [ "$COMMAND" = 'help' ]; then
    echo 'ctl.sh commands:'
    echo '  help:    display this help'
    echo '  install: install the required environment'
    echo '  edit:    edit the lilypond score file'
    echo '  build:   build the project'
    echo '  play:    play the audio file'
    echo '  display: display the sheet music'
elif [ "$COMMAND" = 'install' ]; then
    sudo apt-get install lilypond &&
    sudo apt-get install musescore3 &&
    sudo apt-get install frescobaldi &&
    sudo apt-get install okular &&
    sudo apt-get install bash-completion &&
    echo 'Installation completed.';
elif [ "$COMMAND" = 'edit' ]; then
    frescobaldi "${PROJECT_DIR}/score.ly" 2>&1 > /dev/null &
elif [ "$COMMAND" = 'build' ]; then
    ls -A1 "${PROJECT_DIR}/out" | egrep -v '.gitignore' | xargs -i rm "${PROJECT_DIR}/out/{}"
    lilypond "${PROJECT_DIR}/score.ly"
    musescore -o "${PROJECT_DIR}/out/score.wav" "${PROJECT_DIR}/out/score.midi"
elif [ "$COMMAND" = 'play' ]; then
    vlc "${PROJECT_DIR}/out/score.wav" 2>&1 > /dev/null &
elif [ "$COMMAND" = 'display' ]; then
    okular "${PROJECT_DIR}/out/score.pdf" 2>&1 > /dev/null &
elif [ -z "$COMMAND" ]; then
    echo "No command given!"
    exit 1
else
    echo "Unknown command: '${COMMAND}'"
    exit 2
fi
 
