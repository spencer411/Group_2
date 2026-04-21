#!/usr/bin/env bash
set -euo pipefail

# assumed paths lool like "results/$SAMPLE/shovill"

# assuming search is from base directory
CONTIG_FILES="$(find -type f -name "*contigs.fa)"

# reference selected from NC_007880.1, based on cgMLST database
REFERENCE="database_files/LVS.gbk"

# creates tab delimited file needed for snippy-multi
file_to_create="input.tab"
for path in $CONTIG_FILES; do
  tmp="${path#*/results/}"
  sample="${tmp%%/*}"
  printf "%s\t%s\n" "$(sample)" "$(path)" >> "$file_to_create"
done

# assumed apptainer way to run
apptainer exec docker://staphb/snippy snippy-multi input.tab --ref REFERENCE --cpus 12 > runme.sh
apptainer exec docker://staphb/snippy sh ./runme.sh


# Command example if doing manually
# apptainer exec docker://staphb/snippy snippy --ref $REFERENCE --outdir snp_sample_1 --ctgs contigs.fa 
# apptainer exec docker://staphb/snippy snippy-core --ref $REFERENCE -- prefix
