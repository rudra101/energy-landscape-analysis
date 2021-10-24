# this code file is to make correlation plots for FC gaps in minor state and major state modules.
# FC gap in minor state modules against (a) minorStCombined appear freq, (b) indirect trans freq, (c) direct minor trans freq, (d) ADOS total, (e) FIQ
# FC gap in major state modules against (a) combn major st freq, (b) major state duration, (c) direct major st trans, (d) ADOS total. (e) FIQ
# we will do it for both ASD and TD and then filter the results

# NOTE: OUTLIER removal has been used in case of ASD adult with duration as 37.667 
library(tidyverse)
library(grid)
library(gridExtra) # for adding multiple plots in the same figure
library(broom)
library(hash)
# source the function file
source('~/Documents/Dissertation Docs & Papers/Scripts/project_functions.r')

## Section I - load the data files
# FC gap - within `minus` across FC.
asd_td_netMods_Gap <- read.table('~/Documents/asd_td_netModsFC_Gap_forR_empirical.csv', header=T, sep=",")
asd_td_netMods_Gap$age <- factor(asd_td_netMods_Gap$age, levels = c("child", "adolsc", "adult"))
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

## Section II - filter necessary data for later use.
# FIQ filtering
asd_fiqs <- asd_td_fiqs %>% filter(group == 'ASD')
td_fiqs <- asd_td_fiqs %>% filter(group == 'TD')
# Appear freq filtering
asd_major_combn <- getMajorStCombnFreqTibble(asd_td_freq, 'ASD')
td_major_combn <- getMajorStCombnFreqTibble(asd_td_freq, 'TD')
asd_minorSt_combn <- asd_td_freq %>% filter(group=='ASD', state=='minorSt_Combn')
td_minorSt_combn <- asd_td_freq %>% filter(group=='TD', state=='minorSt_Combn')
# Duration filtering
asd_duration <- asd_td_duration %>% filter(group == 'ASD')
td_duration <- asd_td_duration %>% filter(group == 'TD')
# Trans freq filtering
asd_indirect_trans <- asd_td_trans %>% filter(group == 'ASD', transType == 'indirect MajorTrans')
td_indirect_trans <- asd_td_trans %>% filter(group == 'TD', transType == 'indirect MajorTrans')
asd_direct_minorTrans <- asd_td_trans %>% filter(group == 'ASD',transType == 'direct MinorTrans')
td_direct_minorTrans <- asd_td_trans %>% filter(group == 'TD',transType == 'direct MinorTrans')
asd_direct_majorTrans <- asd_td_trans %>% filter(group == 'ASD',transType == 'direct MajorTrans')
td_direct_majorTrans <- asd_td_trans %>% filter(group == 'TD',transType == 'direct MajorTrans')
##Section III. Make objects for ASD and TD groups, which can be directly combined.
#NOTE: (ADOS scores) children and adolescents have ADOS_GOTHAM_TOTAL values whereas adults have ADOS_TOTAL values.
asd_combn_data <- tibble(group = asd_fiqs$group,
			 age = asd_fiqs$age,
			 FIQ = asd_fiqs$FIQ,
			 majorStCombnFreq = asd_major_combn$majorStCombnFreq,
			 minorStCombnFreq = asd_minorSt_combn$freq,
			 duration = asd_duration$duration,
			 indirectMjrTrans = asd_indirect_trans$transFreq,
			 directMnrTrans = asd_direct_minorTrans$transFreq,
			 directMjrTrans = asd_direct_majorTrans$transFreq,
			 ADOS = asd_ados$ADOS,  # ADOS score for ASD
			 ADOS_SOCIAL = asd_adosSocial$ADOS_SOCIAL, # ADI_R_SOCIAL_TOTAL_A (child, adolsc) | ADOS_SOCIAL (adult)
			 ADOS_RRB = asd_adosRRB$ADOS_RRB, # ADI_RRB_TOTAL_C (child, adolsc) | ADOS_STEREO_BEHAV (adult)
			 ADOS_COMM = asd_adosComm$ADOS_COMM, # ADI_R_VERBAL_TOTAL_BV (child, adolsc) | ADOS_COMM (adult)
			 )
