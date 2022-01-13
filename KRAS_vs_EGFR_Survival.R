#combined EGFR AND KRAS ANALYSIS
#Preriquisite: Mutation and clinical Data should have been downloaded

#mutation data is downloaded in "maf" and clinical data in "clinical" variables respectively

#To Select rows with EGFR and KRAS mutation from the Mutation data
View(maf@data[maf@data$Hugo_Symbol=="KRAS"|maf@data$Hugo_Symbol=="EGFR"])

#To select useful columns
View(maf@data[maf@data$Hugo_Symbol=="KRAS"|maf@data$Hugo_Symbol=="EGFR"][,c(1,16,37)])

#found length of unique patients to see presence of duplicates
#148 out of 162 patients are unique means 12 samples are duplicated
#Need to verify whether any KRAS and EGFR mutation overlaps in any patient


temp<-maf@data[maf@data$Hugo_Symbol=="KRAS"|maf@data$Hugo_Symbol=="EGFR"][,c(1,16)]
View(aggregate(data=temp,Hugo_Symbol~.,FUN=paste,collapse=","))
#It could be seen that No patients' sample have both EGFR and KRAS mutation in common


#Selecting clinical data useful for survival analysis
View(clinical)
clinical_new<-clinical[c(1,37,8,44)]

#To Select rows with EGFR and KRAS mutation from the Mutation data and patient and gene columns
View(maf@data[maf@data$Hugo_Symbol=="KRAS"|maf@data$Hugo_Symbol=="EGFR"])
md_KRAS_EGFR<-maf@data[maf@data$Hugo_Symbol=="KRAS"|maf@data$Hugo_Symbol=="EGFR"][,c(1,17)]


#Since submitter id is not available separately in Mutation dataset, we obtained it by Splitting Matched_Tumor_Sample_barcode column 
#Added the extracted column to original mutation dataset with new column name(submitter_id) to ease the matching process with clinical data
library(tidyverse)
library(stringr)
md_KRAS_EGFR$submitter_id<-data.frame(str_split_fixed(md_KRAS_EGFR$Matched_Norm_Sample_Barcode,"-10|-11",2))[,1]
md_KRAS_EGFR<-md_KRAS_EGFR[,-2]


#Joining Mutation and Clinical datasets & removing NA from vital status
library(dplyr)
data.frame(left_join(md_KRAS_EGFR,clinical_new,by="submitter_id"))

joined_EGFR_KRAS<-data.frame(left_join(md_KRAS_EGFR,clinical_new,by="submitter_id"))%>% drop_na(vital_status)
table(joined_EGFR_KRAS$Hugo_Symbol)

#Plotting Survival Curve
library(TCGAbiolinks)
TCGAanalyze_survival(joined_EGFR_KRAS,
                     "Hugo_Symbol",
                     main = "Survival Analysis of KRAS and EGFR mutated patients",
                     height = 10, width=10)
