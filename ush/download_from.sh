#!/bin/bash
if [[ $# < 1 ]]; then
   echo "$0 <jet|ursa>"
   exit
fi

HPC=$1
declare -A locations  # Declare an associative array
locations["ursa"]="/scratch4/BMC/rtrr/FIX_RRFS2"
locations["jet"]="/lfs5/BMC/nrtrr/FIX_RRFS2"
### NOTE: gaea does not have a DTN for outgoing transfer
### orion/hercules: /work/noaa/zrtrr/FIX_RRFS2
### gaeaC6:  /gpfs/f6/bil-fire10-oar/world-shared/role.rrfsfix/FIX_RRFS2

if [[ -z "${locations[${HPC}]}" ]]; then
   echo "Not supported source HPC:${HPC}"
   exit 1
fi

ushdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${ushdir}/detect_machine.sh
set -x
basedir=$( dirname ${ushdir} )
logname=$(logname)
if [[ -z "${logname}" ]]; then # gaea DTN has no login name
   logname=${USER}
fi
cmd="rsync -avr --ignore-existing"

declare -A mappings  # Declare an associative array
mappings["Guoqing.Ge"]="Guoqing.Ge"
mappings["gge"]="Guoqing.Ge"
mappings["Samuel.Degelia"]="Samuel.Degelia"
mappings["sdegelia"]="Samuel.Degelia"
mappings["Junjun.Hu"]="Junjun.Hu"
mappings["jjhu"]="Junjun.Hu"
# the following are backups
#mappings["Ming.Hu"]="Ming.Hu"
#mappings["minghu"]="Ming.Hu"
#mappings["Shun.Liu"]="Shun.Liu"
#mappings["sliu"]="Shun.Liu"


declare -A DTN  # Declare an associative array
#DTN["hera"]="dtn-hera.fairmont.rdhpcs.noaa.gov"
DTN["ursa"]="dtn-ursa.fairmont.rdhpcs.noaa.gov"
DTN["jet"]="dtn-jet.boulder.rdhpcs.noaa.gov"

${cmd} ${mappings[${logname}]}@${DTN[${HPC}]}:${locations[${HPC}]}/.mega/ ${basedir}/.mega