td_combn_data <- tibble(group = td_fiqs$group,
			 age = td_fiqs$age,
			 FIQ = td_fiqs$FIQ,
			 majorStCombnFreq = td_major_combn$majorStCombnFreq,
			 minorStCombnFreq = td_minorSt_combn$freq,
			 duration = td_duration$duration,
			 indirectMjrTrans = td_indirect_trans$transFreq,
			 directMnrTrans = td_direct_minorTrans$transFreq,
			 directMjrTrans = td_direct_majorTrans$transFreq,
			 )
 
# Section IV. Filter and join minor state FC gap correlation of (ASD/TD) group with other attributes
# for ASD - filter the respective gaps first
asd_child_minorSt_Gap <- asd_td_netMods_Gap %>% filter(group=="ASD", age == "child", stateType=="minorSt_3-4");
asd_adolsc_minorSt_Gap <- asd_td_netMods_Gap %>% filter(group=="ASD", age == "adolsc", stateType=="minorSt_3-4");
asd_adult_minorSt_Gap <- asd_td_netMods_Gap %>% filter(group=="ASD", age == "adult", stateType=="minorSt_1-4");
# combine the minor state gaps for all ages in ASD
asd_combn_minor_gap <- rbind(asd_child_minorSt_Gap, asd_adolsc_minorSt_Gap, asd_adult_minorSt_Gap)
# for ASD - make the final dataframe
asd_combn_minorSt_gap <- cbind(asd_combn_data, minorStGap = asd_combn_minor_gap$FCval)
# OUTLIER removal - ASD adult with duration as 37.667
asd_combn_minorSt_gap <- asd_combn_minorSt_gap %>% filter(duration < 37.6)

# for TD - filter the respective gaps first
# TD child has three pairs of minor states. There are two unique network modules. 
td_child_minorSt1_Gap <- asd_td_netMods_Gap %>% filter(group=="TD", age == "child", stateType=="minorSt_1-5");
td_child_minorSt2_Gap <- asd_td_netMods_Gap %>% filter(group=="TD", age == "child", stateType=="minorSt_1-4");
# TD adolsc has four pairs of minor states. There are three unique network modules.
td_adolsc_minorSt1_Gap <- asd_td_netMods_Gap %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_1-2");
td_adolsc_minorSt2_Gap <- asd_td_netMods_Gap %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_2-5");
td_adolsc_minorSt3_Gap <- asd_td_netMods_Gap %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_1-6");
# TD adult has four pairs of minor states. There are three unique network modules.
td_adult_minorSt1_Gap <- asd_td_netMods_Gap %>% filter(group=="TD", age == "adult", stateType=="minorSt_1-2");
td_adult_minorSt2_Gap <- asd_td_netMods_Gap %>% filter(group=="TD", age == "adult", stateType=="minorSt_2-5");
td_adult_minorSt3_Gap <- asd_td_netMods_Gap %>% filter(group=="TD", age == "adult", stateType=="minorSt_1-6")
# for TD - make the final dataframe. We make separate frames for child, adolsc, adult group because there are multiple pairs available.
# child - combn data
td_child_combn_data <- td_combn_data %>% filter(age == 'child') 
# child - combine different minima gaps
td_child_combn_minorSt1_Gap <- cbind(td_child_combn_data, minorStGap = td_child_minorSt1_Gap$FCval) 
td_child_combn_minorSt2_Gap <- cbind(td_child_combn_data, minorStGap = td_child_minorSt2_Gap$FCval) 
# adolsc - combn data
td_adolsc_combn_data <- td_combn_data %>% filter(age == 'adolsc') 
# adolsc - combine different minima gaps
td_adolsc_combn_minorSt1_Gap <- cbind(td_adolsc_combn_data, minorStGap = td_adolsc_minorSt1_Gap$FCval) 
td_adolsc_combn_minorSt2_Gap <- cbind(td_adolsc_combn_data, minorStGap = td_adolsc_minorSt2_Gap$FCval) 
td_adolsc_combn_minorSt3_Gap <- cbind(td_adolsc_combn_data, minorStGap = td_adolsc_minorSt3_Gap$FCval) 
# adult - combn data
td_adult_combn_data <- td_combn_data %>% filter(age == 'adult') 
# adult - combine different minima gaps
td_adult_combn_minorSt1_Gap <- cbind(td_adult_combn_data, minorStGap = td_adult_minorSt1_Gap$FCval) 
td_adult_combn_minorSt2_Gap <- cbind(td_adult_combn_data, minorStGap = td_adult_minorSt2_Gap$FCval) 
td_adult_combn_minorSt3_Gap <- cbind(td_adult_combn_data, minorStGap = td_adult_minorSt3_Gap$FCval) 

