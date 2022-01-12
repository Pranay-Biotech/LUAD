#3. Analysing the Downloaded Clinical data

#To use these codes, first download the data using "Downloading_Bioconductor_And_Datasets_RNAseq_mutation_clinical" file


#To download clinical data
#library(TCGAbiolinks)
#clinical <- GDCquery_clinic(project = "TCGA-LUAD", type = "clinical")

#Clinical data is stored in variable "clinical
View(clinical)

#Selecting Useful Columns for survival analysis #submitter_id, Vital status, days_to_last_follow_up, days_to_death
clinical_new<-clinical[c(1,37,8,44)] #for pack_year_smoked add col no. 35 to the list
View(clinical_new)

#Can analyse the patients based on gender,race, vital_status,etc by applying conditions on "clinical" dataset
table(clinical$gender) #race/vital_status/other

#To find no. of NA in any column
sum(is.na(clinical$vital_status))



