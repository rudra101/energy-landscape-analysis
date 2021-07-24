library(tidyverse)
library(ggsignif)
#library(dplyr)
# source the function file
source('~/Documents/Dissertation Docs & Papers/Scripts/project_functions.r')

#### Below Section for plotting and analysis of EMPIRICAL data. Scroll down for model data. #####
asd_td_freq <- read.table('~/Documents/asd_td_freqs_forR_empirical.csv', header=T, sep=",")
asd_td_Combn_freq <- read.table('~/Documents/asd_td_combined_freqs_forR_empirical.csv', header=T, sep=",")
asd_td_trans <- read.table('~/Documents/asd_td_trans_forR_empirical.csv', header=T, sep=",")
asd_td_freq <- asd_td_freq %>% mutate(freq = freq *100) # turn into percentage
asd_td_Combn_freq <- asd_td_Combn_freq %>% mutate(freq = freq *100) # turn into percentage
asd_td_trans <- asd_td_trans %>% mutate(transFreq = transFreq *100) # turn into percentage
asd_td_freq$age <- factor(asd_td_freq$age, levels = c("child", "adolsc", "adult"))
asd_td_trans$age <- factor(asd_td_trans$age, levels = c("child", "adolsc", "adult"))
asd_td_Combn_freq$age <- factor(asd_td_Combn_freq$age, levels = c("child", "adolsc", "adult"))

asd_td_duration <- read.table('~/Documents/asd_td_duration_forR_empirical.csv', header=T, sep=",")
asd_td_duration$age <- factor(asd_td_duration$age, levels = c("child", "adolsc", "adult"))
# load ages of individual subjects.
asd_td_ages <- read.table('~/Documents/asd_td_ages_forR_empirical.csv', header=T, sep=",")
asd_td_ages$age <- factor(asd_td_ages$age, levels = c("child", "adolsc", "adult"))
# load fiqs of individual subjects.
asd_td_fiqs <- read.table('~/Documents/asd_td_fiqs_forR_empirical.csv', header=T, sep=",")
asd_td_fiqs$age <- factor(asd_td_fiqs$age, levels = c("child", "adolsc", "adult"))
## OUTLIER removal. ASD adult with duration.
asd_td_duration <- asd_td_duration %>% filter(duration < 37) 

## basin frequency for empirical data
#freq_AcrossAgeWithinGroup <- boxPlotterAcrossAgeWithinGroup(asd_td_freq, aes(x=state, y=freq), "basins", "appearance frequencies in empirical data", TRUE)
#
#freq_AcrossAgeBetwnGroups <- boxPlotterAcrossAgeBetwnGroup(asd_td_freq, aes(x=state, y=freq), "basins", "appearance frequencies in empirical data", TRUE)
#combnFreq_AcrossAgeWithinGroup <- boxPlotterAcrossAgeWithinGroup(asd_td_Combn_freq, aes(x=state, y=freq), "basins", "appearance frequencies in empirical data", TRUE)
#ggsave(combnFreq_AcrossAgeWithinGroup, width=12, file = "empirical_combnfreq_AcrossAge.pdf")
combnFreq_BetweenGroup <- boxPlotterAcrossAgeBetwnGroup(asd_td_Combn_freq, aes(x=state, y=freq), "basins", "appearance frequencies in empirical data", TRUE)
#ggsave(combnFreq_BetweenGroup, width=12, file = "empirical_combnfreq_BetweenGroup.pdf")

#
# frequency stats -> across age (child, adolsc, adult) - asd vs td
for (age in c("child", "adolsc", "adult")) {
   for (state in c("majorSt_Combn", "minorSt_Combn")) {
#   for (state in c("majorSt1", "majorSt2", "minorSt_Combn")) {
      #stats = eval(parse(text=sprintf("t.test(freq ~ group, data= asd_td_freq %%>%% filter(age=='%s', state=='%s'))", age, state)))
      stats = eval(parse(text=sprintf("t.test(freq ~ group, data= asd_td_Combn_freq %%>%% filter(age=='%s', state=='%s'))", age, state)))
      print(sprintf("(ASD vs TD) %s - %s. t(df=%f) = %f, p = %f", age, state, stats$parameter, stats$statistic, stats$p.value))
   }
}

# frequency stats - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("ASD", "TD")) {
#	print(sprintf('Frequency stats for group %s', group))
#	for (age in c("adult", "adolsc", "child")) {
#		whoVsWho = setdiff(c("adult", "adolsc", "child"), c(age));
#		data1 = c(); data2 = c();
#	# combined major state
#	for (state in c("majorSt1", "majorSt2", "minorSt_Combn")) {
#	  tab1 = eval(parse(text=sprintf("asd_td_freq %%>%% filter(group == '%s', age=='%s', state=='%s')", group, whoVsWho[1], state)))
#	  tab2 = eval(parse(text=sprintf("asd_td_freq %%>%% filter(group == '%s', age=='%s', state=='%s')", group, whoVsWho[2], state)))
#
#	  if (grepl("major", state, fixed=TRUE)) { # take major state data
#	    if (length(data1) == 0) { data1 = tab1$freq; }
#	    else { data1 = data1 + tab1$freq;}
#	    if (length(data2) == 0) { data2 = tab2$freq; }
#	    else { data2 = data2 + tab2$freq;}
#	  }
##	stats = eval(parse(text=sprintf("t.test(freq ~ age, data= asd_td_freq %%>%% filter(group == '%s', age!='%s', state=='%s'))", group, age, state)))
##	print(sprintf("(%s vs %s) %s. t(df = %f) = %f, p = %f", whoVsWho[1], whoVsWho[2], state, stats$parameter, stats$statistic, stats$p.value))
#	}
#	stats = t.test(data1, data2);
#	print(sprintf("(%s vs %s) combn Major appearFreq. t(df = %f) = %f, p = %f", whoVsWho[1], whoVsWho[2], stats$parameter, stats$statistic, stats$p.value))
#	}
#}
#
### plot transitions for empirical data
#trans_AcrossAgeWithinGroup <- boxPlotterAcrossAgeWithinGroup(asd_td_trans, aes(x=transType, y=transFreq), "transitions", "transition frequencies in empirical data", TRUE)
##       
#trans_AcrossAgeBetwnGroup <- boxPlotterAcrossAgeBetwnGroup(asd_td_trans, aes(x=transType, y=transFreq), "transitions", "transition frequencies in empirical data", TRUE)
	