# Section V. Filter and join major state FC gap correlation of (ASD/TD) group with other attributes
asd_majorSt_gap <- asd_td_netMods_Gap %>% filter(group=='ASD', stateType == 'majorSt') 
td_majorSt_gap <- asd_td_netMods_Gap %>% filter(group=='TD', stateType == 'majorSt') 
# combi	ne major st data
asd_combn_majorSt_gap <- cbind(asd_combn_data, majorStGap = asd_majorSt_gap$FCval)
td_combn_majorSt_gap <- cbind(td_combn_data, majorStGap = td_majorSt_gap$FCval)
# OUTLIER duration of 37.667 removed. (maximum)
asd_combn_majorSt_gap <- asd_combn_majorSt_gap %>% filter(duration < 37.6) 

# Special Section. create a hashmap to preserve sanity with x and y labels
# not adding ADOS as it is ADOS_GOTHAM_TOTAL in child, adolsc whereas it is ADOS_TOTAL in adults
keylist <-c("majorStGap",
	    "minorStGap",
	    "majorStCombnFreq",
	    "duration",
	    "FIQ",
	    "indirectMjrTrans",
	    "directMnrTrans",
	    "directMjrTrans",
	    "minorStCombnFreq",
	    "ADOS",
	    "td_child_minorSt2",
	    "td_adolsc_minorSt2",
	    "td_adolsc_minorSt3",
	    "td_adult_minorSt2",
	    "td_adult_minorSt3",
	    "ADOS_SOCIAL",
	    "ADOS_RRB",
	    "ADOS_COMM" 
	    )
labelsTibble <- tibble(
    key = keylist,
    value = c("<within> - <across> FC | major states", 
	      "<within> - <across> FC | minor states", 
	      "major state freq (combined)",
	      "duration spent in major state basins",
	      "FIQ",
	      "indirect trans freq between basins of major states",
	      "direct trans freq between basins of minor states",
	      "direct trans freq between basins of major states",
	      "minor state freq (combined)",
	      "ADOS total score (*)",
	      "minor states C-D",
	      "minor states C-D",
	      "minor states E-F",
	      "minor states E-F",
	      "minor states C-D",
	      "social score (*)",
	      "stereotypical behavior score (*)",
	      "communication score (*)"
	      ))
percentOnYaxis <-tibble(
        key = keylist,
        value = c(FALSE,
		  FALSE,
		  TRUE,
		  FALSE,
		  FALSE,
		  TRUE,
		  TRUE,
		  TRUE,
		  TRUE,
		  FALSE,
		  FALSE,
		  FALSE,
		  FALSE,
		  FALSE,
		  FALSE,
		  FALSE,
		  FALSE,
		  FALSE))
