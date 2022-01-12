#2. Analysing the Downloaded Mutation data

#To use these codes, first download the datasets using "Downloading_Bioconductor_And_Datasets_RNAseq_mutation_clinical" file


#ANALYSING MUTATION DATA
#Mutation data is stored in a variable named "maf" and can be accesed using "maf@data"
View(maf@data)

#selecting useful columns from the dataset
md<- maf@data%>% select(1,17,36)

#Finding the count of unique patients #559
length(unique(maf@data$Matched_Norm_Sample_Barcode))
#Finding the count of patients with a particular point mutation
str(md)
length(md[md$HGVSp=="p.Gly12Cys"]$Matched_Norm_Sample_Barcode)
#OR
nrow((as.data.frame(md[md$HGVSp=="p.Gly12Cys"]$Matched_Norm_Sample_Barcode)))

#Finding the count of each gene
View(as.data.frame(table(md$Hugo_Symbol)))

#Sorting the mutated Genes in descending order
Sorted_Gene_Counts<-as.data.frame(table(md$Hugo_Symbol)) %>% arrange(desc(Freq))

#Since submitter id is not available separately in Mutation dataset, we obtained it by Splitting Matched_Tumor_Sample_barcode column
#Added the extracted column to original mutation dataset with new column name(submitter_id) to ease the matching process with clinical data
#We need this to join mutation data with clinical data
library(tidyverse)
library(stringr)
md<-data.frame(md)
md$submitter_id<-data.frame(str_split_fixed(md$Matched_Norm_Sample_Barcode,"-10|-11",2))[,1]
md<-md[,-2]

#Putting the different point mutations of same patients in same row
md_aggregated_point_mutations<-aggregate(data=md[c("submitter_id","HGVSp")],HGVSp~.,FUN=paste,collapse=",")

#Putting the different gene mutations of same patients in same row
md_aggregated_gene_mutations<-aggregate(data=md[c("submitter_id","Hugo_Symbol")],Hugo_Symbol~.,FUN=paste,collapse=",")


#To get Count Table of each unique mutation
#Change the gene name as required
table(md[md$Hugo_Symbol=="RET"]$HGVSp)

#Filter the rows containing EGFR/KRAS/ALK genes only
View(md[md$Hugo_Symbol=="KRAS"]) #EGFR/KRAS/ALK

#If we want to convert and download the dataframe in CSV format

write.csv(df,"C:\\Users\\Pranay Mahajan\\Documents\\Elucidata\\Projects\\R Practice\\EGFR_mutations_GDC.csv",row.names=FALSE)



