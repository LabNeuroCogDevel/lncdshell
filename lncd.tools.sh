#!/usr/bin/env bash

# get "warn" function -- doesn't work well with zsh
# source $(dirname ${BASH_SOURCE})/lncd.src.sh
warn(){
 echo -e $@ >&2
}

# what is the software used for the first dicom in a given dicom directory (searches recursively without max depth)
# 20170131 - orginally from  /Volumes/Phillips/CogRest/scripts/mrsoftware.bash, put here for WorkingMemory
MRdirSoftware() {
   s=$1
   [ -z "$s" -o ! -d "$s" ] && warn "dicom dir ('$s')  DNE" && return 1
   dcmf=$(find  -L $s -iname '*.dcm' -or -iname 'MR*' | sed 1q)
   [ -z "$dcmf" ] && warn "no dcm for $s" && continue
   # sotware is tag 18,1020, has spaces so we cant use dicom_hinfo 
   # there are 4 '/' before the actual softare info -- making it the 5th field
   software=$(dicom_hdr $dcmf |grep '^0018 1020'|cut -d/ -f5)
   [ -z "$software" ] && warn "no software for $dcmf" && return 1
   echo $software
}
# range of MRsoftwawre
# Rscript -e 'library(dplyr); read.table("txt/softwareinfo.txt") %>% group_by(V3) %>% summarise(first=min(V2),last=max(V2),n=n()) %>% arrange(first) %>% print.data.frame(row.names=F)'


### nii to 2D png/gif

# slicer and label file with imagemagick
# slicer_ img.nii.gz [ place/to/save/img/ ]
slicer_(){
 local f=$1
 local output=$(basename $f .nii.gz).png
 # second argument can be a prefix
 [ -z $2 ] && output=$2/$output

 [ -z "$f" -o ! -r "$f" ] && warn "shots given bad input file" && return 1
 [ -r $output ] && return 0
 slicer $f -a >( convert - -background white label:$(basename $f .nii.gz) -gravity center -append $output) || return 1
}

#take screenshots of all nifti's given and make gif
niis2gif(){
 out=$1; shift;
 [[ "$out"  =~ .gif$ || -z "$1" ]] && warn "bad input: $FUNC_NAME output.gif first.nii.gz [second.nii.gz ...]" && return 1
 tmpd=$(mktemp -d)
 for nii in $@; do
   slicer_ $nii $tmpd/ || return 1
 done
 convert $tmpd/*png $out 
 rm $tmpd
}
