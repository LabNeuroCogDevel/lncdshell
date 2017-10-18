#!/usr/bin/env bash

# get "warn" function

# source $(dirname ${BASH_SOURCE})/lncd.src.sh #BASH
# source $(dirname $0)/lncd.src.sh #ZSH
thisdir=""; [ -n "$BASH_SOURCE" ]  && this=${BASH_SOURCE}; [ -n "$ZSH_VERSION" ]  && this=$0; [ -z "$thisdir" ] && this=/opt/ni_tools/lncdshell/junk; thisdir=$(dirname $this)
source $thisdir/lncd.src.sh

## dicom to nifti with dcmstack (embeded json metadata) + afni history for MR* files
#usage:
# MR2niigz /Volumes/Phillips/Raw/MRprojects/mMRDA-dev/2016.04.13-08.51.01/B0131/tfl_MT_128x96.11/  ~/test.nii.gz
MR2niigz() {
 dcmdir=$1
 output=$2
 [ ! -d "$dcmdir" ] && warn "$FUNC_NAME needs first argument dicomdir '$1' to exist"  && return 1
 [ -z "$output" ] && warn "$FUNC_NAME needs second argument: what to call the output" && return 1
 #[ -r "$output" -o -r $output.nii.gz ] && return 0 # skip if exists
 #[ ! -d $(dirname $output) ] && mkdir -p $(dirname $output) # make output directory?
 odir=$(dirname $output)
 oname=$(basename $output .nii.gz)
 # include all meta data fields, embend into the nii.gz, look for MR* files, save to $output ($odir/$oname)
 cmd="dcmstack --include '.*' --embed-meta --file-ext 'MR*' --dest-dir $odir -o $oname $dcmdir"
 eval $cmd  || return 1

 3dNotes -h "$cmd" $output

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
 [ -n "$2" ] && output=$2/$output
 [ -z "$f" -o ! -r "$f" ] && warn "shots given bad input file" && return 1
 [ -r $output ] && return 0

 label=$(basename $f .nii.gz)
 slicer $f -a >( convert - -background white label:"$label" -gravity center -append $output) || return 1
 sleep 1
}

#take screenshots of all nifti's given and make gif
niis2gif(){
 out=$1; shift;
 [[ ! "$out"  =~ .gif$ || -z "$1" ]] && warn "bad input: $FUNC_NAME output.gif first.nii.gz [second.nii.gz ...]" && return 1
 #tmpd=$(mktemp -d)
 tmpd=$(mktemp -d tmpXXXXX ) || return 1
 for nii in $@; do
   slicer_ $nii $tmpd/ || return 1
 done
 convert -delay 350 $tmpd/*png $out 
 [ -n "$tmpd" ] && rm -r $tmpd
}
