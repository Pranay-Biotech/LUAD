#Installing Bioconductor package and loading the packages useful to download and analyse Mutation, clinical and RNA-seq data

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = '3.12') #Check the recent version

library("BioCManager")
BiocManager::available() #To see abvailable packages in BioCManager
packageVersion("BiocManager")
BiocManager::install("GenomicFeatures") #To install any package out of displayed packages

library(TCGAbiolinks)

#To download gene Expression data
query.exp <- GDCquery(project = "TCGA-LUAD"
                      legacy = TRUE,
                      data.category = "Gene expression",
                      data.type = "Gene expression quantification",
                      platform = "Illumina HiSeq",
                      file.type = "results",
                      experimental.strategy = "RNA-Seq",
                      sample.type = c("Primary Tumor","Solid Tissue Normal"))




#To download Mutation data
query.maf.hg19 <- GDCquery(project = "TCGA-LUAD", 
                           data.category = "Simple nucleotide variation", 
                           data.type = "Simple somatic mutation",
                           access = "open", 
                           legacy = TRUE)

GDCdownload(query.maf.hg19)
maf <- GDCprepare(query.maf.hg19)


#OR can download in following way as well
library(TCGAbiolinks)
library(maftools)
library(dplyr)
maf <- GDCquery_Maf("LUAD", pipelines = "muse") %>% read.maf


#To download clinical data
library(TCGAbiolinks)
clinical <- GDCquery_clinic(project = "TCGA-LUAD", type = "clinical")

#To view data in datatable format #Optional
xfun::session_info('DT')
clinical %>%
  head %>% 
  DT::datatable(filter = 'top', 
                options = list(scrollX = TRUE, keys = TRUE, pageLength = 5),  
                rownames = FALSE)

