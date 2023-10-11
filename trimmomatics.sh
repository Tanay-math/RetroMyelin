#!/bin/bash
# set the number of nodes
#SBATCH -n 20
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


f1="/path/to/input/directory"

f2="/path/to/output/directory"

java -jar trimmomatic-0.36.jar PE -phred33 $f1/sic1.r_1.fq.gz $f1/sic1.r_2.fq.gz $f2/sic1.r_1_trimo-paired.fq.gz $f2/sic1.r_1_trimo-unpaired.fq.gz $f2/sic1.r_2_trimo-paired.fq.gz $f2/sic1.r_2_trimo-unpaired.fq.gz ILLUMINACLIP:/servers/bio-shares-2/franklin-bioinf/tg369/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:3:20 MINLEN:50
rm $f2/*-unpaired.fq.gz

java -jar trimmomatic-0.36.jar PE -phred33 $f1/sic2.r_1.fq.gz $f1/sic2.r_2.fq.gz $f2/sic2.r_1_trimo-paired.fq.gz $f2/sic2.r_1_trimo-unpaired.fq.gz $f2/sic2.r_2_trimo-paired.fq.gz $f2/sic2.r_2_trimo-unpaired.fq.gz ILLUMINACLIP:/servers/bio-shares-2/franklin-bioinf/tg369/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:3:20 MINLEN:50
rm $f2/*-unpaired.fq.gz

java -jar trimmomatic-0.36.jar PE -phred33 $f1/sic3.r_1.fq.gz $f1/sic3.r_2.fq.gz $f2/sic3.r_1_trimo-paired.fq.gz $f2/sic3.r_1_trimo-unpaired.fq.gz $f2/sic3.r_2_trimo-paired.fq.gz $f2/sic3.r_2_trimo-unpaired.fq.gz ILLUMINACLIP:/servers/bio-shares-2/franklin-bioinf/tg369/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:3:20 MINLEN:50
rm $f2/*-unpaired.fq.gz

java -jar trimmomatic-0.36.jar PE -phred33 $f1/sic4.r_1.fq.gz $f1/sic4.r_2.fq.gz $f2/sic4.r_1_trimo-paired.fq.gz $f2/sic4.r_1_trimo-unpaired.fq.gz $f2/sic4.r_2_trimo-paired.fq.gz $f2/sic4.r_2_trimo-unpaired.fq.gz ILLUMINACLIP:/servers/bio-shares-2/franklin-bioinf/tg369/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:3:20 MINLEN:50
rm $f2/*-unpaired.fq.gz


java -jar trimmomatic-0.36.jar PE -phred33 $f1/siR1.r_1.fq.gz $f1/siR1.r_2.fq.gz $f2/siR1.r_1_trimo-paired.fq.gz $f2/siR1.r_1_trimo-unpaired.fq.gz $f2/siR1.r_2_trimo-paired.fq.gz $f2/siR1.r_2_trimo-unpaired.fq.gz ILLUMINACLIP:/servers/bio-shares-2/franklin-bioinf/tg369/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:3:20 MINLEN:50
rm $f2/*-unpaired.fq.gz

java -jar trimmomatic-0.36.jar PE -phred33 $f1/siR2.r_1.fq.gz $f1/siR2.r_2.fq.gz $f2/siR2.r_1_trimo-paired.fq.gz $f2/siR2.r_1_trimo-unpaired.fq.gz $f2/siR2.r_2_trimo-paired.fq.gz $f2/siR2.r_2_trimo-unpaired.fq.gz ILLUMINACLIP:/servers/bio-shares-2/franklin-bioinf/tg369/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:3:20 MINLEN:50
rm $f2/*-unpaired.fq.gz

java -jar trimmomatic-0.36.jar PE -phred33 $f1/siR3.r_1.fq.gz $f1/siR3.r_2.fq.gz $f2/siR3.r_1_trimo-paired.fq.gz $f2/siR3.r_1_trimo-unpaired.fq.gz $f2/siR3.r_2_trimo-paired.fq.gz $f2/siR3.r_2_trimo-unpaired.fq.gz ILLUMINACLIP:/servers/bio-shares-2/franklin-bioinf/tg369/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:3:20 MINLEN:50
rm $f2/*-unpaired.fq.gz