labelsHash = hash(keys=labelsTibble$key, values=labelsTibble$value)
percentYAxisHash = hash(keys=percentOnYaxis$key, values=percentOnYaxis$value)
# Section VI. start with plotting correlation.
## Major st FC gap.
# Section VI (a,b) - ASD and TD
xDataList <- c("majorStGap");
yDataList <- c("majorStCombnFreq", "duration", "indirectMjrTrans", "directMnrTrans", "FIQ")
N = length(yDataList)
xLabels <- rep('<within> - <across> FC | major states', N)
yLabels <- hashMatch(labelsHash, yDataList)
yAxisPercent <- hashMatch(percentYAxisHash, yDataList)
#save the multiple figures into one grob (each age group) for sanity
#for (diaggroup in c("ASD", "TD")) {
#    M = N; #M is for subsetting
#    if (diaggroup == "TD") { #ADOS not applicable. Ignore
#     M = N - 1;
#    }
#    combnData <- eval(parse(text=sprintf('%s_combn_majorSt_gap', tolower(diaggroup))))
#  for (ageDiv in c("child", "adolsc", "adult")) { 
#     
#     data <- combnData %>% filter(group==diaggroup, age == ageDiv)
#     agePretty <- ageDiv
#     if (ageDiv == "adolsc") { agePretty <- "adolescent"}
#     plotTitle <- sprintf("%s %s | FC gap (major states) vs various metrics", diaggroup, agePretty)
#     dataInfo <- sprintf('%s %s', diaggroup, ageDiv) # to be pased to the function below
#     # this function already contains code for plotting outliers   
#     resultFig <- plotMultipleCorrelation(data, diaggroup,2,3, xDataList, yDataList[1:M], xLabels[1:M], yLabels[1:M], yAxisPercent[1:M], plotTitle, dataInfo)
#     # save the figure
#     ggsave(resultFig, width=13, file=sprintf("%s_%s_majorStFCGap_plots.pdf", tolower(diaggroup), ageDiv))
#  }
#}

## NOTE: plot ASD and TD subjects together in a single plot.
xDataList <- c("majorStGap");
yDataList <- c("majorStCombnFreq", "duration", "FIQ", "directMnrTrans", "indirectMjrTrans")
N = length(yDataList)
xLabels <- rep('<within> - <across> FC | major states', N)
yLabels <- hashMatch(labelsHash, yDataList)
yAxisPercent <- hashMatch(percentYAxisHash, yDataList)
xAxisPercent <- rep(FALSE, N)
adosScoreList = c("ADOS", "ADOS_SOCIAL", "ADOS_COMM", "ADOS_RRB")
asd_combnDataWithoutADOSScores = asd_combn_majorSt_gap[setdiff(colnames(asd_combn_majorSt_gap), adosScoreList)]
#print(colnames(asd_combnDataWithoutADOSScores))
#print(colnames(td_combn_majorSt_gap))
combnData = rbind(asd_combnDataWithoutADOSScores, td_combn_majorSt_gap)
#for (ageDiv in c("child", "adolsc", "adult")) {
#     data <- combnData %>% filter(age == ageDiv)
#     agePretty <- ageDiv
#     if (ageDiv == "adolsc") {agePretty <- "adolescent"}
#     plotTitle <- sprintf("ASD & TD %s | functional segregation (major states) vs various metrics", agePretty)
#     dataInfo <- ageDiv # to be pased to the function below
#     # this function already contains code for plotting outliers   
#     resultFig <- plotMultipleCorrelation(data, "ASD+TD",2,3, xDataList, yDataList, xLabels, yLabels, yAxisPercent, xAxisPercent, plotTitle, dataInfo)
#     # save the figure
#     ggsave(resultFig, width=13, file=sprintf("asd_td_%s_majorStFCGap_plots.pdf", ageDiv))
#}

