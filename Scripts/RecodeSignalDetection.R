#--------------------
# Recodes the cards presented as either Success (1) or Failure (0)
# 
# For cards 1-10 (actually shown to Ps):  
# - Seen (1) is coded as Sucess (1)
# - Not Seen (2) and IDK (3) are coded as Failure (0)
# 
# For cards 11-15 (not shown to Ps):  
# - Not Seen (2) is coded as Success (1)
# - Seen (1) and IDK (3) is coded as Failure (0)
# 
# Author: Luis Sanchez (1/27/16)
#-------------------

#------------------------- Recoding Scrambled Data -------------------------

for (rowIndex in 1:totalParticipants) #iterates through all the participants
{
  for (colIndex in 1:15) #iterates through the 15 images presented per player
  { 
    # Stores column index for MemoryTrials (MT)
    MTposition <- grepl(paste("V",colIndex,"$",sep=""),names(memoryTrials))
    
    # Stores column index of "Value#" column in PlayerData (PD) & PlayerDataOrdered
    PDposition <- grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))
    
    
    ########################## Recoding Scrambled Data #########################
    
    if (memoryTrials[rowIndex,MTposition] > 10) # Evaluates card that were NOT SHOWN to participant
    {
      #Recodes Not Seen = 1, Seen & IDK = 0. Uncertainty is lumped in the False Alarms (Type I error) 
      playerData[rowIndex,PDposition] <- ifelse(playerData[rowIndex,PDposition] == 2,1,0)
    }
    
    else # Evaluates card that were SHOWN to participant
    {
      #Recodes Seen = 1, Not Seen & IDK = 0. Uncertainty is lumped in the Misses (Type II errror)
      playerData[rowIndex,PDposition] <- ifelse(playerData[rowIndex,PDposition] == 1,1,0)
    }  
    
    
    ########################## Recoding Ordered/Un-scrambled Data  #########################
    
    if (colIndex > 10) # Evaluates card that were NOT SHOWN to participant
    {
      #Recodes Not Seen = 1, Seen & IDK = 0. Uncertainty is lumped in the False Alarms (Type I error) 
      playerData_ordered[rowIndex,PDposition] <- ifelse(playerData_ordered[rowIndex,PDposition] == 2,1,0)
    }
    
    else # Evaluates card that were SHOWN to participant
    {
      #Recodes Seen = 1, Not Seen & IDK = 0. Uncertainty is lumped in the Misses (Type II errror)
      playerData_ordered[rowIndex,PDposition] <- ifelse(playerData_ordered[rowIndex,PDposition] == 1,1,0)
    }  
  }  
}
