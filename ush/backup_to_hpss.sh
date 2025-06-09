#!/bin/bash
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${basedir}/detect_machine.sh
cd ${basedir}/..
rm -f output.hpss
rm -rf _tmp_tar_

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

set -x
pwd
sbatch ush/job_hpss.${MACHINE}
set +x

echo "check the archived tarball at:"
echo "  hsi ls -l /BMC/rtrr/5year/FIX_RRFS2"
echo "Be sure to remove the _tmp_tar_ directory when the backup is done"
