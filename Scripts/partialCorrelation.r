# for generating partial correlation results
library(tidyverse)
library(ppcor) # allows par cor analysis of n vars at one go. The data frame or tibble should have columns as the vars one is interested in.
source('~/Documents/Dissertation Docs & Papers/Scripts/project_functions.r')

# four sets of partial correlation for each age group -
# (a) (ASD) indirect trans freq vs ADOS, appear freq of indiv or combn minor state
# (b) (ASD and TD) duration of major state vs FIQ, appear freq of indiv major state
# (c) (ASD and TD) indirect trans freq vs FIQ, appear freq of indiv major states
# (d) (ASD and TD) major state duration, indirect trans freq, minor st combined freq

# start with the data
# get appear freq
asd_td_freq <- read.table('~/Documents/asd_td_freqs_forR_empirical.csv', header=T, sep=",")
asd_td_freq <- asd_td_freq %>% mutate(freq = freq *100) # turn into percentage
asd_td_freq$age <- factor(asd_td_freq$age, levels = c("child", "adolsc", "adult"))
# get major state duration
asd_td_duration <- read.table('~/Documents/asd_td_duration_forR_empirical.csv', header=T, sep=",")
asd_td_duration$age <- factor(asd_td_duration$age, levels = c("child", "adolsc", "adult"))
# trans freq - scale multiplied by 100 as per Watanabe et. al. 2017
asd_td_trans <- read.table('~/Documents/asd_td_trans_forR_empirical.csv', header=T, sep=",")
asd_td_trans <- asd_td_trans %>% mutate(transFreq = transFreq*100) # turn into percentage
asd_td_trans$age <- factor(asd_td_trans$age, levels = c("child", "adolsc", "adult"))
# FIQ - no scale change needed.
asd_td_fiqs <- read.table('~/Documents/asd_td_fiqs_forR_empirical.csv', header=T, sep=",")
asd_td_fiqs$age <- factor(asd_td_fiqs$age, levels = c("child", "adolsc", "adult"))
# ADOS scores. ADOS_GOTHAM_TOTAL for children and adolescents. ADOS_TOTAL for adults.
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

# filter necessary data
# the following eval code will filter - (a) <group>_<age>_indirect_trans (b)<group>_<age>_minorSt_combn (c) <group>_<age>_duration (d) <group>_<age>_majorSt1_freq (e) <group>_<age>_majorSt2_freq (f) <group>_<age>_indirect_trans 
for (group in c("asd", "td")) {
for (ageDiv in c("adult", "adolsc", "child")) {
#for (ageDiv in c("child", "adolsc", "adult")) {
if (group == "asd") {
  eval(parse(text=sprintf("%s_%s_ados <- asd_ados %%>%% filter(group == '%s', age == \'%s\')", group, ageDiv, toupper(group), ageDiv)))
  eval(parse(text=sprintf("%s_%s_adosSocial <- asd_adosSocial %%>%% filter(group == '%s', age == \'%s\')", group, ageDiv, toupper(group), ageDiv)))
  eval(parse(text=sprintf("%s_%s_adosRRB <- asd_adosRRB %%>%% filter(group == '%s', age == \'%s\')", group, ageDiv, toupper(group), ageDiv)))
  eval(parse(text=sprintf("%s_%s_adosComm <- asd_adosComm %%>%% filter(group == '%s', age == \'%s\')", group, ageDiv, toupper(group), ageDiv)))
}
eval(parse(text=sprintf("%s_%s_indirect_trans <- asd_td_trans %%>%% filter(group == '%s', transType == 'indirect MajorTrans', age == \'%s\')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_minorSt_combn <- asd_td_freq %%>%% filter(group == '%s', state=='minorSt_Combn', age == '%s')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_fiq <- asd_td_fiqs %%>%% filter(group == '%s', age == \'%s\')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_duration <- asd_td_duration %%>%% filter(group == '%s', age == '%s')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_majorSt1_freq <- asd_td_freq %%>%% filter(group == '%s', age == '%s', state=='majorSt1')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_majorSt2_freq <- asd_td_freq %%>%% filter(group == '%s', age == '%s', state=='majorSt2')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_indirect_trans <- asd_td_trans %%>%% filter(group == '%s', transType == 'indirect MajorTrans', age == '%s')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_directMinorTrans <- asd_td_trans %%>%% filter(group == '%s', transType == 'direct MinorTrans', age == '%s')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_directMajorTrans <- asd_td_trans %%>%% filter(group == '%s', transType == 'direct MajorTrans', age == '%s')", group, ageDiv, toupper(group), ageDiv)))
}
}

# build up tibble for diagnostic groups (across age) to carry out par cor analysis
# four sets of partial correlation for each age group -
# (a) (ASD) indirect trans freq vs ADOS, appear freq of indiv or combn minor state
# (b) (ASD and TD) duration of major state vs FIQ, appear freq of indiv major state
# (c) (ASD and TD) indirect trans freq vs FIQ, appear freq of indiv or combn minor states
# (d) (ASD and TD) major state duration, indirect trans freq, minor st combined freq

