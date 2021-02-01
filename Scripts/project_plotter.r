library(tidyverse)
library(ggsignif)
#library(dplyr)
# source the function file
source('~/Documents/Dissertation Docs & Papers/Scripts/project_functions.r')

#### Below Section for plotting and analysis of EMPIRICAL data. Scroll down for model data. #####
#asd_td_freq <- read.table('~/Documents/asd_td_freqs_forR_empirical.csv', header=T, sep=",")
#asd_td_trans <- read.table('~/Documents/asd_td_trans_forR_empirical.csv', header=T, sep=",")
#asd_td_freq <- asd_td_freq %>% mutate(freq = freq *100) # turn into percentage
#asd_td_trans <- asd_td_trans %>% mutate(transFreq = transFreq *100) # turn into percentage
#asd_td_freq$age <- factor(asd_td_freq$age, levels = c("child", "adolsc", "adult"))
#asd_td_trans$age <- factor(asd_td_trans$age, levels = c("child", "adolsc", "adult"))
#
#
#asd_td_duration <- read.table('~/Documents/asd_td_duration_forR_empirical.csv', header=T, sep=",")
#asd_td_duration$age <- factor(asd_td_duration$age, levels = c("child", "adolsc", "adult"))

## basin frequency for empirical data
#freq_AcrossAgeWithinGroup <- boxPlotterAcrossAgeWithinGroup(asd_td_freq, aes(x=state, y=freq), "basins", "appearance frequencies in empirical data", TRUE)
#
#freq_AcrossAgeBetwnGroups <- boxPlotterAcrossAgeBetwnGroup(asd_td_freq, aes(x=state, y=freq), "basins", "appearance frequencies in empirical data", TRUE)
#
## frequency stats -> across age (child, adolsc, adult) - asd vs td
#for (age in c("child", "adolsc", "adult")) {
#   for (state in c("majorSt1", "majorSt2", "minorSt_Combn")) {
#	stats = eval(parse(text=sprintf("t.test(freq ~ group, data= asd_td_freq %%>%% filter(age=='%s') %%>%% filter(state=='%s'))", age, state)))
#      print(sprintf("(ASD vs TD) %s - %s. t = %f, p = %f", age, state, stats$statistic, stats$p.value))
#   }
#}
#
## frequency stats - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("asd", "td")) {
#	print(sprintf('Frequency stats for group %s', group))
#	for (age in c("adult", "adolsc", "child")) {
#		whoVsWho = setdiff(c("adult", "adolsc", "child"), c(age));
#	for (state in c("majorSt1", "majorSt2", "minorSt_Combn")) { 
#	stats = eval(parse(text=sprintf("t.test(freq ~ age, data= asd_td_freq %%>%% filter(group == '%s') %%>%% filter(age!='%s') %%>%% filter(state=='%s'))", group, age, state)))
#	print(sprintf("(%s vs %s) %s. t = %f, p = %f", whoVsWho[1], whoVsWho[2], state, stats$statistic, stats$p.value))
#	}
#	}
#}
#
### plot transitions for empirical data
#trans_AcrossAgeWithinGroup <- boxPlotterAcrossAgeWithinGroup(asd_td_trans, aes(x=transType, y=transFreq), "transitions", "transition frequencies in empirical data", TRUE)
#       
#trans_AcrossAgeBetwnGroup <- boxPlotterAcrossAgeBetwnGroup(asd_td_trans, aes(x=transType, y=transFreq), "transitions", "transition frequencies in empirical data", TRUE)
	
## transition stats -> across age (child, adolsc, adult) - asd vs td
#for (age in c("child", "adolsc", "adult")) {
#   for (transType in c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")) {
#	stats = eval(parse(text=sprintf("t.test(transFreq ~ group, data= asd_td_trans %%>%% filter(age=='%s') %%>%% filter(transType=='%s'))", age, transType)))
#      print(sprintf("(ASD vs TD) %s - %s. t = %f, p = %f", age, transType, stats$statistic, stats$p.value))
#   }
#}
#
## transition stats - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("asd", "td")) {
#	print(sprintf('Transition stats for group %s', group))
#	for (age in c("adult", "adolsc", "child")) {
#	whoVsWho = setdiff(c("adult", "adolsc", "child"), c(age));
#       for (transType in c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")) {
#	stats = eval(parse(text=sprintf("t.test(transFreq ~ age, data= asd_td_trans %%>%% filter(group == '%s') %%>%% filter(age!='%s') %%>%% filter(transType=='%s'))", group, age, transType)))
#	print(sprintf("(%s vs %s) %s. t = %f, p = %f", whoVsWho[1], whoVsWho[2], transType, stats$statistic, stats$p.value))
#	}
#	}
#}

