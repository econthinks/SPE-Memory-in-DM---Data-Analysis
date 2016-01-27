#--------------------
# Prepares MemoryData from the Serial Position, Memory & Decision-Making experiment
# statistical analysis.
#  
# Author: Luis Sanchez (1/27/16)
#-------------------

####################################
##### Qualtrics Pre-Processing #####
####################################

# Removes extraneous output & eliminates first line
playerData <- select(playerData_raw, participant, matches("c\\d+$"), matches("Seen\\d+$"), matches("Value"))
playerData <- playerData[-1,] 

# Convert Dataframe to Numeric, sort by participant ID, & filter participants (optional)
playerData <- mutate_each(playerData, funs(as.numeric))
playerData <- arrange(playerData, -desc(participant))
playerData <- filter(playerData, participant >= firstParticipant, participant <= lastParticipant)

# Replaces NAs in the Value columns with -99999 (makes all the df numeric)
playerData[is.na(playerData)] <- -99999 

# Saves clean dataframe 
Qualtrics_cleanData <- playerData

####################################
#### Card Scheme Pre-Processing ####
####################################

# Codes choice (A=0, B=1) & makes the Df as numeric
cardSchemes <- mutate(cardSchemes_raw, choice = ifelse(choice == "A",0,1)) 
cardSchemes <- mutate_each(cardSchemes, funs(as.numeric))

# Eliminates extra players,filters Block 19 & filters out extra columns
cardSchemes <- filter(cardSchemes, participant >= firstParticipant, participant <= lastParticipant, block == 19)
cardSchemes <- select(cardSchemes, block, trial, participant, objA, objB, payA, payB, choice)

# Creates new column with card pick along with its value
# ImageID = ID for card picked; cardValue = value of card picked  
cardSchemes <- mutate(cardSchemes, imageID = ifelse(choice==0,objA,objB), cardValue = ifelse(choice==0,payA,payB))

# Saves the dataframe & Eliminates NAs created by "Too Slow" message
Block19MemorySchemes <- cardSchemes
cardSchemes <- na.omit(cardSchemes)

####################################
### Memory Trials Pre-Processing ###
####################################

# Converts Df to Numeric & Filters by Participant
memoryTrials <- mutate_each(memoryTrials, funs(as.numeric))
memoryTrials <- filter(memoryTrials, participant >= firstParticipant, participant <= lastParticipant)
