#Classifying patients as Heavy and Light smokers based on pack_year_smoked
# Prequisite: Must have loaded bioconductor packages and downloaded mutation and clinical datasets using codes given in "Downloading_Bioconductor_And_Datasets_RNAseq_mutation_clinical" file

library("tidyverse")
library(dplyr)

#Selecting Useful clinical data for survival analysis
clinical_new<-clinical[c(1,35,37,8,44)]
View(clinical_new)

#Extracting Useful Rows from selected Mutation Data
md<- maf@data%>% select(1,17,36)


#Since submitter id is not available separately in Mutation dataset,
#we obtained it by Splitting Matched_Tumor_Sample_barcode column and
#Added the extracted column to original mutation dataset with new column name(submitter_id) to ease the matching process with clinical data
#library(tidyverse)
library(stringr)
md$submitter_id<-data.frame(str_split_fixed(md$Matched_Norm_Sample_Barcode,"-10|-11",2))[,1]
md<-md[,-2]

#Putting the different mutations of same patients in same row
md_aggregated_point_mutations<-aggregate(data=md,HGVSp~.,FUN=paste,collapse=",")


#Joining Mutation and Clinical datasets
#library(dplyr)
joined_df<-data.frame(left_join(md_aggregated_point_mutations,clinical_new,by="submitter_id"))

#Dropping Rows with packed_years_smoked as NA
library(tidyr)
View(joined_df %>% drop_na(pack_years_smoked))
smoking_df<-joined_df %>% drop_na(pack_years_smoked)

#Classifying patients as Heavy and Light Smokers
#Threshold for pack_years_smoked=20
#Reference
#https://bmcpublichealth.biomedcentral.com/articles/10.1186/1471-2458-11-94

smoking_df[smoking_df$pack_years_smoked<=20.0,"Type_of_Smoker"]<-"Light Smoker"
smoking_df[smoking_df$pack_years_smoked>20.0,"Type_of_Smoker"]<-"Heavy Smoker"


table(smoking_df$Type_of_Smoker)

