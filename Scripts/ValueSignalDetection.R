#--------------------
# Analyzes whether the values of images that were both SHOWN and identified 
# (from now on referred to as Hits) were correctly or incorrectly remembred.
# Analysis breakdown by values: 0 cents, 20 cents, 40 cents, 60 cents, 80 cents, 100 cents. .
# Note: If Ps did not miss a card, Hits + Misses = 10, F.Alarms + C.Rejections = 5
# 
# Author: Luis Sanchez (01/28/16)
#-------------------


# Create columns to count cards correctly & incorrectly remembered (broken down by $$ value in cents)
analysisDf <- mutate(analysisDf, rememberValue=0, rememberValue0=NA, rememberValue20=NA, rememberValue40=NA, rememberValue60=NA, rememberValue80=NA, rememberValue100=NA)
analysisDf <- mutate(analysisDf, wrongValue=0, wrongValue0=NA, wrongValue20=NA, wrongValue40=NA, wrongValue60=NA,wrongValue80=NA,wrongValue100=NA)

for (rowIndex in 1:totalParticipants) #iterates through all the participants
{
  for (colIndex in 1:10) #iterates through the cards SHOWN to the participant
  { 
    PID <- playerData_ordered[rowIndex,1] #Stores the participant ID#
    cardID <- playerData_ordered[rowIndex,grepl(paste("c",colIndex,"$",sep=""),names(playerData_ordered))] #stores unique card ID
    
    #isolates $$ value for each card presented
    dollarValue <- filter(cardSchemes, participant == PID, imageID == cardID) %>% dplyr::select(cardValue) 
    if(nrow(dollarValue)==0){dollarValue <- -999} #This corrects an error for participants who received the "Too Slow" message. 
    valueIndex <- dollarValue*100
    
    # The following variable store column indexes  
    valueCol <- grepl(paste("Value",colIndex,"$",sep=""),names(playerData_ordered)) #column w/ $$ Value stated by the participant 
    signalCol <- grepl(paste("Seen",colIndex,"$",sep=""),names(playerData_ordered)) 
    rememberValueNCol <- grepl(paste("rememberValue",valueIndex,"$",sep=""),names(analysisDf))
    wrongValueNCol <- grepl(paste("wrongValue",valueIndex,"$",sep=""),names(analysisDf))
    
    #Collects the $$ value the participant guesses
    playerResponse <- playerData_ordered[rowIndex,valueCol]
    
    #Corrects NAs to a zero if the card was counted as a Hit. 
    if(playerData_ordered[rowIndex,signalCol] == 1)
    {
      if((is.na(analysisDf[rowIndex,rememberValueNCol]))) {analysisDf[rowIndex,rememberValueNCol] <- 0}
      if((is.na(analysisDf[rowIndex,wrongValueNCol]))) {analysisDf[rowIndex,wrongValueNCol] <- 0}
    }

    #compares "dollarValue" against Ps guess & Counts how many values for the "Hits" were correctly remembered
    if (playerResponse==dollarValue) 
    { 
      inc(analysisDf[rowIndex,grepl(paste("rememberValue","$",sep=""),names(analysisDf))]) 
      inc(analysisDf[rowIndex,rememberValueNCol])
    }
    else #if the participant gave the wrong $$ value, it marks them wrongValue
    { 
      if ((playerData_ordered[rowIndex,signalCol] == 1) && (dollarValue >= 0)) #Participants must have said it was a HIT before counting it as incorrectly remembered
      {
        inc(analysisDf[rowIndex,grepl(paste("wrongValue","$",sep=""),names(analysisDf))])
        inc(analysisDf[rowIndex,wrongValueNCol])
      }
    }
  }  
}

