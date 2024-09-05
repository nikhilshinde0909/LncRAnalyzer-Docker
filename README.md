# LncRAnalyzer Docker Version
Pipeline for identification of lncRNAs and Novel Protein Coding Transcripts (NPCTs)

# Introduction
LncRAnalyzer can be used to identify lncRNAs and Novel Protein Coding Transcripts (NPCT) with large number of RNA-seq datasets, it contains genome guided assembly, merge annotattions, annotation compare, classcode selection and final retrival of transcripts in fasta format. The putative lncRNAs and NPCTs will be further tested for their coding potentials with CPC2,CPAT, PLEK (Time consuming), LGC, PfamScan, and RNAsamba. Based on coding potentials lncRNAs and NPCTs will be selected. Additionally, if someone have Lifover files for the organism and related species; conservation analysis will be also performed with slncky. We integreated FEELnc plugin to detect the mRNA spliced and intergenic lncRNAs in RNA-seq samples. For NPCTs one can go for TransDecoder followed by Pfamscan to retrive protein family annotations. Pipeline will be executed in conda environment.

<p align="center">
  <img src="https://github.com/nikhilshinde0909/LncRAnalyzer-Docker/blob/main/scripts/LncRAnalyzer.png" width=50% height=25%>
</p>


# Implementation
1. To execute the steps in pipeline, download latest release of LncRAnalyzer to your local system with following commamnd
```
git clone https://github.com/nikhilshinde0909/LncRAnalyzer-Docker.git
```

2. Rename and change directory
```
mv LncRAnalyzer-Docker LncRAnalyzer && cd LncRAnalyzer
```

3. Build docker image
```
docker build -t lncranalyzer .
```

4. Run Container with interactive shell this will enters in the docker shell 
```
docker run -it --rm -v /home/mpilab/LncRAnalyzer:/pipeline/LncRAnalyzer lncranalyzer
```

5. Once you enter to interactive shell, view your tools.groovy file using cat and copy content type exit then with nano edit tools.groovy file and paste paths
   for e.g.
```
root@17be1897ad94:/pipeline# cat tools.groovy 
root@17be1897ad94:/pipeline# exit
mpilab@mpilab-ThinkCentre-neo-50t-Gen-3:~$ nano tools.goory
```

6. Prepare your data and data.txt in working directory
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
└── data.txt
```

7. If you don't have reference genome, annotations and rRNA sequence information; you can download the same with script provided with pipeline as follows
```
python check_ensembl.py org_name
eg. python find_species_in_ensembl.py Sorghum
> sbicolor
python ensembl.py org_name_in_ensembl
eg. python download_datasets_ensembl.py sbicolor
> Ensembl version 56 <- download the datasets
```

8. Run the LncRNAlyzer using docker as follows
```
docker run --rm \
    -v /home/mpilab/LncRAnalyzer:/pipeline/LncRAnalyzer \
    -v $(pwd)/data:/pipeline/data \
    -v $(pwd)/data.txt:/pipeline/data.txt \
    lncranalyzer bpipe run -n 16 /pipeline/LncRAnalyzer/Main.groovy /pipeline/data.txt
```

## Thanks for using LncRAnalyzer docker version !!

## Peformace
The performance of coding potential prediction using CPAT, CPC2, RNAsamba, LGC and FEELnc was estimated with 50 RNA-Seq accessions of sorghum cultivar PR22 from past studies [https://doi.org/10.1186/s12864-019-5734-x] 

<p align="center">
  <img src="https://github.com/nikhilshinde0909/LncRAnalyzer-Docker/blob/main/scripts/ROC.png" width=70% height=70%>
</p>
