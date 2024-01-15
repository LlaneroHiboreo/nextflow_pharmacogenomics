#!/bin/bash

nextflow run main.nf \
-c custom.config \
-profile singularity \
--outdir results \
--input assets/samplesheet.csv \
--fasta /path/to/reference.fasta \
--panel_files '/path/to/pypgx-bundle/1kgp/GRCh38/*.vcf.gz' \
--panel_indexes '/path/to/pypgx-bundle/1kgp/GRCh38/*.vcf.gz.tbi' \
--star_alleles_list CYP2A6,CYP2B6,CYP2D6,CYP2E1,CYP4F2,G6PD,GSTM1,SLC22A2,SULT1A1,UGT1A4,UGT2B15,UGT2B17 \
--no_star_alleles_list ABCB1,ABCG2,CACNA1S,CFTR,CYP1A1,CYP1A2,CYP1B1,CYP2A13,CYP2C8,CYP2C9,CYP2C19,CYP2F1,CYP2J2,CYP2R1,CYP2S1,CYP2W1,CYP3A4,CYP3A5,CYP3A7,CYP3A43,CYP4A11,CYP4A22,CYP4B1,CYP17A1,CYP19A1,CYP26A1,DPYD,F5,GSTP1,IFNL3,NAT1,NAT2,NUDT15,POR,PTGIS,RYR1,SLC15A2,SLCO1B1,SLCO1B3,SLCO2B1,TBXAS1,TPMT,UGT1A1,UGT2B7,VKORC1,XPC \
--cnv_caller_files '/path/to/PYPGX/pypgx-bundle/cnv/GRCh38/*.zip' \
-w work