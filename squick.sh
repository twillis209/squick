#!/bin/sh

usage() { echo "Usage: $0 -J JOBNAME -C COMMAND [-D WORKDIR]  [-p ARCH] [-c CPUS_PER_TASK] [-t TIME] [-o OUTPUT]" 1>&2; exit 1; }

TIME="1:00:00"
ARCH="cclake,skylake,skylake-himem"
CPUS_PER_TASK="1"
OUTPUT="%x-%j.out"
WORKDIR="$PWD"

while getopts "J:c:t:p:D:C:o:" opt; do
    case $opt in
        J) JOBNAME=$OPTARG
           ;;
        c) CPUS_PER_TASK=$OPTARG
           ;;
        t) TIME=$OPTARG
           ;;
        p) ARCH=$OPTARG
           ;;
        D) WORKDIR=$OPTARG
           ;;
        C) COMMAND=$OPTARG
           ;;
        o) OUTPUT=$OPTARG
           ;;
        ?|*) usage
           ;;
    esac
done

shift $((OPTIND-1))

if [ -z "${JOBNAME}" ] || [ -z "${CPUS_PER_TASK}" ] || [ -z "${TIME}" ] || [ -z "${ARCH}" ] || [ -z "${WORKDIR}" ] || [ -z "${COMMAND}" ] || [ -z "${OUTPUT}" ]; then
    usage
fi

printf 'JOBNAME=%s\nCPUS_PER_TASK=%s\nTIME=%s\nARCH=%s\nWORKDIR=%s\nCOMMAND=%s\nOUTPUT=%s\n' "$JOBNAME" "$CPUS_PER_TASK" "$TIME" "$ARCH" "$WORKDIR" "$COMMAND" "$OUTPUT"

# Substitution to escape the forward slashes, which are used as delimiters in the sed command
COMMAND="${COMMAND//\//\\/}"

# For some reason, two substitutions (both $COMMAND and $WORKDIR) did not work
sed "s/<COMMAND>/$COMMAND/; s/<WORKDIR>/${WORKDIR//\//\\/}/; s/<OMP_NO_OF_THREADS>/$CPUS_PER_TASK/;" /home/tw395/bashScripts/squick/squick_slurm_submit_template >"/home/tw395/bashScripts/squick/squick_slurm_submit_$JOBNAME"

sbatch -J $JOBNAME -A MRC-BSU-SL2-CPU -N 1 -n 1 -c $CPUS_PER_TASK -t $TIME --mail-type "FAIL" -p "$ARCH" -D "$WORKDIR" -o "$OUTPUT" "/home/tw395/bashScripts/squick/squick_slurm_submit_$JOBNAME"

rm "/home/tw395/bashScripts/squick/squick_slurm_submit_$JOBNAME"
