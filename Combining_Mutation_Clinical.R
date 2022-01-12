#4. Combining processed clinical and mutation data
#After downloading the data mutation data data and storing it in "maf" variable
#And clinical data in "clinical" variable, useful data is stored in "clinical new variable


md<- maf@data[,c(1,17)]
library(tidyverse)
library(stringr)
md<-data.frame(md)
md$submitter_id<-data.frame(str_split_fixed(md$Matched_Norm_Sample_Barcode,"-10|-11",2))[,1]
md<-md[,-2]

#Joining Mutation and Clinical datasets
library(dplyr)
joined_df<-data.frame(left_join(md,clinical_new,by="submitter_id"))


