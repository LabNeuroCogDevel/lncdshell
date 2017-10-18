#!/usr/bin/env bash

# 20170207WF - collect common convience functions
# 20171018WF - default to source all files in this directory

warn() {
 echo -e $@ >&2
}

# message when script exists with error
# USEAGE:
#   trap 'traperr $?' EXIT
traperr() {
 set +x 
 e=shift
 [ -n "$e" -a "$e" -ne 0 ]  && warn "!! EXITITING WITH ERROR !!\nerror $e in $(pwd)\nTRACE:\n\t${FUNC_NAME[@]}\n\t${BASH_SORUCE[@]}"
 return 0
}



### source all others

# bash                       
LNCD_UTIL_SCRIPT="${BASH_SOURCE}";
# or zsh
[ -z "$LNCD_UTIL_SCRIPT" ] && LNCD_UTIL_SCRIPT="${(%):-%x}"

if [ -z "$LNCD_UTIL_SCRIPT" -o ! -r $LNCD_UTIL_SCRIPT ]; then 
 warn "You are not running in bash or zsh. You should be!"
else
 for f in $(dirname $LNCD_UTIL_SCRIPT)/utils/*sh; do echo $f; . $f; done
fi
