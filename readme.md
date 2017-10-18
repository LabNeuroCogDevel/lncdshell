# LNCD shell functions

useful shell (bash, zsh) functions

## Usage
```bash
source lncd.src.sh
```

## Major Deliverables 
 * waitforjobs - job handling in bash
 * dcm2nii - dcm2niix + 3dNotes, default compression and json sidecar

## Minor hacks
 * `afni_` - include mni template + working directory)
 * `niis2gif` - make a gif from a bunch of niis
 * `warn` to echo to standard error
 * `exiterr` 
 * `traperr`  - `set -e; trap traperr EXIT`
