
#### quick afni in working directory with mni template

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
