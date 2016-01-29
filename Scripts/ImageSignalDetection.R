#--------------------
# Analyzes whether an image was correctly or incorrectly identified as seen/unseen
# Analysis breakdown by Hits, False Alarms, Misses, and Correct Rejections.
# Note: If Ps did not miss a card, Hits + Misses = 10, F.Alarms + C.Rejections = 5
# 
# Author: Luis Sanchez (01/28/16)
#-------------------

# Create columns to count hits/misses/correct rejections/false alarms (broken down by $$ value in cents)
analysisDf <- mutate(analysisDf, hits=0, misses=0,false_alarms=0,correct_rejections=0)
analysisDf <- mutate(analysisDf, hits0=NA,hits20=NA,hits40=NA,hits60=NA,hits80=NA,hits100=NA)
analysisDf <- mutate(analysisDf, misses0=NA,misses20=NA,misses40=NA,misses60=NA,misses80=NA,misses100=NA)


for (rowIndex in 1:totalParticipants) #iterates through all the participants
{
  for (colIndex in 1:15) #iterates through the 15 images presented per player
  { 
    PID <- playerData_ordered[rowIndex,1] #Stores the participant ID#
    cardID <- playerData_ordered[rowIndex,grepl(paste("c",colIndex,"$",sep=""),names(playerData_ordered))] #stores unique card ID
    
    #contains the column for Signal Detection Code. Correct is 1 & Incorrect is 0. 
    signalCol <- grepl(paste("Seen",colIndex,"$",sep=""),names(playerData_ordered)) 
    
    if (colIndex > 10) #iterates through the cards NOT SHOWN to the participants
    {
      #Evaluates whether player remembers unseen cards as False Alarms & Correct Rejections
      ifelse(playerData_ordered[rowIndex,signalCol] == 1, 
             inc(analysisDf[rowIndex,grepl("correct_rejections",names(analysisDf))]),
             inc(analysisDf[rowIndex,grepl("false_alarm",names(analysisDf))]))
    }
    else #iterates through the cards SHOWN to the participants
    {
      #isolates $$ value for each card presented
      dollarValue <- filter(cardSchemes, participant == PID, imageID == cardID) %>% dplyr::select(cardValue)  
      valueIndex <- dollarValue*100
      
      #Stores the location of the Hits## column and Misses## column. 
      hitsDollarCol <- grepl(paste("hits",valueIndex,"$",sep=""),names(analysisDf))
      missDollarCol <- grepl(paste("misses",valueIndex,"$",sep=""),names(analysisDf))
      
      #Corrects NAs of the Misses## column & Hits## column to zero if the card was ever SHOWN to participant 
      if((nrow(dollarValue) == 1) && (is.na(analysisDf[rowIndex,hitsDollarCol])))
      {
        
        if((is.na(analysisDf[rowIndex,hitsDollarCol]))){analysisDf[rowIndex,hitsDollarCol] <- 0}
        if((is.na(analysisDf[rowIndex,missDollarCol]))){analysisDf[rowIndex,missDollarCol] <- 0}
      }
      
      #Evaluates & counts the hits (also breaks them down by value). 
      if((playerData_ordered[rowIndex,signalCol] == 1) && (nrow(dollarValue) == 1))
      {
        inc(analysisDf[rowIndex,grepl("hits$",names(analysisDf))])
        inc(analysisDf[rowIndex,hitsDollarCol])
      }
      
      #Evaluates & counts the misses (also breaks them down by value).
      if((playerData_ordered[rowIndex,signalCol] == 0) && (nrow(dollarValue) == 1))
      {
        inc(analysisDf[rowIndex,grepl("misses$",names(analysisDf))])
        inc(analysisDf[rowIndex,missDollarCol])
      }
    }  
  }  
}