## transition stats -> across age (child, adolsc, adult) - asd vs td
#for (age in c("child", "adolsc", "adult")) {
#   for (transType in c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")) {
#	stats = eval(parse(text=sprintf("t.test(transFreq ~ group, data= asd_td_trans %%>%% filter(age=='%s') %%>%% filter(transType=='%s'))", age, transType)))
#      print(sprintf("(ASD vs TD) %s - %s. t(df=%f) = %f, p = %f", age, transType, stats$parameter, stats$statistic, stats$p.value))
#   }
#}
#
## transition stats - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("ASD", "TD")) {
#	print(sprintf('Transition stats for group %s', group))
#	for (age in c("adult", "adolsc", "child")) {
#	whoVsWho = setdiff(c("adult", "adolsc", "child"), c(age));
#       for (transType in c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")) {
#	stats = eval(parse(text=sprintf("t.test(transFreq ~ age, data= asd_td_trans %%>%% filter(group == '%s') %%>%% filter(age!='%s') %%>%% filter(transType=='%s'))", group, age, transType)))
#	print(sprintf("(%s vs %s) %s. t(df=%f) = %f, p = %f", whoVsWho[1], whoVsWho[2], transType, stats$parameter, stats$statistic, stats$p.value))
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
#	expand_limits(y=26) +
#	ylab("major state duration in empirical data")

#duration_AcrossAgeWithinGroup <- ggplot(data=asd_td_duration, aes(x=group, y=duration, fill=age)) + 
#	#geom_violin(alpha=0.7) +
#	geom_boxplot(alpha=0.6) + 
#	#geom_jitter(color="black", size=0.4, alpha=0.9) +
#	#geom_signif(comparisons= group, test=`t.test`, map_signif_level=TRUE) +
#	# facet_wrap(~age, ncol=3) +
#	expand_limits(y=26) +
#	ylab("major state duration in empirical data")

# duration stats - ASD vs TD across age.
#for (age in c("child", "adolsc", "adult")) {
#      stats = eval(parse(text=sprintf("t.test(duration ~ group, data= asd_td_duration %%>%% filter(age=='%s'))", age)))
#      print(sprintf("(ASD vs TD) duration - %s. t(df=%f) = %f, p = %f", age, stats$parameter, stats$statistic, stats$p.value))
#}

# duration stats - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("ASD", "TD")) {
#	print(sprintf('Duration stats for group %s', group))
#	for (age in c("adult", "adolsc", "child")) {
#	whoVsWho = setdiff(c("adult", "adolsc", "child"), c(age));
#	stats = eval(parse(text=sprintf("t.test(duration ~ age, data= asd_td_duration %%>%% filter(group == '%s') %%>%% filter(age!='%s'))", group, age)))
#	print(sprintf("(%s vs %s) t(df=%f) = %f, p = %f", whoVsWho[1], whoVsWho[2], stats$parameter, stats$statistic, stats$p.value))
#	}
#}

#ggsave(freq_AcrossAgeBetwnGroups, width=12, file = "empirical_freq_AcrossAgeBetwnGroups.pdf")
#ggsave(freq_AcrossAgeWithinGroup, width=12, file = "empirical_freq_AcrossAgeWithinGroup.pdf")
#ggsave(trans_AcrossAgeBetwnGroup, width=12, file = "empirical_trans_AcrossAgeBetwnGroups.pdf")
#ggsave(trans_AcrossAgeWithinGroup, width=12, file = "empirical_trans_AcrossAgeWithinGroup.pdf")
#ggsave(duration_AcrossAgeBetwnGroups, width=7, file = "empirical_duration_AcrossAgeBetwnGroups.pdf")
#ggsave(duration_AcrossAgeWithinGroup, width=7, file = "empirical_duration_AcrossAgeWithinGroup.pdf")

## SCATTER PLOTS for different metrics against age (years) and behavioral scores
#bind frequency measures with age data
#majorSt1 <- asd_td_freq %>% filter(state == "majorSt1");
#majorSt2 <- asd_td_freq %>% filter(state == "majorSt2");
#minorSt_Combn <- asd_td_freq %>% filter(state == "minorSt_Combn");
#ageAndFreq <- cbind(asd_td_ages, majorSt1_freq = majorSt1$freq, majorSt2_freq = majorSt2$freq, minorSt_Combn_freq = minorSt_Combn$freq)
## remove the OUTLIER age and check. (ASD adult of age 39.1 years.)
#ageAndFreq <- ageAndFreq %>% filter(ageInYears < 39.1)
## scatter plot for age in years vs appearance frequencies
## Major st 1 appear freq
#mapping <- aes(x=ageInYears, y=majorSt1_freq, color=group) 
#ageVsMajorSt1 <- scatterPlotter(ageAndFreq, mapping, mapping, 'lm', 'age in years', 'Major state 1 appearance frequency', TRUE)
## Major st 2 appear freq
#mapping <- aes(x=ageInYears, y=majorSt2_freq, color=group)
#ageVsMajorSt2 <- scatterPlotter(ageAndFreq, mapping, mapping, 'lm', 'age in years', 'Major state 2 appearance frequency', TRUE)
## Minor states (combined) appear freq
#mapping <- aes(x=ageInYears, y=minorSt_Combn_freq, color=group)
#ageVsMinorCombn <- scatterPlotter(ageAndFreq, mapping, mapping, 'lm', 'age in years', 'Minor states (combined) appearance frequency', TRUE)