## plot duration for empirical data
#duration_AcrossAgeBetwnGroups <- ggplot(data=asd_td_duration, aes(x=age, y=duration)) + 
#	#geom_violin(alpha=0.7) +
#	geom_boxplot(aes(fill=group), alpha=0.6) + 
#	#geom_jitter(aes(color=group), size=0.4, alpha=0.9) +
#	#geom_signif(comparisons = list(c("asd", "td")), test=`t.test`, map_signif_level=TRUE) + 
#	#facet_wrap(~group, ncol=2) +
#	ylab("major state duration in empirical data")
#
#duration_AcrossAgeWithinGroup <- ggplot(data=asd_td_duration, aes(x=group, y=duration, fill=age)) + 
#	#geom_violin(alpha=0.7) +
#	geom_boxplot(alpha=0.6) + 
#	#geom_jitter(color="black", size=0.4, alpha=0.9) +
#	#geom_signif(comparisons= group, test=`t.test`, map_signif_level=TRUE) +
#	# facet_wrap(~age, ncol=3) +
#	ylab("major state duration in empirical data")

# duration stats - ASD vs TD across age.
#for (age in c("child", "adolsc", "adult")) {
#	stats = eval(parse(text=sprintf("t.test(duration ~ group, data= asd_td_duration %%>%% filter(age=='%s'))", age)))
#      print(sprintf("(ASD vs TD) duration - %s. t = %f, p = %f", age, stats$statistic, stats$p.value))
#}

# duration stats - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("asd", "td")) {
#	print(sprintf('Duration stats for group %s', group))
#	for (age in c("adult", "adolsc", "child")) {
#	whoVsWho = setdiff(c("adult", "adolsc", "child"), c(age));
#	stats = eval(parse(text=sprintf("t.test(duration ~ age, data= asd_td_duration %%>%% filter(group == '%s') %%>%% filter(age!='%s'))", group, age)))
#	print(sprintf("(%s vs %s) t = %f, p = %f", whoVsWho[1], whoVsWho[2], stats$statistic, stats$p.value))
#	}
#}
#ggsave(freq_AcrossAgeBetwnGroups, width=12, file = "empirical_freq_AcrossAgeBetwnGroups.pdf")
#ggsave(freq_AcrossAgeWithinGroup, width=12, file = "empirical_freq_AcrossAgeWithinGroup.pdf")
#ggsave(trans_AcrossAgeBetwnGroup, width=12, file = "empirical_trans_AcrossAgeBetwnGroups.pdf")
#ggsave(trans_AcrossAgeWithinGroup, width=12, file = "empirical_trans_AcrossAgeWithinGroup.pdf")
#ggsave(duration_AcrossAgeBetwnGroups, width=7, file = "empirical_duration_AcrossAgeBetwnGroups.pdf")
#ggsave(duration_AcrossAgeWithinGroup, width=7, file = "empirical_duration_AcrossAgeWithinGroup.pdf")

#### Below Section for plotting and analysis of MODEL data. #####
asd_td_bsnSzModel <- read.table('~/Documents/asd_td_basinSize_forR_model.csv', header=T, sep=",")
asd_td_durationModel <- read.table('~/Documents/asd_td_duration_forR_model.csv', header=T, sep=",")
asd_td_transModel <- read.table('~/Documents/asd_td_trans_forR_model.csv', header=T, sep=",")
asd_td_freqsModel <- read.table('~/Documents/asd_td_freqs_forR_model.csv', header=T, sep=",")
### mutate relevant data fields
asd_td_freqsModel <- asd_td_freqsModel %>% mutate(freq = freq *100) # turn into percentage
asd_td_transModel <- asd_td_transModel %>% mutate(transFreq = transFreq *100) # turn into percentage
### set the age factor to chronological order.
asd_td_bsnSzModel$age <- factor(asd_td_bsnSzModel$age, levels = c("child", "adolsc", "adult"))
asd_td_durationModel$age <- factor(asd_td_durationModel$age, levels = c("child", "adolsc", "adult"))
asd_td_transModel$age <- factor(asd_td_transModel$age, levels = c("child", "adolsc", "adult"))
asd_td_freqsModel$age <- factor(asd_td_freqsModel$age, levels = c("child", "adolsc", "adult"))

