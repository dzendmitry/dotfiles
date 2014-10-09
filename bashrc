if [ -z "$PS1" ]; then
   return
fi

[ -f /etc/bashrc ] && . /etc/bashrc

if [[ $OSTYPE == *darwin* ]]; then
  eval $(launchctl export | grep -Ev ^.*/.*=)
  _prompt_host=macbook
else
  _prompt_host="\\h"
fi

_prompt_len=16

alias hist='history|egrep'

if [[ ${TERM} == "xterm-256color" || ${TERM} == "xterm-color" ]]; then
 export CLICOLOR=${TERM}
 __c() {
  printf "\\[\033[38;5;%sm\\]" $1
 }
 __r="\\[\033[0m\\]"
 _set_prompt_tab() {
   PS1="\[\033]0;\u@${_prompt_host}:\w\007\]"
 }
 _t_red="\[$(tput setaf 1)\]"
 _t_green="\[$(tput setaf 2)\]"
 _t_yellow="\[$(tput setaf 3)\]"
 _t_cyan="\[$(tput setaf 6)\]"
 _t_rst="\[$(tput sgr0)\]"
else
 __c() {
   return
 }
 __r() {
   return
 }
 _set_prompt_tab() {
   return
 } 
fi

__c_host=$(__c 172)
__c_cwd=$(__c 38)
__c_prompt=$(__c 2)
__c_alert=$(__c 1)
__c_git_clean=$(__c 42)
__c_git_mostly_clean=$(__c 208)
__c_git_dirty=$(__c 197)

_has_git=$(which git)

if [ -x $(which git) ]; then
  _set_prompt_git() {
    local branch state
    if git rev-parse --git-dir > /dev/null 2>&1; then
      branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
      state=$(git status --porcelain 2> /dev/null | sed -e 's/^\(..\).*/\1/' | uniq)  
      if [[ ${state} == "" ]]; then
        PS1+="${__c_git_clean}${branch}${__r}"
      elif [[ ${state} == "??" ]]; then
        PS1+="${__c_git_mostly_clean}${branch}?${__r}"
      else
        PS1+="${__c_git_dirty}${branch}*${__r}"
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
   PS1+="${__c_host}\u@${_prompt_host}:${__c_cwd}${t}${__r}"
}

_set_prompt() {  
  _set_prompt_tab
  _set_prompt_pwd
  _set_prompt_git
  PS1+="\$(if [[ \$? == 0 ]]; then echo \"${__c_prompt}$\"; else echo \"${__c_alert}✗\"; fi)${__r} "
}
PROMPT_COMMAND="_set_prompt"

if [ -f /opt/local/etc/bash_completion ]; then
   . /opt/local/etc/bash_completion
fi

export HISTFILESIZE=8000
export HISTSIZE=2000

