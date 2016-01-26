#--------------------
# Analyzes whether an the values of images that were both shown and identified 
# (from now on referred to as Hits) were correctly or incorrectly remembred
# Analysis breakdown by values: 0 cents, 20 cents, 40 cents, 60 cents, 80 cents, 100 cents. .
# Note: If Ps did not miss a card, Hits + Misses = 10, F.Alarms + C.Rejections = 5
# 
# Author: Luis Sanchez (9/30/15)
#-------------------


#### Count of Values remembered correctly/incorrectly & breakdown by 20cent incremements ####
playerData <- playerData %>%
  mutate(rememberValue=0, wrongValue=0,
         rememberValue0=NA,rememberValue20=NA,rememberValue40=NA,
         rememberValue60=NA,rememberValue80=NA,rememberValue100=NA,
         wrongValue0=NA,wrongValue20=NA,wrongValue40=NA,
         wrongValue60=NA,wrongValue80=NA,wrongValue100=NA)

for (rowIndex in 1:totalParticipants) #iterates through all the participants
{
  for (colIndex in cardBegin:cardEnd) #iterates through the 15 images presented per player
  { 
    if (memoryTrials[rowIndex,grepl(paste("V",colIndex,"$",sep=""),names(memoryTrials))] < 11) #subsets cards shown to participant
    {
      #isolates $$ value for card presented, stores it in "dollarValue"
      dollarValue <- cardSchemes %>% 
        filter(participant == rowIndex+error,
               imageID==playerData[rowIndex,grepl(paste("c",colIndex,"$",sep=""),names(playerData))]) %>% 
        dplyr::select(cardValue) 
      #This corrects an error for participants who received the "Too Slow" message. 
      if(nrow(dollarValue)==0){dollarValue <- -999}  
      
      #Collects the $$ value the participant guesses
      playerResponse <- playerData[rowIndex,grepl(paste("Value",colIndex,"_4_TEXT",sep=""),names(playerData))]
      
      #Corrects NAs to a zero if the card was counted as a Hit. 
      if(playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] == 1)
      {
        valueIndex <- dollarValue*100
        if((is.na(playerData[rowIndex,grepl(paste("rememberValue",valueIndex,"$",sep=""),names(playerData))]))){
          playerData[rowIndex,grepl(paste("rememberValue",valueIndex,"$",sep=""),names(playerData))] <- 0
        }
        if((is.na(playerData[rowIndex,grepl(paste("wrongValue",valueIndex,"$",sep=""),names(playerData))]))){
          playerData[rowIndex,grepl(paste("wrongValue",valueIndex,"$",sep=""),names(playerData))] <- 0
        }
      }
      
      #compares "dollarValue" against Ps guess & Counts how many values for the "Hits" were correctly remembered
      if (playerResponse==dollarValue) 
      { 
        inc(playerData[rowIndex,grepl(paste("rememberValue","$",sep=""),names(playerData))]) 
        mult100(dollarValue) #multiples dollar value by 100. Used to find column name
        inc(playerData[rowIndex,grepl(paste("rememberValue",dollarValue,"$",sep=""),names(playerData))])
      }
      else 
      { #Counts how many of values for the "Hits" were incorrectly remembered
        if (playerData[rowIndex,grepl(paste("Seen",colIndex,"$",sep=""),names(playerData))] == 1){
          inc(playerData[rowIndex,grepl(paste("wrongValue","$",sep=""),names(playerData))])
          mult100(dollarValue)
          inc(playerData[rowIndex,grepl(paste("wrongValue",dollarValue,"$",sep=""),names(playerData))])
        }
      }
    } 
  }  
}