# Special section: plot different ADOS scores vs majorSt FC gap for three age groups
xDataList <- c("majorStGap");
yDataList = c("ADOS", "ADOS_SOCIAL", "ADOS_COMM", "ADOS_RRB")
N <- length(yDataList)
xLabels <- rep('<within> - <across> FC | major states', N)
yLabels <- hashMatch(labelsHash, yDataList)
yAxisPercent <- hashMatch(percentYAxisHash, yDataList)
combnDataWithADOSScores = asd_combn_majorSt_gap[c("group", "age", "majorStGap", yDataList)]
#for (ageDiv in c("child", "adolsc", "adult")) {
#     data <- combnDataWithADOSScores %>% filter(age == ageDiv)
#     agePretty <- ageDiv
#     if (ageDiv == "adolsc") {agePretty <- "adolescent"}
#     plotTitle <- sprintf("ASD %s | functional segregation (major states) vs behavioral scores", agePretty)
#     dataInfo <- sprintf('ASD %s', ageDiv) # to be pased to the function below
#     # this function already contains code for plotting outliers
#     resultFig <- plotMultipleCorrelation(data, "asd",2,2, xDataList, yDataList, xLabels, yLabels, yAxisPercent, plotTitle, dataInfo)
#     # save the figure
#     ggsave(resultFig, width=8, file=sprintf("asd_ados_%s_majorStFCGap_plots.pdf", ageDiv))
#}
#

## Section VI(c) - major st FC gap - calculate correlation for ASD and TD.
#for (group in c("asd", "td")) {
#for (group in c("asd")) {
#  for (ageDiv in c("child", "adolsc", "adult")) {
#   data <- eval(parse(text=sprintf('%s_combn_majorSt_gap', group))) %>% filter(age == ageDiv)
# for (interest in c("ADOS", "ADOS_SOCIAL", "ADOS_COMM", "ADOS_RRB")) {
# #for (interest in c("ADOS", "majorStCombnFreq", "duration", "FIQ", "indirectMjrTrans", "directMnrTrans")) {
#         if (group == "td" && interest=="ADOS") { # not relevant, skip
#		 next
#	 }
#	 dataOfInterest <- eval(parse(text=sprintf("data$%s", interest)))
#	 res <- cor.test(data$majorStGap, dataOfInterest)
#	 if (res$p.value <= 0.05) {
#		signif_star = "***"
#	 } else {
#		signif_star = ""
#	 }
#	 print(sprintf('%s (%s %s) %s vs major st FC gap. r = %f, p = %f', signif_star, toupper(group), ageDiv, interest, res$estimate, res$p.value))
#      } 
#   }
#}

### Section VII. Minor st. NOTE: isolated networks which don't form modules have been removed.
# ASD
xDataList <- c("minorStGap");
yDataList <- c("minorStCombnFreq", "duration", "indirectMjrTrans", "directMnrTrans", "FIQ", "ADOS")
N = length(yDataList)
xLabels <- rep('<within> - <across> FC | minor states', N)
yLabels <- hashMatch(labelsHash, yDataList)
yAxisPercent <- hashMatch(percentYAxisHash, yDataList)
#save the multiple figures into one grob (each age group) for sanity
#for (diaggroup in c("ASD")) {
#    M = N; #M is for subsetting
#   combnData <- eval(parse(text=sprintf('%s_combn_minorSt_gap', tolower(diaggroup))))
#  for (ageDiv in c("child", "adolsc", "adult")) { 
#     
#     data <- combnData %>% filter(group==diaggroup, age == ageDiv)
#     agePretty <- ageDiv
#     if (ageDiv == "adolsc") { agePretty <- "adolescent"}
#     plotTitle <- sprintf("%s %s | FC gap (minor states) vs various metrics", diaggroup, agePretty)
#     dataInfo <- sprintf('%s %s', diaggroup, ageDiv)
#     resultFig <- plotMultipleCorrelation(data, diaggroup,2,3, xDataList, yDataList[1:M], xLabels[1:M], yLabels[1:M], yAxisPercent[1:M], plotTitle, dataInfo)
#     # save the figure
#     ggsave(resultFig, width=13, file=sprintf("%s_%s_minorStFCGap_plots.pdf", tolower(diaggroup), ageDiv))
#  }
#}

