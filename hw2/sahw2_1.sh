#! /bin/sh
ls -A -R -l | awk '{if(NF>=9){printf("%s\n",$0)}}' | sort -k 5,5 -nr | awk 'BEGIN {i=0;n_dir=0;n_file=0;n_size=0;} {if($1~/^-.*/) {n_file++;n_size+=$5; if(i<5){printf("%d:%s %s\n",i+1,$5,$9);i++}} if($1~/^d.*/){n_dir++;}} END {printf("Dir num: %d\n",n_dir);printf("File num: %d\n",n_file);printf("Total: %d\n",n_size);}'
