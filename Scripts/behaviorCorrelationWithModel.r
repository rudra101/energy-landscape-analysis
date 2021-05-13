# created this script for correlating behavioral scores (FIQ, ADOS/ADI) with different model metrics. 
library(tidyverse)
library(grid)
library(gridExtra) # for adding multiple plots in the same figure
library(broom)
library(hash)
# source the function file
source('~/Documents/Dissertation Docs & Papers/Scripts/project_functions.r')

## Section I - load the data files
# FIQ - no scale change needed.
asd_td_fiqs <- read.table('~/Documents/asd_td_fiqs_forR_empirical.csv', header=T, sep=",")
asd_td_fiqs$age <- factor(asd_td_fiqs$age, levels = c("child", "adolsc", "adult"))
# appear. frequency - scale change (i.e; multiply by 100 to get frequency) in defiance of Watanabe et. al. 2017.
asd_td_freq <- read.table('~/Documents/asd_td_freqs_forR_empirical.csv', header=T, sep=",")
asd_td_freq <- asd_td_freq %>% mutate(freq = freq *100) # turn into percentage
asd_td_freq$age <- factor(asd_td_freq$age, levels = c("child", "adolsc", "adult"))
# duration - no scale as per Watanabe et. al. 2017
asd_td_duration <- read.table('~/Documents/asd_td_duration_forR_empirical.csv', header=T, sep=",")
asd_td_duration$age <- factor(asd_td_duration$age, levels = c("child", "adolsc", "adult"))
# trans freq - scale multiplied by 100 as per Watanabe et. al. 2017
asd_td_trans <- read.table('~/Documents/asd_td_trans_forR_empirical.csv', header=T, sep=",")
asd_td_trans <- asd_td_trans %>% mutate(transFreq = transFreq *100) # turn into percentage
asd_td_trans$age <- factor(asd_td_trans$age, levels = c("child", "adolsc", "adult"))
# ADOS score - some values are NaN. GOTHAM_TOTAL are for child, adolsc. ADOS_TOTAL for adult.
asd_ados <- read.table('~/Documents/asd_td_adosTotal_forR_empirical.csv', header=T, sep=",")
asd_ados$age <- factor(asd_ados$age, levels = c("child", "adolsc", "adult"))
# ADOS Social - ADI_R_SOCIAL_TOTAL_A for child, adolsc and ADOS_SOCIAL for adult
asd_adosSocial <- read.table('~/Documents/asd_td_adosSocial_forR_empirical.csv', header=T, sep=",")
asd_adosSocial$age <- factor(asd_adosSocial$age, levels = c("child", "adolsc", "adult"))
# ADOS RRB - ADI_RRB_TOTAL_C for child, adolsc and ADOS_STEREO_BEHAV for adult
asd_adosRRB <- read.table('~/Documents/asd_td_adosRRB_forR_empirical.csv', header=T, sep=",")
asd_adosRRB$age <- factor(asd_adosRRB$age, levels = c("child", "adolsc", "adult"))
# ADOS COMM - ADI_R_VERBAL_TOTAL_BV for child, adolsc and ADOS_COMM for adult
asd_adosComm <- read.table('~/Documents/asd_td_adosComm_forR_empirical.csv', header=T, sep=",")
asd_adosComm$age <- factor(asd_adosComm$age, levels = c("child", "adolsc", "adult"))

modelDataFrames <- c("asd_td_fiqs", "asd_td_freq", "asd_td_duration", "asd_td_trans")
modelcolNames <- c("FIQ", "freq", "duration", "transFreq")
adosDataFrames <- c("asd_ados", "asd_adosSocial", "asd_adosRRB", "asd_adosComm")
adosColNames <- c("ADOS", "ADOS_SOCIAL", "ADOS_RRB", "ADOS_COMM")
frameToColumnNameHash <- hash(keys=c(modelDataFrames, adosDataFrames), values=c(modelcolNames, adosColNames))

