# LncRAnalyzer Docker Version
Pipeline for identification of lncRNAs and Novel Protein Coding Transcripts (NPCTs)

# Introduction
LncRAnalyzer can be used to identify lncRNAs and Novel Protein Coding Transcripts (NPCT) with a large number of RNA-seq datasets, it contains genome-guided assembly, merge annotations, annotation compare, classcode selection, and final retrieval of transcripts in fasta format. The putative lncRNAs and NPCTs will be further tested for their coding potentials with CPC2, CPAT, PLEK (Time-consuming), LGC, PfamScan, and RNAsamba. Based on coding potentials lncRNAs and NPCTs will be selected. Additionally, if someone has Lifover files for the organism and related species; conservation analysis will be also performed with Slncky. We integrated the FEELnc plugin to detect the mRNA spliced and intergenic lncRNAs in RNA-seq samples. For NPCTs, one can go for TransDecoder followed by Pfamscan to retrieve protein family annotations. The pipeline will be executed in a conda environment.

<p align="center">
  <img src="https://github.com/nikhilshinde0909/LncRAnalyzer-Docker/blob/main/scripts/LncRAnalyzer.png" width=50% height=25%>
</p>


# Implementation
1. To execute the steps in the pipeline, download the latest release of LncRAnalyzer to your local system with the following command
```
git clone https://github.com/nikhilshinde0909/LncRAnalyzer-Docker.git
```

2. Rename and change directory
```
mv LncRAnalyzer-Docker LncRAnalyzer && cd LncRAnalyzer
```

3. Build a docker image from the docker file
```
docker build -t nikhilshinde0909/lncranalyzer .
```

4. Run the following commands and check LncRAnalyzer and tools.groovy has been created and configured with the proper paths 
```
docker run --rm -it nikhilshinde0909/lncranalyzer bash
cd LncRAnalyzer/
cat tools.groovy
exit
```

5. Prepare data and data.groovy in your working directory \
Working directory
```
├── data
│   ├── SRR975551_1.fastq.gz
│   ├── SRR975552_1.fastq.gz
│   └── (and other fastq.gz files)
│   ├── SRR975551_2.fastq.gz
│   ├── SRR975552_2.fastq.gz
│   └── (and other fastq.gz files)
│   └── hg38.rRNA.fasta
|   └── hg38.genome.fasta
|   └── hg38.annotation.gtf
|   └── (and other files)
└── data.groovy
```

6. If you don't have reference genome, annotations, and rRNA sequence information; you can download the same with the script provided with the pipeline as follows
```
python check_ensembl.py <org_name>
eg. python find_species_in_ensembl.py Sorghum
> sbicolor
python ensembl.py <org_name>
eg. python download_datasets_ensembl.py sbicolor
> Ensembl version 56 <- download the datasets
```
Similarly, if you don't have liftover files for conservation analysis then you can generate it through genome alignments of reference and query species genomes as follows
```
python Liftover.py <threads> <genome> <org_name> <genome_related_species> <rel_sp_name> <params_distance>
eg.
python Liftover.py 16 Sorghum_bicolor.dna.toplevel.fa Sbicolor Zea_mays.dna.toplevel.fa Zmays near
```
We also provide an additional script which will take ensembl gtf and produce bed files to run Slncky as follows
```
python ensembl_gtf2bed.py <ensembl_gtf> <output_prefix>
eg.
python ensembl_gtf2bed.py Sorghum_bicolor.58.gtf Sorghum_bicolor
```
This will produce protein-coding, non-coding, miRNA, and snoRNA bed files for Slncky. 

7. Run the LncRNAlyzer using docker in your working directory as follows
```
docker run \
    -v $(pwd)/data:/pipeline/data \
    -v $(pwd)/data.groovy:/pipeline/data.groovy \
    nikhilshinde0909/lncranalyzer bpipe run -n 16 /pipeline/LncRAnalyzer/Main.groovy /pipeline/data.groovy
```
8. Export your results to local as follows
```
# list containers
docker ps -a

# Copy data
docker cp container_id:/pipeline ${path to copy resuls}
```
## Thanks for using LncRAnalyzer docker version !!

## Peformace
The performance of coding potential prediction using CPAT, CPC2, RNAsamba, LGC and FEELnc was estimated with 50 RNA-Seq accessions of sorghum cultivar PR22 from past studies [https://doi.org/10.1186/s12864-019-5734-x] 

<p align="center">
  <img src="https://github.com/nikhilshinde0909/LncRAnalyzer-Docker/blob/main/scripts/ROC.png" width=70% height=70%>
</p>
