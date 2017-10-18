# useful tools for handling errors
# used by other functions too

warn() { echo -e $@ >&2; }
exiterr() { warn $@; exit 1; }

# message when script exists with error
# bash specific (not very useful for zsh)
# USEAGE:
#   trap 'traperr $?' EXIT
traperr() {
 set +x 
 e=shift
 [ -n "$e" -a "$e" -ne 0 ]  && warn "!! EXITITING WITH ERROR !!\nerror $e in $(pwd)\nTRACE:\n\t${FUNC_NAME[@]}\n\t${BASH_SORUCE[@]}"
 return 0
}
