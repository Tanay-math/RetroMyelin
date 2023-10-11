#!/bin/bash
# set the number of nodes
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -p cccp # Partition to submit to
#SBATCH -o slurm.%N.%j.out        # STDOUT
#SBATCH -e slurm.%N.%j.err        # STDERR
#hostname
echo "Starting at `date`"
echo "Running on hosts: $SLURM_NODELIST"
echo "Running on $SLURM_NNODES nodes."
echo "Running on $SLURM_NPROCS processors."
echo "Current working directory is `pwd`"

uname -a
hostname --fqdn

Salmon-0.8.2_linux_x86_64/bin/salmon index -t Rattus_norvegicus.Rnor_6.0.cdna.ncrna.fa  -i ratcdna.ncrna_salmonindexed 