## Special section: plot different ADOS scores vs minorSt FC gap for three age groups
xDataList <- c("minorStGap");
yDataList = c("ADOS", "ADOS_SOCIAL", "ADOS_COMM", "ADOS_RRB")
N <- length(yDataList)
xLabels <- rep('<within> - <across> FC | minor states', N)
yLabels <- hashMatch(labelsHash, yDataList)
yAxisPercent <- hashMatch(percentYAxisHash, yDataList)
combnDataWithADOSScores = asd_combn_minorSt_gap[c("group", "age", "minorStGap", yDataList)]
#for (ageDiv in c("child", "adolsc", "adult")) {
#     data <- combnDataWithADOSScores %>% filter(age == ageDiv)
#     agePretty <- ageDiv
#     if (ageDiv == "adolsc") {agePretty <- "adolescent"}
#     plotTitle <- sprintf("ASD %s | functional segregation (major states) vs behavioral scores", agePretty)
#     dataInfo <- sprintf('ASD %s', ageDiv) # to be pased to the function below
#     # this function already contains code for plotting outliers
#     resultFig <- plotMultipleCorrelation(data, "asd",2,2, xDataList, yDataList, xLabels, yLabels, yAxisPercent, plotTitle, dataInfo)
#     # save the figure
#     ggsave(resultFig, width=8, file=sprintf("asd_ados_%s_minorStFCGap_plots.pdf", ageDiv))
#}

# Section VII (b). minor st FC gap - calculate correlation for ASD.
# for (ageDiv in c("child", "adolsc", "adult")) {
#   data <- asd_combn_minorSt_gap %>% filter(age == ageDiv)
#   for (interest in c("ADOS", "ADOS_SOCIAL", "ADOS_COMM", "ADOS_RRB")) {
# #  for (interest in c("ADOS", "duration", "minorStCombnFreq", "indirectMjrTrans", "directMnrTrans", "FIQ")) {
#         dataOfInterest <- eval(parse(text=sprintf("data$%s", interest)))
#	 res <- cor.test(data$minorStGap, dataOfInterest)
#	 if (res$p.value <= 0.05) {
#		signif_star = "***"
#	 } else {
#		signif_star = ""
#	 }
#	 print(sprintf('%s (ASD %s) minorSt FCGap vs %s. r = %f, p = %f', signif_star, ageDiv, interest, res$estimate, res$p.value))
#      } 
#   }

## Section VII(c) - (ASD) save the figures for FC gap in minor states
#  metricList <- c("indirMjrTrans", "dirMnrTrans", "ADOS", "FIQ", "Duration", "Freq")
#  for (metric in metricList) {
#       objectToSave <- sprintf("scatter.asd_minorSt_Gap_%s", metric)
#       filename <- sprintf("scatter_asd_minorSt_Gap_%s.pdf", metric) 
#       # invoke ggsave
#       eval(parse(text=sprintf("ggsave(%s, width=12, file='%s')", objectToSave, filename))) 
#  }

# TD - all age groups to be treated individually. ONLY those modules considered where networks segregate as anti-correlated.
# (a) child - only minorSt_1-4 (3-4 in new arrangement of labels) is to be considered.
# It corresponds to td_child_combn_minorSt2_Gap
# (b) adolsc - minorSt_2-5 (td_adolsc_minorSt2_Gap) and minorSt_1-6 (td_adolsc_minorSt3_Gap) are to be considered.
# (c) adult - minorSt_2-5 (td_adult_minorSt2_Gap) and minorSt_1-6 (td_adult_minorSt3_Gap) are to be considered. 
xDataList <- c("minorStGap");
yDataList <- c("minorStCombnFreq", "duration", "FIQ", "directMnrTrans", "indirectMjrTrans")
N = length(yDataList)
yLabels <- hashMatch(labelsHash, yDataList)
yAxisPercent <- hashMatch(percentYAxisHash, yDataList)
xAxisPercent <- rep(FALSE, N)
adosScoreList = c("ADOS", "ADOS_SOCIAL", "ADOS_COMM", "ADOS_RRB")
asdDataWithoutADOS = asd_combn_minorSt_gap[setdiff(colnames(asd_combn_minorSt_gap), adosScoreList)]