## now, plots for apperance frequencies along age
#majorSt1AcrossAge <- ageVsMajorSt1 + facet_wrap(~age, scales="free_x", ncol=3)
#majorSt2AcrossAge <- ageVsMajorSt2 + facet_wrap(~age, scales="free_x", ncol=3)
#minorCombnAcrossAge <- ageVsMinorCombn + facet_wrap(~age, scales="free_x", ncol=3) 
## calculate the correlation r and p values for combined data - appearance freq
#for (state in c("majorSt1", "majorSt2", "minorSt_Combn")) {
#      asd_data <- ageAndFreq %>% filter(group=='asd')
#      td_data <- ageAndFreq %>% filter(group=='td')
#      resASD <- cor.test(asd_data$ageInYears,eval(parse(text=sprintf('asd_data$%s_freq', state))))
#      resTD <- cor.test(td_data$ageInYears, eval(parse(text=sprintf('td_data$%s_freq', state))))
#      print(sprintf('(ASD) %s freq vs age. r = %f, p = %f', state, resASD$estimate, resASD$p.value))
#      print(sprintf('(TD) %s freq vs age. r = %f, p = %f', state, resTD$estimate, resTD$p.value))
#}
## calculate the correlation r and p values across age - appearance freq
#for (state in c("majorSt1", "majorSt2", "minorSt_Combn")) {
#  for (ageDiv in c("child", "adolsc", "adult")) {
#      asd_data <- ageAndFreq %>% filter(group=='asd', age==ageDiv)
#      td_data <- ageAndFreq %>% filter(group=='td', age==ageDiv)
#      resASD <- cor.test(asd_data$ageInYears,eval(parse(text=sprintf('asd_data$%s_freq', state))))
#      resTD <- cor.test(td_data$ageInYears, eval(parse(text=sprintf('td_data$%s_freq', state))))
#      print(sprintf('(ASD %s) %s freq vs age. r = %f, p = %f', ageDiv, state, resASD$estimate, resASD$p.value))
#      print(sprintf('(TD %s) %s freq vs age. r = %f, p = %f', ageDiv, state, resTD$estimate, resTD$p.value))
#     }
#}

# save the scatter plots
#ggsave(ageVsMajorSt1, file = "ageReset_empirical_corr_age_majorSt1.pdf")
#ggsave(ageVsMajorSt2, file = "ageReset_empirical_corr_age_majorSt2.pdf")
#ggsave(ageVsMinorCombn, file = "ageReset_empirical_corr_age_minorStCombn.pdf")
## save the across age plots 
#ggsave(majorSt1AcrossAge, width=12, file = "ageReset_acrossAge_empirical_corr_age_majorSt1.pdf")
#ggsave(majorSt2AcrossAge, width=12, file = "ageReset_acrossAge_empirical_corr_age_majorSt2.pdf")
#ggsave(minorCombnAcrossAge, width=12, file = "ageReset_acrossAge_empirical_corr_age_minorStCombn.pdf")

# bind FIQs with appearance frequency data
#fiqAndFreq <- cbind(asd_td_fiqs, majorSt1_freq = majorSt1$freq, majorSt2_freq = majorSt2$freq, minorSt_Combn_freq = minorSt_Combn$freq)
### scatter plot for FIQ vs appearance frequencies
#mapping <- aes(y=FIQ, x=majorSt1_freq, color=group) 
#fiqVsMajorSt1 <- scatterPlotter(fiqAndFreq, mapping, mapping, 'lm', yLabel='FIQ of subjects', xLabel='major state 1 appearance frequency', addPercentXaxis=TRUE)
#mapping <- aes(y=FIQ, x=majorSt2_freq, color=group)
#fiqVsMajorSt2 <- scatterPlotter(fiqAndFreq, mapping, mapping, 'lm', yLabel='FIQ of subjects', xLabel='major state 2 appearance frequency', addPercentXaxis=TRUE)
#mapping <- aes(y=FIQ, x=minorSt_Combn_freq, color=group)
#fiqVsMinorCombn <- scatterPlotter(fiqAndFreq, mapping, mapping, 'lm', yLabel='FIQ of subjects', xLabel='minor states (combined) appearance frequency', addPercentXaxis=TRUE)
### FIQ across age
#fiqMajorSt1AcrossAge <- fiqVsMajorSt1 + facet_wrap(~age, scales="free_x", ncol=3)
#fiqMajorSt2AcrossAge <- fiqVsMajorSt2 + facet_wrap(~age, scales="free_x", ncol=3)
#fiqMinorCombnAcrossAge <- fiqVsMinorCombn + facet_wrap(~age, scales="free_x", ncol=3)
## calculate the correlation for FIQ vs appearance freq
#for (state in c("majorSt1", "majorSt2", "minorSt_Combn")) {
#  for (ageDiv in c("child", "adolsc", "adult")) {
#      asd_data <- fiqAndFreq %>% filter(group=='asd', age==ageDiv)
#      td_data <- fiqAndFreq %>% filter(group=='td', age==ageDiv)
#      resASD <- cor.test(asd_data$FIQ, eval(parse(text=sprintf('asd_data$%s_freq', state))))
#      resTD <- cor.test(td_data$FIQ, eval(parse(text=sprintf('td_data$%s_freq', state))))
#      print(sprintf('(ASD %s) %s freq vs FIQ. r = %f, p = %f', ageDiv, state, resASD$estimate, resASD$p.value))
#      print(sprintf('(TD %s) %s freq vs FIQ. r = %f, p = %f', ageDiv, state, resTD$estimate, resTD$p.value))
#     }
#}
## save the figures for FIQ across age
#ggsave(fiqMajorSt1AcrossAge, width=12, file = "ageReset_acrossAge_empirical_corr_fiq_majorSt1.pdf")
#ggsave(fiqMajorSt2AcrossAge, width=12, file = "ageReset_acrossAge_empirical_corr_fiq_majorSt2.pdf")
#ggsave(fiqMinorCombnAcrossAge, width=12, file = "ageReset_acrossAge_empirical_corr_fiq_minorStCombn.pdf")


