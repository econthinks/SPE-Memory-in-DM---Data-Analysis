#--------------------
# Analyzes whether an image was correctly or incorrectly identified as seen/unseen
# Analysis breakdown by Hits, False Alarms, Misses, and Correct Rejections.
# Note: If Ps did not miss a card, Hits + Misses = 10, F.Alarms + C.Rejections = 5
# 
# Author: Luis Sanchez (9/26/15)
#-------------------


#### Absolute count for Signal Detection (hits, misses, correct rejections, false alarms) ####
playerData <- playerData %>% mutate(hits=0, misses=0,false_alarms=0,correct_rejections=0)
playerData <- playerData %>% mutate(hits0=0,hits20=0,hits40=0,hits60=0,hits80=0,hits100=0)
playerData <- playerData %>% mutate(misses0=0,misses20=0,misses40=0,misses60=0,misses80=0,misses100=0)


for (rowIndex in 1:totalParticipants) #iterates through all the participants
{
  for (colIndex in cardBegin:cardEnd) #iterates through the 15 images presented per player
  { 
    if (memoryTrials[rowIndex,grepl(paste("V",colIndex,"$",sep=""),names(memoryTrials))] > 10) #subsets the dummy cards for analysis
    {
      #Recodes Not Seen = 0, Seen & IDK = 1. Uncertainty is lumped in the False Alarms (Type I error) 
      playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] <- ifelse(playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] == 2,0,1)
      
      #Evaluates whether player remembers unseen cards as False Alarms & Correct Rejections
      ifelse(playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] == 0, 
             inc(playerData[rowIndex,grepl("correct_rejections",names(playerData))]),
             inc(playerData[rowIndex,grepl("false_alarm",names(playerData))]))
    }
    else #subsets "real" cards that were shown to participant
    {
      #Recodes Seen = 1, Not Seen & IDK = 0. Uncertainty is lumped in the Misses (Type II errror)
      playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] <- ifelse(playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] == 1,1,0)
      
      #isolates $$ value for each card presented. Used to find column by values. 
      dollarValue <- cardSchemes %>% 
        filter(participant == rowIndex+error,
               imageID==playerData[rowIndex,grepl(paste("c",colIndex,"$",sep=""),names(playerData))]) %>% 
        dplyr::select(cardValue) 
      
      #Evaluates & counts the hits. Also breaks them down by value. 
      if((playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] == 1)&&
         (nrow(dollarValue) == 1))
      {
        inc(playerData[rowIndex,grepl("hits$",names(playerData))])
        
        #Multiples card value by 100 and finds the Hits category.
        mult100(dollarValue)
        inc(playerData[rowIndex,grepl(paste("hits",dollarValue,"$",sep=""),names(playerData))])
      }
      
      #Evaluates & counts the misses
      if((playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] == 0)&&
         (nrow(dollarValue) == 1))
      {
        inc(playerData[rowIndex,grepl("misses$",names(playerData))])
        
        #Multiples card value by 100 and finds the Misses category.
        mult100(dollarValue)
        inc(playerData[rowIndex,grepl(paste("misses",dollarValue,"$",sep=""),names(playerData))])
      }
    }  
  }  
}



