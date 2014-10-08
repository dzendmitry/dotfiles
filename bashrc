if [ -z "$PS1" ]; then
   return
fi

[ -f /etc/bashrc ] && . /etc/bashrc

eval $(launchctl export | grep -Ev ^.*/.*=)

_prompt_host=macbook
_prompt_len=16

alias hist='history|egrep'

if [[ ${TERM} == "xterm-256color" || ${TERM} == "xterm-color" ]]; then
 export CLICOLOR=${TERM}
 _set_prompt_tab() {
   PS1="\[\033]0;\u@macbook:\w\007\]"
 }
 _t_red="\[$(tput setaf 1)\]"
 _t_green="\[$(tput setaf 2)\]"
 _t_yellow="\[$(tput setaf 3)\]"
 _t_cyan="\[$(tput setaf 6)\]"
 _t_rst="\[$(tput sgr0)\]"
else
 _set_prompt_tab() {
   return
 } 
fi

_has_git=$(which git)

if [ -x $(which git) ]; then
  _set_prompt_git() {
    local branch state
    if git rev-parse --git-dir > /dev/null 2>&1; then
      branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
      state=$(git status --porcelain | sed -e 's/^\(..\).*/\1/' | uniq)  
      if [[ ${state} == "" ]]; then
        PS1+="${_t_green}${branch}${_t_rst}"
      elif [[ ${state} == "??" ]]; then
        PS1+="${_t_yellow}${branch}?${_t_rst}"
      else
        PS1+="${_t_red}${branch}*${_t_rst}"
      fi
    fi
  }
else
 _set_prompt_git() {
  return
 }
fi  

_set_prompt_pwd() {
    local b t r
    b=${PWD/$HOME/\~}
    if [[ ${#b} == ${_prompt_len} ]]; then
       t=${b}
    else
       t=${b: -${_prompt_len}}
       if [[ "$t" == "" ]]; then
         t=${b}
       else
         t="…${t}"
       fi
   fi
   PS1+="${_t_cyan}\u@${_prompt_host}:${t}${_t_rst}"
}

_set_prompt() {  
  _set_prompt_tab
  _set_prompt_pwd
  _set_prompt_git
  PS1+="$ "
}
PROMPT_COMMAND="_set_prompt"

if [ -f /opt/local/etc/bash_completion ]; then
   . /opt/local/etc/bash_completion
fi

export HISTFILESIZE=8000
export HISTSIZE=2000

