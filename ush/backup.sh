#!/bin/bash
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${basedir}/detect_machine.sh
cd ${basedir}/..
rm -f output.hpss

set -x
pwd
case ${MACHINE} in
  orion|hercules)
    echo "No HPSS access on orion/hercules"
    exit 1
    ;;
  gaea)
    set +x
    echo module use /usw/hpss/modulefiles
    echo module load hsi
    set -x
    echo "currently, role.rrfsfix cannot access HPSS from gaea"
    exit 1
    ;;
  *)
    module load hpss
esac

sbatch ush/save2hpss.${MACHINE}

echo "hsi ls -l /BMC/rtrr/5year/FIX_RRFS2"
