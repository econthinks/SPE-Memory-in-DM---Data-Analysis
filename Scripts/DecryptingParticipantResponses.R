#--------------------
# Analyzes the Qualtrics participant responses and reorganizes it based on the memoryTrials order.
# 
# Author: Luis Sanchez (9/26/15)
#-------------------


# #Only un-comment if it is going to be run as a standalone file
# 
# library(dplyr)
# 
# #This will override FrameworkKickstarter parameters. 
# firstParticipant <- 1
# lastParticipant <- 60
# 

source("Scripts/Cleanup&PreProcessing.R")

#Creates Dataframe where new ordered data will be stores 
playerData_ordered <- playerData

for (rowIndex in 1:nrow(playerData)) #iterates through all Ps in the Qualtrics unordered (but clean)output
{
  for (colIndex in 1:15) #iterates through the 15 images presented per player
  { 
    # stores the real/true position (index number) of the ordered variables
    position <- memoryTrials[rowIndex,grepl(paste("V",colIndex,"$",sep=""),names(memoryTrials))]
    
    # Stores the positions for the ordered variables
    newSeenIndex <- grepl(paste("Seen",position,"$",sep=""),names(playerData_ordered))
    newCardNumIndex <- grepl(paste("c",position,"$",sep=""),names(playerData_ordered))
    newDollarValueIndex <- grepl(paste("Value",position,"_4_TEXT",sep=""),names(playerData_ordered))
    
    # Stores the positions for the original/messy position of all variables
    oldSeenIndex <- grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))
    oldCardNumIndex <- grepl(paste("c",colIndex,"$",sep=""),names(playerData))
    oldDollarValueIndex <- grepl(paste("Value",colIndex,"_4_TEXT",sep=""),names(playerData))
    
    # Transposes and sorts the values from the original PlayerData to PlayerData_ordered
    playerData_ordered[rowIndex,newCardNumIndex] <- playerData[rowIndex,oldCardNumIndex] 
    playerData_ordered[rowIndex,newSeenIndex] <- playerData[rowIndex,oldSeenIndex] 
    playerData_ordered[rowIndex,newDollarValueIndex] <- playerData[rowIndex,oldDollarValueIndex] 
  }  
}

# Print out standalone (not coded) ordered Qualtrics output. Sans coding. 
Qualtrics_cleanData_ordered <- playerData_ordered
write.table(Qualtrics_cleanData_ordered, "Output/Ordered_Qualtrics_cleanData.csv",
            row.names=FALSE, col.names=TRUE, sep=',')


#---------------- Sorting Coded data -------------
#Creates Dataframe where new ordered data will be stores 
playerData <- codedQualtrics_cleanData_unordered
playerData_ordered <- codedQualtrics_cleanData_unordered

for (rowIndex in 1:nrow(playerData)) #iterates through all Ps in the Qualtrics unordered (but clean)output
{
  for (colIndex in 1:15) #iterates through the 15 images presented per player
  { 
    # stores the real/true position (index number) of the ordered variables
    position <- memoryTrials[rowIndex,grepl(paste("V",colIndex,"$",sep=""),names(memoryTrials))]
    
    # Stores the positions for the ordered variables
    newSeenIndex <- grepl(paste("Seen",position,"$",sep=""),names(playerData_ordered))
    newCardNumIndex <- grepl(paste("c",position,"$",sep=""),names(playerData_ordered))
    newDollarValueIndex <- grepl(paste("Value",position,"_4_TEXT",sep=""),names(playerData_ordered))
    
    # Stores the positions for the original/messy position of all variables
    oldSeenIndex <- grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))
    oldCardNumIndex <- grepl(paste("c",colIndex,"$",sep=""),names(playerData))
    oldDollarValueIndex <- grepl(paste("Value",colIndex,"_4_TEXT",sep=""),names(playerData))
    
    # Transposes and sorts the values from the original PlayerData to PlayerData_ordered
    playerData_ordered[rowIndex,newCardNumIndex] <- playerData[rowIndex,oldCardNumIndex] 
    playerData_ordered[rowIndex,newSeenIndex] <- playerData[rowIndex,oldSeenIndex] 
    playerData_ordered[rowIndex,newDollarValueIndex] <- playerData[rowIndex,oldDollarValueIndex] 
  }  
}

codedQualtrics_cleanData_ordered <- playerData_ordered

ordered_finalExport <- dplyr::full_join(codedQualtrics_cleanData_ordered, participantSummaries, by = "participant")

