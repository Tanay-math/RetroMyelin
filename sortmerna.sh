#!/bin/bash
# set the number of nodes
#SBATCH -n 24
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

f1="/path/to/input/directory/where/files/after/trimmomatics/kept"
f2="/path/to/output/directory"
f3="/path/to/sortmerna-2.1"
f4="/path/to/keep/unzip/files"

for i in 1 2 3 4
do
echo "starting $i"
cp $f1/sic$i.r_*_trimo-paired.fq.gz $f4
gunzip $f4/sic$i.r_*_trimo-paired.fq.gz
cd $f3/scripts
./merge-paired-reads.sh $f4/sic$i.r_1_trimo-paired.fq $f4/sic$i.r_2_trimo-paired.fq $f2/sic$i-read-interleaved.fq
rm $f4/sic$i.r_*_trimo-paired.fq
cd $f3
time ./sortmerna --ref ./rRNA_databases/silva-euk-28s-id98.fasta,./index/silva-euk-28s:\./rRNA_databases/silva-euk-18s-id95.fasta,./silva-euk-18s:\./rRNA_databases/rfam-5.8s-database-id98.fasta,./index/rfam-5.8s:\./rRNA_databases/rfam-5s-database-id98.fasta,./index/rfam-5s --reads $f2/sic$i-read-interleaved.fq   --num_alignments 1 --sam --fastx --aligned accept --other other --log -a 8 -v --paired_in
rm $f2/sic$i-read-interleaved.fq
cp accept.log $f2
mv $f2/accept.log $f2/sic$i-accept.log
cd $f3/scripts
./unmerge-paired-reads.sh $f3/other.fq $f2/sic$i-r_1-trimmo-sortmerna.fq $f2/sic$i-r_2-trimmo-sortmerna.fq
echo "completed:sic$i"
cd $f2
done


for i in 1 2 3
do
echo "starting $i"
cp $f1/siR$i.r_*_trimo-paired.fq.gz $f4
gunzip $f4/siR$i.r_*_trimo-paired.fq.gz
cd $f3/scripts
./merge-paired-reads.sh $f4/siR$i.r_1_trimo-paired.fq $f4/siR$i.r_2_trimo-paired.fq $f2/siR$i-read-interleaved.fq
rm $f4/siR$i.r_*_trimo-paired.fq
cd $f3
time ./sortmerna --ref ./rRNA_databases/silva-euk-28s-id98.fasta,./index/silva-euk-28s:\./rRNA_databases/silva-euk-18s-id95.fasta,./silva-euk-18s:\./rRNA_databases/rfam-5.8s-database-id98.fasta,./index/rfam-5.8s:\./rRNA_databases/rfam-5s-database-id98.fasta,./index/rfam-5s --reads $f2/siR$i-read-interleaved.fq   --num_alignments 1 --sam --fastx --aligned accept --other other --log -a 8 -v --paired_in
rm $f2/siR$i-read-interleaved.fq
cp accept.log $f2
mv $f2/accept.log $f2/siR$i-accept.log
cd $f3/scripts
./unmerge-paired-reads.sh $f3/other.fq $f2/siR$i-r_1-trimmo-sortmerna.fq $f2/siR$i-r_2-trimmo-sortmerna.fq
echo "completed:siR$i"
cd $f2
done
