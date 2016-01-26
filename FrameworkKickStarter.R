##############################################################################################
# Main script for analysis of Memory Data from the Serial Position, Memory & Decision-Making 
# experiment.
# 
# Outputs a CSV file, FinalOutput_MemoryDataAnalysis.csv, with the results of the analysis
# 
# Note:If your working directory is not the one listed below, then uncomment the two following
# lines and run it with your own directory. Make sure the raw data is in the Raw Data folder
# and that the other scripts are in the Scripts folder
##############################################################################################

WD <- "C:/Users/CU Lou/Dropbox/Research/CRED/Memory, Learning and Decision Making/MemoryData_Analysis/"
setwd(WD)
# WD <- "C:/Users/Claudia/Dropbox/Memory & DM/MemoryData_Analysis/"
# setwd(WD) 

library(dplyr)

#If you wish to analyze a subset of participants, change the parameters below. 
#firstParticipant <- 3
#lastParticipant <- 22

firstParticipant <- 1
lastParticipant <- 60

#DO NOT MODIFY THESE PARAMETERS!!!
totalParticipants <- lastParticipant - firstParticipant + 1 
error <- firstParticipant - 1 #Used to convert row number to participant number during For Loop

#Make sure these functions are properly loaded since these are essential for the script
#inc <- function(x){ifelse(is.na(x),eval.parent(substitute(x <- 1)),eval.parent(substitute(x <- x + 1)))}
inc <- function(x) {eval.parent(substitute(x <- x + 1))}
mult100 <- function(x) {eval.parent(substitute(x <- x*100))}

#To analyze a subset of cards change the parameters below. Default: cardBegin<-1 & cardEnd<-15
cardBegin <- 1
cardEnd <- 15 

#Scripts
source("Scripts/Cleanup&PreProcessing.R") 
source("Scripts/CardsShown.R")
source("Scripts/Analysis_ImageSignalDetection.R")
source("Scripts/Analysis_ValueSignalDetection.R")
source("Scripts/Summary&Percentages.R")

#Exports Final output/analysis for each participant w/o extra columns
write.table(finalExport, "Output/FinalOutput_MemoryDataAnalysis.csv",
            row.names=FALSE, col.names=TRUE, sep=',')

#Run the code below to order participant data based on how it was presented
source("Scripts/DecryptingParticipantResponses.R") 
write.table(ordered_finalExport, "Output/Ordered_FinalOutput_MemoryDataAnalysis.csv",
            row.names=FALSE, col.names=TRUE, sep=',')

