#Survival analysis between Heavy and light smokers with KRAS (any) mutation
#Preriquisites: 1. Downloading Datasets using Downloading_Bioconductor_And_Datasets_RNAseq_mutation_clinical 
               #2. classifying patients using "combining_and_classifying_patients_based_on_smoking" file

#We need to get essential columns from mutation data-column on which classification is made
#(Here Type_of_smoker) and clinical data- i.e vital_status, days_to_death and
#days_to_last_follow_up in the dataframe we are adding to survival plot fxn
#(here smoking_df)
#All the above steps have been performed in "combining_and_classifying_patients_based_on_smoking" file

#Filtering rows with gene on which the survival curve has tobe plotted #Here KRAS
smoking_df_gene<-smoking_df[smoking_df$Hugo_Symbol=="KRAS"] #Can be EGFR/RET/etc


#Survival plot between Heavy and light smokers with KRAS mutation
#To change the mutation, change it above
library(TCGAbiolinks)
TCGAanalyze_survival(smoking_df_gene,
                     "Type_of_Smoker",
                     main = "Survival Analysis of KRAS mutated patients",
                     height = 10, width=10)