### plot basin size for model.
#basinSz_AcrossAgeWithinGroup <- barPlotterAcrossAgeWithinGroup(asd_td_bsnSzModel, aes(x=basin, y=basinSize), "basins", "basin sizes in model", TRUE)
#basinSz_AcrossAgeBetwnGroup <- barPlotterAcrossAgeBetwnGroup(asd_td_bsnSzModel, aes(x=basin, y=basinSize), "basins", "basin sizes in model", TRUE)
### stats for model basin size
# across age - between ASD and TD
#for (age in c("child", "adolsc", "adult")) {
#   for (basin in c("Major st 1", "Major st 2", "Minor st (grouped)")) {
#      asd_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='%s',basin=='%s',group=='ASD')", age, basin)))
#      td_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='%s',basin=='%s',group=='TD')", age, basin)))
#      N = 128/100; # total number of basins / 100 to normalise	
#      stats = prop.test(x=c(round(asd_data$basinSize*N), round(td_data$basinSize*N)),c(128,128) , correct=FALSE)
#      print(sprintf("(ASD vs TD) %s - %s. chi2 = %f, p = %f", age, basin, stats$statistic, stats$p.value))
#   }
#}

## stats for model basin size - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("ASD", "TD")) {
#   print(sprintf("model basin size stats for group %s", group))
#   for (basin in c("Major st 1", "Major st 2", "Minor st (grouped)")) {
#	
#     child_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='child',basin=='%s',group=='%s')", basin, group)))
#     adolsc_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='adolsc',basin=='%s',group=='%s')", basin, group)))
#     adult_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='adult',basin=='%s',group=='%s')", basin, group)))
#     #print(sprintf('child = %f, adolsc = %f, adult = %f', child_data$basinSize, adolsc_data$basinSize, adult_data$basinSize))
#      N = 128/100; # total number of basins / 100 to normalise	
#     # child vs adolsc
#      stats = prop.test(x=c(round(child_data$basinSize*N), round(adolsc_data$basinSize*N)), c(128,128), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child","adolsc", basin, stats$statistic, stats$p.value))
#
#     # adolsc vs adult
#      stats = prop.test(x=c(round(adolsc_data$basinSize*N), round(adult_data$basinSize*N)), c(128,128), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "adolsc", "adult", basin, stats$statistic, stats$p.value))
#     
#     # child vs adult
#     stats = prop.test(x=c(round(child_data$basinSize*N), round(adult_data$basinSize*N)), c(128,128), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child", "adult", basin, stats$statistic, stats$p.value))
#}
#}

#
#### plot trans for model
##trans_AcrossAgeBetwnGroup <- barPlotterAcrossAgeBetwnGroup(asd_td_transModel, aes(x=transType, y=transFreq), "transitions", "transition frequencies in model", TRUE)
##trans_AcrossAgeWithinGroup <- barPlotterAcrossAgeWithinGroup(asd_td_transModel, aes(x=transType, y=transFreq), "transitions", "transition frequencies in model", TRUE)
## stats for trans in model
#for (age in c("child", "adolsc", "adult")) {
#   for (transType in c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")) {
#      asd_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='%s',transType=='%s',group=='ASD')", age, transType)))
#      td_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='%s',transType=='%s',group=='TD')", age, transType)))
##print(sprintf('asd= %f, td=%f', asd_data$transFreq, td_data$transFreq))
#      stats = prop.test(x=c(asd_data$transFreq*100, td_data$transFreq*100), n=c(10^5,10^5), correct=FALSE)
#      print(sprintf("(ASD vs TD) %s - %s. chi2 = %f, p = %f", age, transType, stats$statistic, stats$p.value))
#   }
#}

## stats for model trans freq - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("ASD", "TD")) {
#   print(sprintf("transition stats for group %s", group))
#   for (transType in c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")) {
#	
#     child_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='child',transType=='%s',group=='%s')", transType, group)))
#     adolsc_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='adolsc',transType=='%s',group=='%s')", transType, group)))
#     adult_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='adult',transType=='%s',group=='%s')", transType, group)))
#     #print(sprintf('child = %f, adolsc = %f, adult = %f', child_data$basinSize, adolsc_data$basinSize, adult_data$basinSize))
#     # child vs adolsc
#      stats = prop.test(x=c(child_data$transFreq*100, adolsc_data$transFreq*100), n=c(10^5,10^5), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child","adolsc", transType, stats$statistic, stats$p.value))
#
#     # adolsc vs adult
#      stats = prop.test(x=c(adolsc_data$transFreq*100, adult_data$transFreq*100), n=c(10^5,10^5), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "adolsc", "adult", transType, stats$statistic, stats$p.value))
#     
#     # child vs adult
#      stats = prop.test(x=c(child_data$transFreq*100, adult_data$transFreq*100), n=c(10^5,10^5), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child", "adult", transType, stats$statistic, stats$p.value))
#}
#}


