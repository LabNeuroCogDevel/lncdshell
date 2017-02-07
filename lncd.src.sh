#!/usr/bin/env bash

# 20170207WF - collect common convience functions

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

####

# standard template brain
MNIT1=/opt/ni_tools/standard_templates/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c.nii
[ ! -r $MNIT1 ] && warn "cannot read $MNIT1"

afni_() {
 anat=$(basename $MNIT1)
 # afni takes in .nii but calls them .nii.gz
 [[ "$MNIT1" =~ .nii$ ]] && anat=$anat.gz
 # launch afni with all images in directory with default MNI underlay and niml + plugouts set
 afni -yesplugouts -niml -com "SET_ANATOMY $anat" -dset $MNIT1 $(find . -maxdepth 1 -type f \( -iname '*HEAD' -or -iname '*.nii*' \))
}