freqStateNames <- c("majorSt1", "majorSt2", "minorSt_Combn")
freqStateCols  <- lapply(freqStateNames, paste0, "_freq") #column names to be used 
freqStateToColumnHash <- hash(keys= freqStateNames, values=freqStateCols)

transTypeNames <- c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")
transTypeCols <- c("dirMjrTransFreq", "dirMnrTransFreq", "indirMjrTransFreq")
transTypeToColumnHash <- hash(keys= transTypeNames, values=transTypeCols)

# ADOS scores - only for ASD
asdCombnData = asd_ados[c("group", "age")]
#first bind ados data
for (dataFrm in c(adosDataFrames)) {
	columnName = hashMatch(frameToColumnNameHash, dataFrm)
	asdCombnData = eval(parse(text=sprintf('cbind(asdCombnData, %s = %s$%s)', columnName, dataFrm, columnName)))
}
# then bind non-ADOS data by filtering on group. For freqs and trans data frames, filter based on state type and trans type also.
for (dataFrm in c(modelDataFrames)) { 
    columnName = hashMatch(frameToColumnNameHash, dataFrm)
    
    if (dataFrm == "asd_td_freq") {
      for (state in freqStateNames) {
       filteredData = eval(parse(text=sprintf(' %s %%>%% filter(state == \'%s\', group == \'ASD\')', dataFrm, state)))
       newColName = hashMatch(freqStateToColumnHash, state)
       asdCombnData <- eval(parse(text=sprintf('cbind(asdCombnData, %s = filteredData$%s)', newColName, columnName)))
      }
     }
    else if (dataFrm == "asd_td_trans") {
      for (transType in transTypeNames) {
       filteredData = eval(parse(text=sprintf(' %s %%>%% filter(transType == \'%s\', group == \'ASD\')', dataFrm, transType)))
       newColName = hashMatch(transTypeToColumnHash, transType)
       asdCombnData <- eval(parse(text=sprintf('cbind(asdCombnData, %s = filteredData$%s)', newColName, columnName)))
      }	
    }
    else {
       filteredData = eval(parse(text=sprintf(' %s %%>%% filter(group == \'ASD\')', dataFrm)))
       asdCombnData <- eval(parse(text=sprintf('cbind(asdCombnData, %s = filteredData$%s)', columnName, columnName)))
    }
}
# OUTLIER removal - ASD adult with duration as 37.667
asdCombnData <- asdCombnData %>% filter(duration < 37.6)

#start the plotting code for ASD 
#adosColNames <- c("ADOS", "ADOS_SOCIAL", "ADOS_RRB", "ADOS_COMM")
#N = length(adosColNames)
#adosLabels <- c("ADOS GOTHAM TOTAL", "ADI Social Score", "ADI RRB Score", "ADI Verbal Score") # NOTE: these names will be changed to adosAdultLabels below
#adosAdultLabels <- c("ADOS Total", "ADOS Social Score", "ADOS Stereotypical Behavior Score", "ADOS Communication Score")
#adosColsToLabelHash <- hash(keys=adosColNames,vals=adosLabels)
#xDataList <- c("minorSt_Combn_freq", transTypeCols, "duration")
#yDataList <- adosColNames 
#xLabels = c("appearance frequency of minor state (combined)", "direct transition freq between major states", "direct transition freq between minor states", "indirect transition freq between major states", "duration of major states")
#yLabels = adosLabels
#yAxisPercent = rep(FALSE, 1)
#xAxisPercent = c(rep(TRUE, 4), FALSE) 

