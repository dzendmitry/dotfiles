[ -f /etc/bashrc ] && . /etc/bashrc

eval $(launchctl export | grep -Ev ^.*/.*=)

if [[ -t "0" || -p /dev/stdin ]]
then 
#### INTERACTIVE SHELL

if [[ ${TERM} == "xterm-256color" || ${TERM} == "xterm-color" ]]; then
 export CLICOLOR=${TERM}
 _ps1_statusbar="\[\033]0;\u@macbook:\w\007\]"
fi

alias hist='history|egrep'

_ps1_len=16

_ps1_truncated_pwd() {
    local b t r
    b=${PWD/$HOME/\~}
    if [[ ${#b} == ${_ps1_len} ]]; then
       echo $b
    else
       t=${b: -${_ps1_len}}
      if [[ "$t" == "" ]]; then
        echo $b
      else
        echo …$t
      fi
   fi
}

_ps1_parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

_ps1_parse_git_dirty() {
    st=$(git status 2>/dev/null | tail -n 1)
    if [[ $st == "" ]]; then
        echo ''
    elif [[ ${st##nothing to commit*} == "" ]]; then
        echo ''
    elif [[ ${st##nothing added*} == "" ]]; then
        echo '?'
    else
        echo '*'
    fi
}

_ps1_term_green="\[$(tput setaf 2)\]"
_ps1_term_red="\[$(tput setaf 1)\]"
_ps1_term_cyan="\[$(tput setaf 6)\]"
_ps1_term_rst="\[$(tput sgr0)\]"

export PS1="${_ps1_statusbar}${_ps1_term_rst}${_ps1_term_cyan}\u@macbook${_ps1_term_rst}:\$(_ps1_truncated_pwd)${_ps1_term_green}\$(_ps1_parse_git_branch)${_ps1_term_red}\$(_ps1_parse_git_dirty)${_ps1_term_rst}$ "

if [ -f /opt/local/etc/bash_completion ]; then
   . /opt/local/etc/bash_completion
fi

export HISTFILESIZE=8000
export HISTSIZE=2000

#### END OF INTERACTIVE SHELL CHECK
fi