## scatter plots for empirical trans frequencies
#bind transition measures with age data
directMjrTrans <- asd_td_trans %>% filter(transType == "direct MajorTrans");
directMnrTrans <- asd_td_trans %>% filter(transType == "direct MinorTrans");
indirMjrTrans <- asd_td_trans %>% filter(transType == "indirect MajorTrans");
#ageAndTrans <- cbind(asd_td_ages, directMjrTrans_freq = directMjrTrans$transFreq, directMnrTrans_freq = directMnrTrans$transFreq, indirMjrTrans_freq = indirMjrTrans$transFreq)
# remove the OUTLIER age and check. (ASD adult of age 39.1 years.)
#ageAndTrans <- ageAndTrans %>% filter(ageInYears < 39.1)
# scatter plot for age in years vs transition frequencies
#mapping <- aes(x=ageInYears, y=directMjrTrans_freq, color=group) 
#ageVsDirMjrTrans <- scatterPlotter(ageAndTrans, mapping, mapping, 'lm', 'age in years', 'Direct transition frequency between major states', TRUE)
#mapping <- aes(x=ageInYears, y=directMnrTrans_freq, color=group)
#ageVsDirMnrTrans <- scatterPlotter(ageAndTrans, mapping, mapping, 'lm', 'age in years', 'Direct transition frequency between minor states', TRUE)
#mapping <- aes(x=ageInYears, y=indirMjrTrans_freq, color=group)
#ageVsIndirMjrTrans <- scatterPlotter(ageAndTrans, mapping, mapping, 'lm', 'age in years', 'Indirect transition frequency between major states', TRUE)
#
### now, plots for transition frequencies along age
#acrossAgeDirMjrTrans <- ageVsDirMjrTrans + facet_wrap(~age, scales="free_x", ncol=3)
#acrossAgeDirMnrTrans <- ageVsDirMnrTrans + facet_wrap(~age, scales="free_x", ncol=3)
#acrossAgeIndirMjrTrans <- ageVsIndirMjrTrans + facet_wrap(~age, scales="free_x", ncol=3) 
## calculate the correlation r and p values combined - trans freq
#for (transType in c("directMjrTrans", "directMnrTrans", "indirMjrTrans")) {
#      asd_data <- ageAndTrans %>% filter(group=='asd')
#      td_data <- ageAndTrans %>% filter(group=='td')
#      resASD <- cor.test(asd_data$ageInYears,eval(parse(text=sprintf('asd_data$%s_freq', transType))))
#      resTD <- cor.test(td_data$ageInYears, eval(parse(text=sprintf('td_data$%s_freq', transType))))
#      print(sprintf('(ASD) %s vs age. r = %f, p = %f', transType, resASD$estimate, resASD$p.value))
#      print(sprintf('(TD) %s vs age. r = %f, p = %f', transType, resTD$estimate, resTD$p.value))
#}

## calculate the correlation r and p values across age - trans freq
#for (transType in c("directMjrTrans", "directMnrTrans", "indirMjrTrans")) {
#   for (ageDiv in c("child", "adolsc", "adult")) {
#      asd_data <- ageAndTrans %>% filter(group=='asd', age==ageDiv)
#      td_data <- ageAndTrans %>% filter(group=='td', age==ageDiv)
#      resASD <- cor.test(asd_data$ageInYears,eval(parse(text=sprintf('asd_data$%s_freq', transType))))
#      resTD <- cor.test(td_data$ageInYears, eval(parse(text=sprintf('td_data$%s_freq', transType))))
#      print(sprintf('(ASD %s) %s vs age. r = %f, p = %f', ageDiv, transType, resASD$estimate, resASD$p.value))
#      print(sprintf('(TD %s) %s vs age. r = %f, p = %f', ageDiv, transType, resTD$estimate, resTD$p.value))
#   }
#}

# save the scatter plots
#ggsave(ageVsDirMjrTrans, file = "ageReset_empirical_corr_age_DirMjrTrans.pdf")
#ggsave(ageVsDirMnrTrans, file = "ageReset_empirical_corr_age_DirMnrTrans.pdf")
#ggsave(ageVsIndirMjrTrans, file = "ageReset_empirical_corr_age_IndirMjrTrans.pdf")
#ggsave(acrossAgeDirMjrTrans, width=12, file = "acrossAge_empirical_corr_age_DirMjrTrans.pdf")
#ggsave(acrossAgeDirMnrTrans, width=12, file = "acrossAge_empirical_corr_age_DirMnrTrans.pdf")
#ggsave(acrossAgeIndirMjrTrans, width=12, file = "acrossAge_empirical_corr_age_IndirMjrTrans.pdf")

## bind FIQ with transition frequencies
#fiqAndTrans <- cbind(asd_td_fiqs, directMjrTrans_freq = directMjrTrans$transFreq, directMnrTrans_freq = directMnrTrans$transFreq, indirMjrTrans_freq = indirMjrTrans$transFreq)
# scatter plot for FIQ vs transition frequencies
#mapping <- aes(y=FIQ, x=directMjrTrans_freq, color=group) 
#fiqVsDirMjrTrans <- scatterPlotter(fiqAndTrans, mapping, mapping, 'lm', y='FIQ of subjects', x='direct trans freq between major states', addPercentXaxis=TRUE)
#mapping <- aes(y=FIQ, x=directMnrTrans_freq, color=group)
#fiqVsDirMnrTrans <- scatterPlotter(fiqAndTrans, mapping, mapping, 'lm', y='FIQ of subjects', x='direct trans freq between minor states', addPercentXaxis=TRUE)
#mapping <- aes(y=FIQ, x=indirMjrTrans_freq, color=group)
#fiqVsIndirMjrTrans <- scatterPlotter(fiqAndTrans, mapping, mapping, 'lm', y='FIQ of subjects', x='indirect trans freq between major states', addPercentXaxis=TRUE)
#
##fiq vs transitions across age
#fiqDirMjrTransAcrossAge <- fiqVsDirMjrTrans + facet_wrap(~age, scales="free_x", ncol=3)
#fiqDirMnrTransAcrossAge <- fiqVsDirMnrTrans + facet_wrap(~age, scales="free_x", ncol=3)
#fiqIndirMjrTransAcrossAge <- fiqVsIndirMjrTrans + facet_wrap(~age, scales="free_x", ncol=3)
## calculate the correlation r and p values FIQ vs trans freq
#for (transType in c("directMjrTrans", "directMnrTrans", "indirMjrTrans")) {
#   for (ageDiv in c("child", "adolsc", "adult")) {
#      asd_data <- fiqAndTrans %>% filter(group=='asd', age==ageDiv)
#      td_data <- fiqAndTrans %>% filter(group=='td', age==ageDiv)
#      resASD <- cor.test(asd_data$FIQ,eval(parse(text=sprintf('asd_data$%s_freq', transType))))
#      resTD <- cor.test(td_data$FIQ, eval(parse(text=sprintf('td_data$%s_freq', transType))))
#      print(sprintf('(ASD %s) %s vs FIQ. r = %f, p = %f', ageDiv, transType, resASD$estimate, resASD$p.value))
#      print(sprintf('(TD %s) %s vs FIQ. r = %f, p = %f', ageDiv, transType, resTD$estimate, resTD$p.value))
#   }
#}
# 
### save the plots
#ggsave(fiqDirMjrTransAcrossAge , width=12, file = "acrossAge_empirical_corr_fiq_DirMjrTrans.pdf")
#ggsave(fiqDirMnrTransAcrossAge , width=12, file = "acrossAge_empirical_corr_fiq_DirMnrTrans.pdf")
#ggsave(fiqIndirMjrTransAcrossAge , width=12, file = "acrossAge_empirical_corr_fiq_IndirMjrTrans.pdf")

