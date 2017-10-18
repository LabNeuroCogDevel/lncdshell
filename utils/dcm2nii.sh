# configuration (file locations, settings) for MMY1 Cog Emo Sounds


# dicom to nifti using dcm2niix + 3dNotes
# USAGE:
#  dcm2nii "$out_dir" "$out_name" "raw_ protocol_dir"
#  dcm2nii ../raw/sub-10909_20111202/ sub-10909_20111202_T1w /data/Luna1/Raw/MultiModal/10909_20111202/axial_mprage_G2_256x192.5
dcm2nii() {
   local out_dir=$1;shift
   local file=$1; shift
   local raw_dir=$1; shift

   ! which dcm2niix >/dev/null && warn "you do not have dcm2niix installed!" && return 1
   ! which 3dNotes >/dev/null && warn "you do not have afni installed (want 3dNotes)!" && return 1
   [ -z "$file" ] && warn "$FUNCNAME: bad input! need out dir, file prefix, and raw_dir" && return 1
   [ ! -d "$out_dir" ] && warn "$FUNCNAME: output dir '$out_dir' DNE" && return 1
   [ ! -d "$raw_dir" ] && warn "$FUNCNAME: raw dir '$raw_dir' DNE" && return 1

   local create_file="$out_dir/$file.nii.gz"
   [ -r "$create_file" ] && return 0

   # bids yes, compress yes 
   set -x
   local cmd="dcm2niix -z y -o '$out_dir' -f '$file' -b y '$raw_dir'"
   eval "$cmd"
   3dNotes -h "$cmd" "$create_file"
   set +x
}

