#--------------------
# Prepares MemoryData from the Serial Position, Memory & Decision-Making experiment
# statistical analysis.
#
# Input (3 CSV files) - Found in the Raw Data folder
# - "choices_schemes_merged.csv": Qualtrics choice data incl. what card players picked,
#   schemes data indicating critical trials (posCond = 1 for primacy, posCond=10 for recency).
# - "order_memtest.csv": Has order of card presentation for memory test (block 19), whether 
#   player remembers seeing the card and its worth. Cards 1-10 were in block 19, but cards 
#   11-15 the player had not seen before.
# - "qualtricssurvey_memtest_output.csv": Qualtrics output (including the code for the cards 
#    presented, whether card was seen, and its value). Also demographics and other measures. 
# 
# Output (3 CSV files) - Found in the Output file (Descriptions are below). 
# - Qualtrics_cleanData.csv: A cleaned version of the participant qualtrics output
# - Block19MemorySchemes.csv: Subsets only Block 19 for all Ps. Summarizes data in two 
#   columns for analysis. 
#  
# Author: Luis Sanchez (9/21/15)
#-------------------

#cardSchemes_raw <- read.csv("Raw Data/choices_schemes_merged.csv",header = TRUE, 
#                            stringsAsFactors = F) #reads card schemes - needs to be cleaned
# This is the final choice file for 60 participants:
cardSchemes_raw <- read.csv("Raw Data/DataFinal_12-4-15_Old484910.csv",header = TRUE, 
                            stringsAsFactors = F) #reads card schemes - needs to be cleaned
memoryTrials <- read.csv("Raw Data/order_memtest.csv",header = TRUE,
                         stringsAsFactors = F) #read Qualtrics CSV output file
playerData_raw <- read.csv("Raw Data/Primacy_Survey_Final_12-4-15_Old484910in_AllOtherOldOnesRemoved.csv",header = TRUE, 
                           stringsAsFactors = F) #read Qualtrics CSV output - needs to be cleaned
# playerData_raw <- read.csv("Raw Data/qualtricssurvey_memtest_output.csv",header = TRUE, 
#                           stringsAsFactors = F) #read Qualtrics CSV output - needs to be cleaned

####################################
##### Qualtrics Pre-Processing #####
####################################

#removes extraneous Qualtrics output & eliminates extra first line
playerData <- playerData_raw %>% 
  select(participant, matches("c\\d+$"), matches("Seen\\d+$"), matches("Value"))
playerData <- playerData[-1,] 
playerData <- mutate_each(playerData, funs(as.numeric)) %>% 
  filter(participant >= firstParticipant, participant <= lastParticipant) #Gets rid of players not analyzed

playerData <- arrange(playerData, -desc(participant))

playerData[is.na(playerData)] <- -99999 #replaces NAs with -99999 (for the $$ values)

Qualtrics_cleanData_unordered <- playerData

write.table(Qualtrics_cleanData_unordered, "Output/Qualtrics_cleanData.csv",
            row.names=FALSE, col.names=TRUE, sep=',')

####################################
#### Card Scheme Pre-Processing ####
####################################

#Eliminates extraneous columns/rows/players and codes choice (A=0, B=1)
cardSchemes <- cardSchemes_raw %>% 
  mutate(choice = ifelse(choice == "A",0,1)) 

cardSchemes <- mutate_each(cardSchemes, funs(as.numeric)) %>% 
  filter(participant >= firstParticipant, participant <= lastParticipant) #Gets rid of players not analyzed

# cardSchemes <- cardSchemes %>% #ImageID = ID for card picked; cardValue = value of card picked  
#   select(block, trial, participant, objA, objB, payA, payB, choice) %>% 
#   filter(block == 19) %>%
#   mutate(imageID = ifelse(choice==0,objA.x,objB.x), cardValue = ifelse(choice==0,payA.x,payB.x))

cardSchemes <- cardSchemes %>% #ImageID = ID for card picked; cardValue = value of card picked  
  select(block, trial, participant, objA, objB, payA, payB, choice) %>% 
  filter(block == 19) %>%
  mutate(imageID = ifelse(choice==0,objA,objB), cardValue = ifelse(choice==0,payA,payB))


cardSchemes <- na.omit(cardSchemes) #Eliminates NAs created by "Too Slow" message

write.table(cardSchemes, "Output/Block19MemorySchemes.csv",
            row.names=FALSE, col.names=TRUE, sep=',')

####################################
### Memory Trials Pre-Processing ###
####################################

memoryTrials <- mutate_each(memoryTrials, funs(as.numeric)) %>% 
  filter(participant >= firstParticipant, participant <= lastParticipant) #Gets rid of players not analyzed