## scatter plots for duration of major states in subjects.  
#ageAndDuration <- cbind(asd_td_ages, duration = asd_td_duration$duration)
## remove the OUTLIER age and check. (ASD adult of age 39.1 years.)
#ageAndDuration <- ageAndDuration %>% filter(ageInYears < 39.1)
## remove the OUTLIER duration and check. (ASD adult with duration as 37.6667)
#ageAndDuration <- ageAndDuration %>% filter(duration < 37)
#
##scatter plot 
#mapping <- aes(x=ageInYears, y=duration, color=group)
#ageVsDuration <- scatterPlotter(ageAndDuration, mapping, mapping, 'lm', 'age in years', 'Duration of major states', FALSE)
#acrossAgeDuration <- ageVsDuration + facet_wrap(~age, scales="free_x", ncol=3)
# 
### calculate the correlation r and p values - duration of major states
#asd_data <- ageAndDuration %>% filter(group=='asd')
#td_data <- ageAndDuration %>% filter(group=='td')
#resASD <- cor.test(asd_data$ageInYears,asd_data$duration)
#resTD <- cor.test(td_data$ageInYears, td_data$duration)
#print(sprintf('(ASD) duration vs age. r = %f, p = %f', resASD$estimate, resASD$p.value))
#print(sprintf('(TD) duration vs age. r = %f, p = %f', resTD$estimate, resTD$p.value))

## calculate the correlation r and p values (across age) - duration of major states
#for (ageDiv in c("child", "adolsc", "adult")) {
#	asd_data <- ageAndDuration %>% filter(group=='asd', age==ageDiv)
#	td_data <- ageAndDuration %>% filter(group=='td', age==ageDiv)
#	resASD <- cor.test(asd_data$ageInYears,asd_data$duration)
#	resTD <- cor.test(td_data$ageInYears, td_data$duration)
#	print(sprintf('(ASD %s) duration vs age. r = %f, p = %f', ageDiv, resASD$estimate, resASD$p.value))
#	print(sprintf('(TD %s) duration vs age. r = %f, p = %f', ageDiv, resTD$estimate, resTD$p.value))
#}
## save the duration scatter plot
#ggsave(ageVsDuration, file = "ageDurationReset_empiricial_corr_age_duration.pdf");
#ggsave(acrossAgeDuration, width = 12, file = "ageDurationReset_acrossAge_empiricial_corr_age_duration.pdf");

## bind FIQ with duration
#fiqAndDuration <- cbind(asd_td_fiqs, duration = asd_td_duration$duration)
## remove the OUTLIER duration and check. (ASD adult with duration as 37.6667)
#fiqAndDuration <- fiqAndDuration %>% filter(duration < 37)
##scatter plot 
#mapping <- aes(y=FIQ, x=duration, color=group)
#fiqVsDuration <- scatterPlotter(fiqAndDuration, mapping, mapping, 'lm', xLabel='duration of major states', yLabel='FIQ')
#acrossAgeFIQandDuration <- fiqVsDuration + facet_wrap(~age, scales="free_x", ncol=3)
## calculate the correlation r and p values - FIQ vs duration of major states
#for (ageDiv in c("child", "adolsc", "adult")) {
#	asd_data <- fiqAndDuration %>% filter(group=='asd', age==ageDiv)
#	td_data <- fiqAndDuration %>% filter(group=='td', age==ageDiv)
#	resASD <- cor.test(asd_data$FIQ, asd_data$duration)
#	resTD <- cor.test(td_data$FIQ, td_data$duration)
#	print(sprintf('(ASD %s) duration vs FIQ. r = %f, p = %f', ageDiv, resASD$estimate, resASD$p.value))
#	print(sprintf('(TD %s) duration vs FIQ. r = %f, p = %f', ageDiv, resTD$estimate, resTD$p.value))
#}
## save the scatter plot
#ggsave(acrossAgeFIQandDuration, width = 12, file = "acrossAge_durationReset_empiricial_corr_fiq_duration.pdf");

### NOTE: BELOW Section for plotting and analysis of MODEL data. #####
asd_td_bsnSzModel <- read.table('~/Documents/asd_td_basinSize_forR_model.csv', header=T, sep=",")
asd_td_bsnSzModelCombn <- read.table('~/Documents/asd_td_basinSizeCombn_forR_model.csv', header=T, sep=",")
#asd_td_durationModel <- read.table('~/Documents/asd_td_duration_forR_model.csv', header=T, sep=",")
asd_td_transModel <- read.table('~/Documents/asd_td_trans_forR_model.csv', header=T, sep=",")
#asd_td_freqsModel <- read.table('~/Documents/asd_td_freqs_forR_model.csv', header=T, sep=",")
#### mutate relevant data fields
#asd_td_freqsModel <- asd_td_freqsModel %>% mutate(freq = freq *100) # turn into percentage
asd_td_transModel <- asd_td_transModel %>% mutate(transFreq = transFreq *100) # turn into percentage
#### set the age factor to chronological order.
asd_td_bsnSzModel$age <- factor(asd_td_bsnSzModel$age, levels = c("child", "adolsc", "adult"))
asd_td_bsnSzModelCombn$age <- factor(asd_td_bsnSzModelCombn$age, levels = c("child", "adolsc", "adult"))
#asd_td_durationModel$age <- factor(asd_td_durationModel$age, levels = c("child", "adolsc", "adult"))
asd_td_transModel$age <- factor(asd_td_transModel$age, levels = c("child", "adolsc", "adult"))
#asd_td_freqsModel$age <- factor(asd_td_freqsModel$age, levels = c("child", "adolsc", "adult"))

