
## wait for jobs
# use a job controlfile named after the script that calls watiforjobs + the hostname of the computer
# file defines MAXJOBS and WAITTIME (defaults below) and is sourced every iteration 

# USAGE:
#   JOBCFGDIR=jobcfg/; WAITTIME=2; MAXJOBS=2
#   for i in {1..20}; do sleep 10 &; waitforjobs; done
#

# set globals if we dont have them
[ -z "$MAXJOBS" ] && MAXJOBS=4
[ -z "$WAITTIME" ] && WAITTIME=60
[ -z "$JOBCFGDIR" ] && JOBCFGDIR=$(pwd)

njobs() { jobs -p |wc -l;}
jobcfg(){
 [ ! -r $JOBCFGDIR ] && mkdir $JOBCFGDIR
 local maxjobfile=$JOBCFGDIR/$(basename $0)-$(hostname).jobcfg
 [ ! -r $maxjobfile ] && echo -e "MAXJOBS=$MAXJOBS\nWAITTIME=$WAITTIME" > $maxjobfile
 source $maxjobfile
}
waitforjobs() {
 jobcfg
 local i=1
 while [ $(njobs) -ge $MAXJOBS ]; do
  echo "[$(date +%FT%H:%M)] $(printf "%03d" $i) $(pwd): sleep $WAITTIME while $(njobs) >= $MAXJOBS"
  let i++
  sleep $WAITTIME
 done
}
