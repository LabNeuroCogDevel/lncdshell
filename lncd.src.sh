#!/usr/bin/env bash

# 20170207WF - collect common convience functions
# 20171018WF - default to source all files in util directory

## source all others

# bash                       
LNCD_UTIL_SCRIPT="${BASH_SOURCE}";
# or zsh
[ -z "$LNCD_UTIL_SCRIPT" ] && LNCD_UTIL_SCRIPT="${(%):-%x}"

# dont continue if we are not bash or zsh
if [ -z "$LNCD_UTIL_SCRIPT" -o ! -r $LNCD_UTIL_SCRIPT ]; then 
 warn "You are not running in bash or zsh. You should be!"
else

 # source all of utils
 for f in $(dirname $LNCD_UTIL_SCRIPT)/utils/*sh; do 
   echo $f
   . $f
  done
fi
