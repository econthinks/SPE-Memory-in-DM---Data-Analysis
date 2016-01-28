#--------------------
# Creates an absolute frequency breakdown (by value of card) of the cards presented to the Participant. 
# If the participant missed the trial, it is marked as "ShownTooSlow".  
# 
# Author: Luis Sanchez (1/27/16)
#-------------------

#### Absolute count for Signal Detection (hits, misses, correct rejections, false alarms) ####
analysisDf <- select(playerData_ordered, participant)
analysisDf <- mutate(analysisDf, shown0 = 0, shown20 = 0, shown40 = 0, shown60 = 0, shown80 = 0, shown100 = 0, shownTooSlow = 0)

for (rowIndex in 1:totalParticipants) #iterates through all the participants
{
  for (colIndex in 1:10) #iterates through the cards shown to the participant
  { 
    PID <- playerData_ordered[rowIndex,1] #Stores the participant ID #
    cardID <- playerData_ordered[rowIndex,grepl(paste("c",colIndex,"$",sep=""),names(playerData_ordered))]
    
    #isolates $$ value for each card presented
    dollarValue <- filter(cardSchemes, participant == PID, imageID == cardID) %>% dplyr::select(cardValue) 
    
    # Corrects error for participants who received "Too Slow" message. Multiplies value by 100 if false.
    ifelse(nrow(dollarValue)==0, dollarValue <- "TooSlow", mult100(dollarValue))
    
    # Increments the "shown#" Count +1  
    inc(analysisDf[rowIndex,grepl(paste("shown",dollarValue,"$",sep=""),names(analysisDf))])
    
  } 
  # Adds up cards shown to participant. Therefore Shown+ShownTooSlow = 10. 
  analysisDf <- mutate(analysisDf, shown = shown0+shown20+shown40+shown60+shown80+shown100)
}