### plot basin size for model.
basinSzCombn_AcrossAgeWithinGroup <- barPlotterAcrossAgeWithinGroup(asd_td_bsnSzModelCombn, aes(x=basin, y=basinSize), "basins", "basin sizes in model", TRUE, expand_limits(y=100))
#basinSz_AcrossAgeWithinGroup <- barPlotterAcrossAgeWithinGroup(asd_td_bsnSzModel, aes(x=basin, y=basinSize), "basins", "basin sizes in model", TRUE, expand_limits(y=60))
#basinSz_AcrossAgeBetwnGroup <- barPlotterAcrossAgeBetwnGroup(asd_td_bsnSzModel, aes(x=basin, y=basinSize), "basins", "basin sizes in model", TRUE)
### stats for model basin size
## across age - between ASD and TD
#for (age in c("child", "adolsc", "adult")) {
#   asd_group <- c(); td_group <- c();
#   asd_major = 0; td_major = 0;
#   for (basin in c("Major st 1", "Major st 2", "Minor st (grouped)")) {
#      asd_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='%s',basin=='%s',group=='ASD')", age, basin)))
#      td_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='%s',basin=='%s',group=='TD')", age, basin)))
#      asd_group <- c(asd_group, asd_data$basinSize)
#      td_group <- c(td_group, td_data$basinSize)
#      if (grepl("Major", basin, fixed=TRUE)) { # use major states
#        asd_major = asd_major + asd_data$basinSize
#        td_major = td_major + td_data$basinSize
#      }
#      #N = 128/100; # total number of basins / 100 to normalise	
#      #stats = prop.test(x=c(round(asd_data$basinSize*N), round(td_data$basinSize*N)),c(128,128) , correct=FALSE)
#      #print(sprintf("(ASD vs TD) %s - %s. chi2 = %f, p = %f", age, basin, stats$statistic, stats$p.value))
#   }
#   N = 128/100; # total number of basins / 100 to normalise	
#   stats = prop.test(x=c(round(asd_major*N), round(td_major*N)),c(128,128) , correct=FALSE)
#   print(sprintf("(ASD vs TD) %s - majorSt (combined). chi2 = %f, p = %f", age, stats$statistic, stats$p.value))
#
#   #stats = chisq.test(asd_group, p = td_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   #print(sprintf("(ASD vs TD) basin size distrib %s. chi2 = %f, p = %f", age, stats$statistic, stats$p.value))
#}
## for individual proportions
### stats for model basin size - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("ASD", "TD")) {
#   print(sprintf("model basin size stats for group %s", group))
#   # each of these age groups will contain all minima's basin sizes for each iteration (ASD, TD) 
#   child_group <- c(); adolsc_group <- c(); adult_group <- c();
#   combinedMjrState_child = 0; combinedMjrState_adolsc = 0; combinedMjrState_adult = 0;
#   for (basin in c("Major st 1", "Major st 2", "Minor st (grouped)")) {	
#     child_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='child',basin=='%s',group=='%s')", basin, group)))
#     adolsc_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='adolsc',basin=='%s',group=='%s')", basin, group)))
#     adult_data = eval(parse(text=sprintf("asd_td_bsnSzModel %%>%% filter(age=='adult',basin=='%s',group=='%s')", basin, group)))
#     #print(sprintf('child = %f, adolsc = %f, adult = %f', child_data$basinSize, adolsc_data$basinSize, adult_data$basinSize))
#     child_group <- c(child_group, child_data$basinSize)
#     adolsc_group <- c(adolsc_group, adolsc_data$basinSize)
#     adult_group <- c(adult_group, adult_data$basinSize)
#     N = 128/100; # total number of basins / 100 to get the actual number of basins	
#     if (grepl("Major", basin, fixed=TRUE)) { # use major states
#       combinedMjrState_child = combinedMjrState_child + child_data$basinSize
#       combinedMjrState_adolsc = combinedMjrState_adolsc + adolsc_data$basinSize
#       combinedMjrState_adult = combinedMjrState_adult + adult_data$basinSize
#     }
##    # child vs adolsc
##    stats = prop.test(x=c(round(child_data$basinSize*N), round(adolsc_data$basinSize*N)), c(128,128), correct=FALSE)
##    print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child","adolsc", basin, stats$statistic, stats$p.value))
##    # adolsc vs adult
##    stats = prop.test(x=c(round(adolsc_data$basinSize*N), round(adult_data$basinSize*N)), c(128,128), correct=FALSE)
##    print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "adolsc", "adult", basin, stats$statistic, stats$p.value))     
##    # child vs adult
##    stats = prop.test(x=c(round(child_data$basinSize*N), round(adult_data$basinSize*N)), c(128,128), correct=FALSE)
##    print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child", "adult", basin, stats$statistic, stats$p.value))
#}
## combined major state basin size - individual proportion test along age.
#    # child vs adolsc
#    stats = prop.test(x=c(round(combinedMjrState_child*N), round(combinedMjrState_adolsc*N)), c(128,128), correct=FALSE)
#    print(sprintf("(%s vs %s) combnd Major State. chi2 = %f, p = %f", "child","adolsc",  stats$statistic, stats$p.value))
#    # adolsc vs adult
#    stats = prop.test(x=c(round(combinedMjrState_adolsc*N), round(combinedMjrState_adult*N)), c(128,128), correct=FALSE)
#    print(sprintf("(%s vs %s) combnd Major State. chi2 = %f, p = %f", "adolsc", "adult",  stats$statistic, stats$p.value))     
#    # child vs adult
#    stats = prop.test(x=c(round(combinedMjrState_child*N), round(combinedMjrState_adult*N)), c(128,128), correct=FALSE)
#    print(sprintf("(%s vs %s) combnd Major State. chi2 = %f, p = %f", "child", "adult",  stats$statistic, stats$p.value))
#
#}
### between group test
#   # child vs adolsc
#   stats = chisq.test(adolsc_group, p=child_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - child vs adolsc) basin size distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
# # adolsc vs adult
#   stats = chisq.test(adult_group, p = adolsc_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - adolsc vs adult) basin size distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
#  # child vs adult
#   stats = chisq.test(adult_group, p=child_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - child vs adult) basin size distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
#}