#NOTE: save multiple groups, save the multiple figures into one grob (each age group) for sanity
for (diaggroup in c("TD")) {
  M = N; #M is for subsetting 
  for (ageDiv in c("child", "adolsc", "adult")) {
    modules <- switch(ageDiv,
	    "child" = c("minorSt2"),
	    "adolsc" = c("minorSt2", "minorSt3"),
	    "adult" = c("minorSt2", "minorSt3")
	    )
     for (module in modules) {
  	     minorStKey <- sprintf('%s_%s_%s', tolower(diaggroup), ageDiv, module)
	     minorStName <- labelsHash[[minorStKey]]
	     #xLabels <- rep(sprintf('<within> - <across> FC | %s', minorStName), N)
	     xLabels <- rep(sprintf('<within> - <across> FC | minor states', minorStName), N)
   ## NOTE: join different diagnostic groups together 
	     #combnData <- eval(parse(text=sprintf('%s_%s_combn_%s_Gap', tolower(diaggroup), ageDiv, module)))
	     combnData <- eval(parse(text=sprintf('rbind(asdDataWithoutADOS, %s_%s_combn_%s_Gap)', tolower(diaggroup), ageDiv, module)))
	     #data <- combnData %>% filter(group==diaggroup, age == ageDiv)
	     data <- combnData %>% filter(age == ageDiv)
	     agePretty <- ageDiv
	     if (ageDiv == "adolsc") { agePretty <- "adolescent"}
	     #plotTitle <- sprintf("%s %s | FC gap | %s", diaggroup, agePretty, minorStName)
	     plotTitle <- sprintf("ASD, %s %s | functional segregation (TD %s) vs various metrics", diaggroup, agePretty, minorStName)
	     #dataInfo <- sprintf('%s %s %s', diaggroup, ageDiv, minorStName)
	     dataInfo <- ageDiv
	     #resultFig <- plotMultipleCorrelation(data, diaggroup,2,3, xDataList, yDataList[1:M], xLabels[1:M], yLabels[1:M], yAxisPercent[1:M], plotTitle, dataInfo)
	     resultFig <- plotMultipleCorrelation(data,"ASD+TD",2,3, xDataList, yDataList[1:M], xLabels[1:M], yLabels[1:M], yAxisPercent[1:M], xAxisPercent, plotTitle, dataInfo)
	     # save the figure
	     #ggsave(resultFig, width=13, file=sprintf("%s_%s_%s_FCGap_plots.pdf", tolower(diaggroup), ageDiv, module))
	     ggsave(resultFig, width=13, file=sprintf("asd_%s_%s_%s_FCGap_plots.pdf", tolower(diaggroup), module, ageDiv))
     }
  }
}

## minor st FC gap - calculate correlation for TD.
# for (ageDiv in c("child", "adolsc", "adult")) {
#   for (index in c("2", "3")) {
#   for (interest in yDataList)) {
#         if (ageDiv == "child" && index == "3") { # no such state index in TD child, skip
#		 next
#	 }
#   	 data <- eval(parse(text=sprintf('td_%s_combn_minorSt%s_Gap', ageDiv, index)))
#	 dataOfInterest <- eval(parse(text=sprintf("data$%s", interest)))
#	 res <- cor.test(data$minorStGap, dataOfInterest)
#	 if (res$p.value <= 0.05) {
#		signif_star = "***"
#	 } else {
#		signif_star = ""
#	 }
#	 print(sprintf('%s (TD %s) minorSt%s FCGap vs %s. r = %f, p = %f', signif_star, ageDiv, index, interest, res$estimate, res$p.value))
#      } 
#   }
# }

