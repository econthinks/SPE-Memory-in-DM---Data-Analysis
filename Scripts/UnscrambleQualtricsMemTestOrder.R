#--------------------
# Reorganizes Qualtrics Memory Test based on the memoryTrials order. 
# First 10 cards were actually presented to participants. Cards 10-15 were not. 
# 
# Author: Luis Sanchez (1/27/16)
#-------------------

#Creates Dataframe where new ordered data will be stores 
playerData_ordered <- Qualtrics_cleanData

for (rowIndex in 1:nrow(playerData)) #iterates through all Ps in the Qualtrics clean & unordered output
{
  for (colIndex in 1:15) #iterates through the 15 images presented per player
  { 
    # stores the real/uncrambled position (index number) of the ordered variables from the Memory Trials CSV
    columnName <- grepl(paste("V",colIndex,"$",sep=""),names(memoryTrials))
    position <- memoryTrials[rowIndex,columnName]
    
    # Stores the positions for the ordered variables
    newSeenIndex <- grepl(paste("Seen",position,"$",sep=""),names(Qualtrics_cleanData))
    newCardNumIndex <- grepl(paste("c",position,"$",sep=""),names(Qualtrics_cleanData))
    newDollarValueIndex <- grepl(paste("Value",position,"$",sep=""),names(Qualtrics_cleanData))
    
    # Stores the positions for the original/messy position of all variables
    oldSeenIndex <- grepl(paste("Seen",colIndex,"$",sep=""),names(Qualtrics_cleanData))
    oldCardNumIndex <- grepl(paste("c",colIndex,"$",sep=""),names(Qualtrics_cleanData))
    oldDollarValueIndex <- grepl(paste("Value",colIndex,"$",sep=""),names(Qualtrics_cleanData))
    
    # Transposes and sorts the values from the original PlayerData to PlayerData_ordered
    playerData_ordered[rowIndex,newCardNumIndex] <- Qualtrics_cleanData[rowIndex,oldCardNumIndex] 
    playerData_ordered[rowIndex,newSeenIndex] <- Qualtrics_cleanData[rowIndex,oldSeenIndex] 
    playerData_ordered[rowIndex,newDollarValueIndex] <- Qualtrics_cleanData[rowIndex,oldDollarValueIndex] 
  }  
}

# Save a copy of the Qualtrics Ordered Memory Test Data (not coded). 
Qualtrics_cleanData_ordered <- playerData_ordered