#
#### plot trans for model
#trans_AcrossAgeBetwnGroup <- barPlotterAcrossAgeBetwnGroup(asd_td_transModel, aes(x=transType, y=transFreq), "transitions", "transition frequencies in model", TRUE) + expand_limits(y=17.5)
#trans_AcrossAgeWithinGroup <- barPlotterAcrossAgeWithinGroup(asd_td_transModel, aes(x=transType, y=transFreq), "transitions", "transition frequencies in model", TRUE) + expand_limits(y=17.5)
 
## stats for trans in model
#for (age in c("child", "adolsc", "adult")) {
#   asd_group <- c(); td_group <- c();
#   for (transType in c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")) {
#      asd_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='%s',transType=='%s',group=='ASD')", age, transType)))
#      td_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='%s',transType=='%s',group=='TD')", age, transType)))
#      asd_group = c(asd_group, asd_data$transFreq);
#      td_group = c(td_group, td_data$transFreq);
#      #print(sprintf('asd= %f, td=%f', asd_data$transFreq, td_data$transFreq))
#      #stats = prop.test(x=c(asd_data$transFreq, td_data$transFreq), n=c(100,100), correct=FALSE)
#      stats = prop.test(x=c(asd_data$transFreq*1000, td_data$transFreq*1000), n=c(10^5,10^5), correct=FALSE)
#      print(sprintf("(ASD vs TD) %s - %s. chi2 = %f, p = %f", age, transType, stats$statistic, stats$p.value))
#   }
#   stats = chisq.test(c(asd_group, 100-sum(asd_group)), p = c(td_group, 100-sum(td_group)), rescale.p = TRUE); #rescale to set sum of p to 1.
#   #print(sprintf("(ASD vs TD) transition freq distrib %s. chi2 = %f, p = %f", age, stats$statistic, stats$p.value))
#}

## stats for model trans freq - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("ASD", "TD")) {
#   print(sprintf("transition stats for group %s", group))
#   child_group <- c(); adolsc_group <- c(); adult_group <- c();
#   for (transType in c("direct MajorTrans", "direct MinorTrans", "indirect MajorTrans")) {
#	
#     child_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='child',transType=='%s',group=='%s')", transType, group)))
#     adolsc_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='adolsc',transType=='%s',group=='%s')", transType, group)))
#     adult_data = eval(parse(text=sprintf("asd_td_transModel %%>%% filter(age=='adult',transType=='%s',group=='%s')", transType, group)))
#     child_group <- c(child_group, child_data$transFreq)
#     adolsc_group <- c(adolsc_group, adolsc_data$transFreq)
#     adult_group <- c(adult_group, adult_data$transFreq)
#
#     #print(sprintf('child = %f, adolsc = %f, adult = %f', child_data$basinSize, adolsc_data$basinSize, adult_data$basinSize))
#     # child vs adolsc
#     #stats = prop.test(x=c(child_data$transFreq, adolsc_data$transFreq), n=c(100,100), correct=FALSE)
#     stats = prop.test(x=c(child_data$transFreq*1000, adolsc_data$transFreq*1000), n=c(10^5,10^5), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child","adolsc", transType, stats$statistic, stats$p.value))
#
#     ## adolsc vs adult
#     #stats = prop.test(x=c(adolsc_data$transFreq, adult_data$transFreq), n=c(100,100), correct=FALSE)
#     stats = prop.test(x=c(adolsc_data$transFreq*1000, adult_data$transFreq*1000), n=c(10^5,10^5), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "adolsc", "adult", transType, stats$statistic, stats$p.value))
#     #
#     ## child vs adult
#     #stats = prop.test(x=c(child_data$transFreq, adult_data$transFreq), n=c(100,100), correct=FALSE)
#     stats = prop.test(x=c(child_data$transFreq*1000, adult_data$transFreq*1000), n=c(10^5,10^5), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child", "adult", transType, stats$statistic, stats$p.value))
#}
### distribution difference between age within a group.
#   ## add remaining percentage of transitions to ensure the sum goes to 100.
#   child_group <- c(child_group, 100-sum(child_group))
#   adolsc_group <- c(adolsc_group, 100-sum(adolsc_group))
#   adult_group <- c(adult_group, 100-sum(adult_group))
#   # child vs adolsc
#   stats = chisq.test(adolsc_group*1000, p=child_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - child vs adolsc) appear freq distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
# # adolsc vs adult
#   stats = chisq.test(adult_group*1000, p = adolsc_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - adolsc vs adult) appear freq distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
#  # child vs adult
#   stats = chisq.test(adult_group*1000, p=child_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - child vs adult) appear freq distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
#}