# ASD group
#for (ageDiv in c("adult", "adolsc", "child")) {
 for (ageDiv in c("child", "adolsc", "adult")) {
for (prefix in c("asd", "td")) {
   # build data tibble of interest
   data <- tibble( 
		  dirMajorTransFreq = eval(parse(text=sprintf("%s_%s_directMajorTrans$transFreq",prefix,ageDiv))),
		  dirMinorTransFreq = eval(parse(text=sprintf("%s_%s_directMinorTrans$transFreq",prefix,ageDiv))),
		   indirTransFreq = eval(parse(text=sprintf("%s_%s_indirect_trans$transFreq",prefix,ageDiv))),
		   minorStCombnFreq = eval(parse(text=sprintf("%s_%s_minorSt_combn$freq",prefix,ageDiv))),
		   majorSt1Freq = eval(parse(text=sprintf("%s_%s_majorSt1_freq$freq",prefix,ageDiv))),
		   majorSt2Freq = eval(parse(text=sprintf("%s_%s_majorSt2_freq$freq",prefix,ageDiv))),
		   duration = eval(parse(text=sprintf("%s_%s_duration$duration",prefix,ageDiv))),
		   FIQ = eval(parse(text=sprintf("%s_%s_fiq$FIQ",prefix,ageDiv))) 
		  )
  identifier = sprintf("%s %s", toupper(prefix), ageDiv)
  if (prefix == "asd") {
   data$ADOS <-	eval(parse(text=sprintf("%s_%s_ados$ADOS",prefix,ageDiv)));   # ADOS total
   data$ADOS_SOCIAL <- eval(parse(text=sprintf("%s_%s_adosSocial$ADOS_SOCIAL",prefix,ageDiv)));
   #print(data$ADOS_SOCIAL)
   data$ADOS_COMM <- eval(parse(text=sprintf("%s_%s_adosComm$ADOS_COMM",prefix,ageDiv)));
   data$ADOS_RRB <- eval(parse(text=sprintf("%s_%s_adosRRB$ADOS_RRB",prefix,ageDiv)));

   #filter out empty data
   data <- data %>% filter(!is.na(ADOS), !is.na(ADOS_SOCIAL), !is.na(ADOS_COMM), !is.na(ADOS_RRB))
   # partial correlation - (a) . TBD: Refer comments above to understand indices.  
   metricList <- c("duration", "dirMajorTransFreq", "indirTransFreq", "dirMinorTransFreq", "minorStCombnFreq")
   adosScoreList <- c("ADOS", "ADOS_SOCIAL", "ADOS_COMM", "ADOS_RRB")
   N <- length(metricList)
   for (adosScore in adosScoreList) {
   cnt = 1;
   for (ii in c(1:(N-1))) {
     for (jj in c((ii+1):N)) {
       if (ii == 2 && jj == 4) {
        # this combination is breaking pcor code to setup row and col names to the names of datafield. Don't have time to deeply debug.
        #printParCorResults(data[c("ADOS", metricList[ii], metricList[jj])], identifier) # subset data and call the functions
        next;
       } else {
        #next;
       }
       #print(sprintf("ii = %d, jj = %d", ii, jj))
       removeOutlierAndPrintParCorResults(data[c(adosScore, metricList[ii], metricList[jj])], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
       #removeOutlierAndPrintParCorResults(data[c("ADOS_SOCIAL", metricList[ii], metricList[jj])], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
       #removeOutlierAndPrintParCorResults(data[c("ADOS_COMM", metricList[ii], metricList[jj])], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
       #removeOutlierAndPrintParCorResults(data[c("ADOS_RRB", metricList[ii], metricList[jj])], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
       #printParCorResults(data[c("ADOS", metricList[ii], metricList[jj])], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
       cnt = cnt + 1;
     }
   }
   cat("\n")
   }
  }
 
   #metricList <- c("duration", "dirMajorTransFreq", "indirTransFreq", "dirMinorTransFreq", "minorStCombnFreq")
   # cnt = 1;
   # for (ii in c(1:(N-1))) {
   #  for (jj in c((ii+1):N)) {
   #    if (ii == 2 && jj == 4) {
   #    # #printParCorResults(data[c("ADOS", metricList[ii], metricList[jj])], identifier) # subset data and call the functions
   #     next;
   #    } #else {
   #    # #next;
   #    #}
   #    #print(sprintf("ii = %d, jj = %d", ii, jj))
   #     removeOutlierAndPrintParCorResults(data[c("FIQ", metricList[ii], metricList[jj])], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
   #    #printParCorResults(data[c("FIQ", metricList[ii], metricList[jj])], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
   #    cnt = cnt + 1;
   #  }
   #}
 
  # partial correlation - (b) . Refer comments above to understand indices.
 # printParCorResults(data[c("duration", "FIQ", "minorStCombnFreq")], identifier) # subset data and call the functions
 # 
 # # partial correlation - (c) . Refer comments above to understand indices.
 # printParCorResults(data[c("indirTransFreq", "FIQ", "minorStCombnFreq")], identifier) # subset data and call the functions
 #  
 # # partial correlation - (d) . Refer comments above to understand indices.
 #removeOutlierAndPrintParCorResults(data[c("duration", "indirTransFreq", "minorStCombnFreq")], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
 #printParCorResults(data[c("duration", "indirTransFreq", "minorStCombnFreq")], sprintf('%d. %s', cnt, identifier)) # subset data and call the functions
 }
}