### plot appearance freq for model
#freq_AcrossAgeBetwnGroup <- barPlotterAcrossAgeBetwnGroup(asd_td_freqsModel, aes(x=state, y=freq), "frequencies", "appearance frequencies in model", TRUE)
#freq_AcrossAgeWithinGroup <- barPlotterAcrossAgeWithinGroup(asd_td_freqsModel, aes(x=state, y=freq), "frequencies", "appearance frequencies in model", TRUE)
## stat for model appearance frequencies
#for (age in c("child", "adolsc", "adult")) {
#   for (state in c("Major st 1", "Major st 2", "Minor st (grouped)")) {
#      asd_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='%s',state=='%s',group=='ASD')", age, state)))
#      td_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='%s',state=='%s',group=='TD')", age, state)))
##print(sprintf('asd= %f, td=%f', asd_data$transFreq, td_data$transFreq))
#      stats = prop.test(x=c(asd_data$freq*100, td_data$freq*100), n=c(10^5,10^5), correct=FALSE)
#      print(sprintf("(ASD vs TD) %s - %s. chi2 = %f, p = %f", age, state, stats$statistic, stats$p.value))
#   }
#}

## stats for model trans freq - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
for (group in c("ASD", "TD")) {
   print(sprintf("appearance freq stats for group %s", group))
   for (state in c("Major st 1", "Major st 2", "Minor st (grouped)")) {
	
     child_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='child',state=='%s',group=='%s')", state, group)))
     adolsc_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='adolsc',state=='%s',group=='%s')", state, group)))
     adult_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='adult',state=='%s',group=='%s')", state, group)))
     #print(sprintf('child = %f, adolsc = %f, adult = %f', child_data$basinSize, adolsc_data$basinSize, adult_data$basinSize))
     # child vs adolsc
      stats = prop.test(x=c(child_data$freq*100, adolsc_data$freq*100), n=c(10^5,10^5), correct=FALSE)
     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child","adolsc", state, stats$statistic, stats$p.value))

     # adolsc vs adult
      stats = prop.test(x=c(adolsc_data$freq*100, adult_data$freq*100), n=c(10^5,10^5), correct=FALSE)
     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "adolsc", "adult", state, stats$statistic, stats$p.value))
     
     # child vs adult
      stats = prop.test(x=c(child_data$freq*100, adult_data$freq*100), n=c(10^5,10^5), correct=FALSE)
     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child", "adult", state, stats$statistic, stats$p.value))
}
}


## plot duration for model
#dodgeWidth <- 0.75;
#duration_AcrossAgeBetwnGroup <- ggplot(data=asd_td_durationModel, aes(x=age, y=duration)) + 
#	geom_col(aes(fill=group), position=position_dodge(width=dodgeWidth), alpha=0.7, width=0.7) + 
#	geom_errorbar(aes(color=group, ymin=duration, ymax=duration+std), position=position_dodge(width=dodgeWidth), alpha=0.7, width=0.2, size=0.3) +	
#	ylab("major state duration in empirical data")
#
#duration_AcrossAgeWithinGroup <- ggplot(data=asd_td_durationModel, aes(x=group, y=duration )) + 
#	#geom_violin(alpha=0.7) +
#	geom_col(aes(fill=age), position=position_dodge(width=dodgeWidth), alpha=0.7, width=0.7) +
#	geom_errorbar(aes(color=age, ymin=duration, ymax=duration+std), position=position_dodge(width=dodgeWidth), alpha=0.7, width=0.2, size=0.3) +	
#	ylab("major state duration in empirical data")

## stats for duration - found in complementary Matlab code which already has t-tests for duration.

## save the plots 
#ggsave(freq_AcrossAgeBetwnGroup, width=12, file = "model_freq_AcrossAgeBetwnGroups.pdf")
#ggsave(freq_AcrossAgeWithinGroup, width=12, file = "model_freq_AcrossAgeWithinGroup.pdf")
#ggsave(trans_AcrossAgeBetwnGroup, width=12, file = "model_trans_AcrossAgeBetwnGroups.pdf")
#ggsave(trans_AcrossAgeWithinGroup, width=12, file = "model_trans_AcrossAgeWithinGroup.pdf")
#ggsave(basinSz_AcrossAgeBetwnGroup, width=12, file = "model_basinSz_AcrossAgeBetwnGroups.pdf")
#ggsave(basinSz_AcrossAgeWithinGroup, width=12, file = "model_basinSz_AcrossAgeWithinGroup.pdf")
#ggsave(duration_AcrossAgeBetwnGroup, width=7, file = "model_duration_AcrossAgeBetwnGroups.pdf")
#ggsave(duration_AcrossAgeWithinGroup, width=7, file = "model_duration_AcrossAgeWithinGroup.pdf")