### plot appearance freq for model
#freq_AcrossAgeBetwnGroup <- barPlotterAcrossAgeBetwnGroup(asd_td_freqsModel, aes(x=state, y=freq), "state", "appearance frequencies in model", TRUE)
#freq_AcrossAgeWithinGroup <- barPlotterAcrossAgeWithinGroup(asd_td_freqsModel, aes(x=state, y=freq), "state", "appearance frequencies in model", TRUE, expand_limits(y=55))
## stat for model appearance frequencies
#for (age in c("child", "adolsc", "adult")) {
#   asd_prop <- c(); td_prop <- c();
#   for (state in c("Major st 1", "Major st 2", "Minor st (grouped)")) {
#      asd_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='%s',state=='%s',group=='ASD')", age, state)))
#      td_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='%s',state=='%s',group=='TD')", age, state)))
#      
#      #stats = prop.test(x=c(asd_data$freq, td_data$freq), n=c(100,100), correct=FALSE)
#      stats = prop.test(x=c(asd_data$freq*1000, td_data$freq*1000), n=c(10^5,10^5), correct=FALSE)
#      print(sprintf("(ASD vs TD) %s - %s. chi2 = %f, p = %f", age, state, stats$statistic, stats$p.value))
#      asd_prop <- c(asd_prop, asd_data$freq)
#      td_prop <- c(td_prop, td_data$freq)
#   }
#   stats = chisq.test(asd_prop, p = td_prop, rescale.p = TRUE); #rescale to set sum of p to 1.
#   #stats = chisq.test(asd_prop*1000, p = td_prop, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(ASD vs TD) appear freq distrib %s. chi2 = %f, p = %f", age, stats$statistic, stats$p.value))
#}

### stats for model appearance freq - within groups (asd and td) a) child vs adolsc, b) adolsc vs adult, c) child vs adult
#for (group in c("ASD", "TD")) {
#   print(sprintf("appearance freq stats for group %s", group))
#   child_group <- c(); adolsc_group <- c(); adult_group <- c();
#
#   for (state in c("Major st 1", "Major st 2", "Minor st (grouped)")) {
#     child_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='child',state=='%s',group=='%s')", state, group)))
#     adolsc_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='adolsc',state=='%s',group=='%s')", state, group)))
#     adult_data = eval(parse(text=sprintf("asd_td_freqsModel %%>%% filter(age=='adult',state=='%s',group=='%s')", state, group)))
#     #print(sprintf('child = %f, adolsc = %f, adult = %f', child_data$basinSize, adolsc_data$basinSize, adult_data$basinSize))
#     child_group <- c(child_group, child_data$freq)
#     adolsc_group <- c(adolsc_group, adolsc_data$freq)
#     adult_group <- c(adult_group, adult_data$freq)
#     # child vs adolsc
#     #stats = prop.test(x=c(child_data$freq*1000, adolsc_data$freq*1000), n=c(10^5,10^5), correct=FALSE)
#     stats = prop.test(x=c(child_data$freq, adolsc_data$freq), n=c(100,100), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child","adolsc", state, stats$statistic, stats$p.value))
#
#     # adolsc vs adult
#      #stats = prop.test(x=c(adolsc_data$freq*1000, adult_data$freq*1000), n=c(10^5,10^5), correct=FALSE)
#     stats = prop.test(x=c(adolsc_data$freq, adult_data$freq), n=c(100,100), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "adolsc", "adult", state, stats$statistic, stats$p.value))
#     
#     # child vs adult
#     #stats = prop.test(x=c(child_data$freq*1000, adult_data$freq*1000), n=c(10^5,10^5), correct=FALSE)
#     stats = prop.test(x=c(child_data$freq, adult_data$freq), n=c(100,100), correct=FALSE)
#     print(sprintf("(%s vs %s) %s. chi2 = %f, p = %f", "child", "adult", state, stats$statistic, stats$p.value))
#}
#}
### distribution difference between age within a group.
#   # child vs adolsc
#   stats = chisq.test(adolsc_group, p=child_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - child vs adolsc) appear freq distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
# # adolsc vs adult
#   stats = chisq.test(adult_group, p = adolsc_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - adolsc vs adult) appear freq distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
#  # child vs adult
#   stats = chisq.test(adult_group, p=child_group, rescale.p = TRUE); #rescale to set sum of p to 1.
#   print(sprintf("(%s - child vs adult) appear freq distrib. chi2 = %f, p = %f", group, stats$statistic, stats$p.value))
#}

## plot duration for model
#dodgeWidth <- 0.75;
#duration_AcrossAgeBetwnGroup <- ggplot(data=asd_td_durationModel, aes(x=age, y=duration)) + 
#	geom_col(aes(fill=group), position=position_dodge(width=dodgeWidth), alpha=0.7, width=0.7) + 
#	geom_errorbar(aes(color=group, ymin=duration, ymax=duration+std), position=position_dodge(width=dodgeWidth), alpha=0.7, width=0.2, size=0.3) +	
#	ylab("major state duration in random walk")
#
#duration_AcrossAgeWithinGroup <- ggplot(data=asd_td_durationModel, aes(x=group, y=duration )) + 
#	#geom_violin(alpha=0.7) +
#	geom_col(aes(fill=age), position=position_dodge(width=dodgeWidth), alpha=0.7, width=0.7) +
#	geom_errorbar(aes(color=age, ymin=duration, ymax=duration+std), position=position_dodge(width=dodgeWidth), alpha=0.7, width=0.2, size=0.3) +	
#	ylab("major state duration in random walk")

## stats for duration - find in complementary Matlab code (plotGenerator.m) which already has t-tests for duration.

## save the plots 
#ggsave(freq_AcrossAgeBetwnGroup, width=12, file = "model_freq_AcrossAgeBetwnGroups.pdf")
#ggsave(freq_AcrossAgeWithinGroup, width=12, file = "model_freq_AcrossAgeWithinGroup.pdf")
#ggsave(trans_AcrossAgeBetwnGroup, width=12, file = "model_trans_AcrossAgeBetwnGroups.pdf")
#ggsave(trans_AcrossAgeWithinGroup, width=12, file = "model_trans_AcrossAgeWithinGroup.pdf")
#ggsave(basinSz_AcrossAgeBetwnGroup, width=12, file = "model_basinSz_AcrossAgeBetwnGroups.pdf")
#ggsave(basinSzCombn_AcrossAgeWithinGroup, width=10, file = "model_basinSzCombn_AcrossAgeWithinGroup.pdf")
#ggsave(basinSz_AcrossAgeWithinGroup, width=12, file = "model_basinSz_AcrossAgeWithinGroup.pdf")
#ggsave(duration_AcrossAgeBetwnGroup, width=7, file = "model_duration_AcrossAgeBetwnGroups.pdf")
#ggsave(duration_AcrossAgeWithinGroup, width=7, file = "model_duration_AcrossAgeWithinGroup.pdf")

