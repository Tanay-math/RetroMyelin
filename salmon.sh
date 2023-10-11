#!/bin/bash
# set the number of nodes
#SBATCH -n 10
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

f1="/path/to/input/directory/where/sortmeRNAAfterTrimmomatics/files/kept"
f2="/path/to/output/directory"
f3="/path/to/Salmon-0.8.2_linux_x86_64/bin/"

for i in 1 2 3 4
do
echo "starting sic$i"
$f3/salmon quant -i /servers/bio-shares-2/franklin-bioinf/tg369/ratcdna.ncrna_salmonindexed -l ISF -1 $f1/sic$i-r_1-trimmo-sortmerna.fq -2 $f1/sic$i-r_2-trimmo-sortmerna.fq  -p 8 -o $f2/sic$i
echo "completed:sic$i"
cd $f2
done

for i in 1 2 3
do
echo "starting siR$i"
$f3/salmon quant -i /servers/bio-shares-2/franklin-bioinf/tg369/ratcdna.ncrna_salmonindexed -l ISF -1 $f1/siR$i-r_1-trimmo-sortmerna.fq -2 $f1/siR$i-r_2-trimmo-sortmerna.fq  -p 8 -o $f2/siR$i
echo "completed:siR$i"
cd $f2
done


