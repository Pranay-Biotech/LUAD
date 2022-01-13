# Mutation load & Types of mutation mutation per sample
#Mutation Dataset has tobe downloaded before using these codes
#mutation data is stored in variable "md"

md<- maf@data[,c(1,17)]
library(tidyverse)
library(stringr)
md<-data.frame(md)
md$submitter_id<-data.frame(str_split_fixed(md$Matched_Norm_Sample_Barcode,"-10|-11",2))[,1]
md<-md[,-2]

mutation_per_sample<-aggregate(data=md,Hugo_Symbol~.,FUN=paste,collapse=",")

mutation_load<-as.data.frame(table(md$submitter_id))%>% `colnames<-`(c("submitter_id","mutation_load"))

#Adding count of mutation per sample to mutation_per_sample dataframe
library(dplyr)
mutation_per_sample<-data.frame(left_join(mutation_per_sample,mutation_load,by="submitter_id"))

#To find out what other mutations are present along with EGFR/KRAS 
#We will search the keyword in mutation_per_sample dataframe
library(data.table)
mutation_per_sample_EGFR<-mutation_per_sample[mutation_per_sample$Hugo_Symbol %like% "EGFR", ]%>% arrange(desc(mutation_load))
mutation_per_sample_KRAS<-mutation_per_sample[mutation_per_sample$Hugo_Symbol %like% "KRAS", ]%>% arrange(desc(mutation_load))
top_mutated_EGFR<-mutation_per_sample_EGFR%>%top_n(10)
top_mutated_KRAS<-mutation_per_sample_KRAS%>%top_n(10)
#Plotting bar graph
mutation_per_sample_EGFR<-as.data.frame(mutation_per_sample_EGFR)
#barplot(mutation_load ~ submitter_id,data=mutation_per_sample_EGFR )
#barplot(mutation_load ~ submitter_id,data=mutation_per_sample_KRAS )

library(ggplot2)
ggplot(top_mutated_EGFR,aes(x=submitter_id,y=mutation_load))+
  geom_bar(stat="identity")

ggplot(top_mutated_KRAS,aes(x=submitter_id,y=mutation_load))+
  geom_bar(stat="identity")


