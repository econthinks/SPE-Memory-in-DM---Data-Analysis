#--------------------
# Creates a frequency breakdown by value of card presented. Should add up to ten.   
# 
# Author: Luis Sanchez (10/01/15)
#-------------------

#### Absolute count for Signal Detection (hits, misses, correct rejections, false alarms) ####
playerData <- playerData %>% 
  mutate(shown0 = 0, shown20 = 0, shown40 = 0, shown60 = 0, shown80 = 0, shown100 = 0, shownTooSlow = 0)

for (rowIndex in 1:totalParticipants) #iterates through all the participants
{
  for (colIndex in 1:15) #iterates through the 15 images presented per player
  { 
    if (memoryTrials[rowIndex,grepl(paste("V",colIndex,"$",sep=""),names(memoryTrials))] < 11) #filters for cards that were shown for analysis
    {
      dollarValue <- cardSchemes %>% #isolates $$ value for each card presented
        filter(participant == rowIndex+error,
               imageID==playerData[rowIndex,grepl(paste("c",colIndex,"$",sep=""),names(playerData))]) %>% 
        dplyr::select(cardValue) 
      
      #Corrects error for participants who received "Too Slow" message. Multiplies value by 100 if false.
      ifelse (nrow(dollarValue)==0, dollarValue <- "TooSlow", mult100(dollarValue))
      
      inc(playerData[rowIndex,grepl(paste("shown",dollarValue,"$",sep=""),names(playerData))])
      
    }
  }  
}