#for (jj in c(1:N)) {
#   yDataList = adosColNames[jj]
#   for (ageDiv in c("child")) {
#   #for (ageDiv in c("child", "adolsc", "adult")) {
#     yLabels = adosLabels
#     if (ageDiv== "adult") { # change labels for adults
#      yLabels = adosAdultLabels 
#     }
#     data <- asdCombnData %>% filter(age == ageDiv)
#     agePretty <- ageDiv
#     if (ageDiv == "adolsc") { agePretty <- "adolescent"}
#     plotTitle <- sprintf("ASD %s | %s vs various metrics", agePretty, yLabels[jj])
#     dataInfo <- sprintf('ASD %s', ageDiv) # to be pased to the function below
#     # this function already contains code for plotting outliers   
#     resultFig <- plotMultipleCorrelation(data, "ASD",2,3, xDataList, yDataList, xLabels, yLabels[jj], yAxisPercent, xAxisPercent, plotTitle, dataInfo)
#     # save the figure
#     ggsave(resultFig, width=13, file=sprintf("asd_%s_%s_plots.pdf", ageDiv, yDataList)) 
#    }
#}
# FIQ scores - both for ASD and TD.
asdDataWithoutADOS <- asdCombnData[setdiff(colnames(asdCombnData), c("ADOS", "ADOS_SOCIAL", "ADOS_RRB", "ADOS_COMM"))]

# make combined TD data
td_dirMjrtrans = asd_td_trans %>% filter(transType == "direct MajorTrans", group == "TD")
tdCombnData = td_dirMjrtrans[c("group", "age")]
# then bind non-ADOS data by filtering on group. For freqs and trans data frames, filter based on state type and trans type also.
for (dataFrm in c(modelDataFrames)) {
    columnName = hashMatch(frameToColumnNameHash, dataFrm)

    if (dataFrm == "asd_td_freq") {
      for (state in freqStateNames) {
       filteredData = eval(parse(text=sprintf(' %s %%>%% filter(state == \'%s\', group == \'TD\')', dataFrm, state)))
       newColName = hashMatch(freqStateToColumnHash, state)
       tdCombnData <- eval(parse(text=sprintf('cbind(tdCombnData, %s = filteredData$%s)', newColName, columnName)))
      }
     }
    else if (dataFrm == "asd_td_trans") {
      for (transType in transTypeNames) {
       filteredData = eval(parse(text=sprintf(' %s %%>%% filter(transType == \'%s\', group == \'TD\')', dataFrm, transType)))
       newColName = hashMatch(transTypeToColumnHash, transType)
       tdCombnData <- eval(parse(text=sprintf('cbind(tdCombnData, %s = filteredData$%s)', newColName, columnName)))
      }
    }
    else { # duration
       filteredData = eval(parse(text=sprintf(' %s %%>%% filter(group == \'TD\')', dataFrm)))
       tdCombnData <- eval(parse(text=sprintf('cbind(tdCombnData, %s = filteredData$%s)', columnName, columnName)))
    }
}

asd_td_combn_data = rbind(asdDataWithoutADOS, tdCombnData)
yDataList = "FIQ"
yLabels = "FIQ"
xDataList <- c("minorSt_Combn_freq", transTypeCols, "duration")
xLabels = c("appearance frequency of minor state (combined)", "direct transition freq between major states", "direct transition freq between minor states", "indirect transition freq between major states", "duration of major states")
yAxisPercent = rep(FALSE, 1)
xAxisPercent = c(rep(TRUE, 4), FALSE) 

#for (ageDiv in c("child")) {   
for (ageDiv in c("child", "adolsc", "adult")) {   
     data <- asd_td_combn_data %>% filter(age == ageDiv)
     agePretty <- ageDiv
     if (ageDiv == "adolsc") { agePretty <- "adolescent"}
     plotTitle <- sprintf("ASD, TD %s | %s vs various metrics", agePretty, yLabels)
     dataInfo <- ageDiv # to be pased to the function below
     # this function already contains code for plotting outliers   
     resultFig <- plotMultipleCorrelation(data, "ASD+TD",2,3, xDataList, yDataList, xLabels, yLabels, yAxisPercent, xAxisPercent, plotTitle, dataInfo)
     # save the figure
     ggsave(resultFig, width=13, file=sprintf("asd_td_%s_%s_plots.pdf", ageDiv, yDataList)) 
}


