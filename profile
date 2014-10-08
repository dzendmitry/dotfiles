
if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
fi

if [ "${BASH-no}" != "no" ]; then
        [ -r ~/.bashrc ] && . ~/.bashrc
fi

if [[ $(which fortune) != "" ]]; then
   echo
   fortune
   echo
fi
