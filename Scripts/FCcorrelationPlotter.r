# this code file is to make correlation plots for FC gaps in minor state and major state modules.
# FC gap in minor state modules against (a) minorStCombined appear freq, (b) indirect trans freq, (c) direct minor trans freq, (d) ADOS total, (e) FIQ
# FC gap in major state modules against (a) combn major st freq, (b) major state duration, (c) direct major st trans, (d) ADOS total. (e) FIQ
# we will do it for both ASD and TD and then filter the results

# NOTE: OUTLIER removal has been used in case of ASD adult with duration as 37.667 
library(tidyverse)
library(grid)
library(gridExtra) # for adding multiple plots in the same figure
library(broom)
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
# ADOS score - some values are NaN
asd_ados <- read.table('~/Documents/asd_td_adosTotal_forR_empirical.csv', header=T, sep=",")
asd_ados$age <- factor(asd_ados$age, levels = c("child", "adolsc", "adult"))

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
asd_combn_data <- tibble(group = asd_fiqs$group,
			 age = asd_fiqs$age,
			 FIQ = asd_fiqs$FIQ,
			 majorStCombnFreq = asd_major_combn$majorStCombnFreq,
			 minorStCombnFreq = asd_minorSt_combn$freq,
			 duration = asd_duration$duration,
			 indirectMjrTrans = asd_indirect_trans$transFreq,
			 directMnrTrans = asd_direct_minorTrans$transFreq,
			 directMjrTrans = asd_direct_majorTrans$transFreq,
			 ADOS_TOTAL = asd_ados$ADOS_TOTAL  # ADOS score for ASD
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

# Section VI. start with plotting correlation. 
## Major st
# Section VI (a) - ASD
# appear freq - major state combined
mapping <- aes(x=majorStGap, y=majorStCombnFreq, color=group)
scatter.asd_majorSt_Gap_Freq <- scatterPlotter(asd_combn_majorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | major states', 'major state freq (combined)', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))
# duration of major states.
mapping <- aes(x=majorStGap, y=duration, color=group)
scatter.asd_majorSt_Gap_Duration <- scatterPlotter(asd_combn_majorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | major states', 'duration of major states', FALSE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))
# FIQ
mapping <- aes(x=majorStGap, y=FIQ, color=group)
scatter.asd_majorSt_Gap_FIQ <- scatterPlotter(asd_combn_majorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | major states', 'FIQ', FALSE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))
# ADOS TOTAL - 12 ASD child and 20 ASD adolsc have missing ADOS_TOTAL values. (both groups are from ABIDE I UniMichigan)
mapping <- aes(x=majorStGap, y=ADOS_TOTAL, color=group)
scatter.asd_majorSt_Gap_ADOS <- scatterPlotter(asd_combn_majorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | major states', 'ADOS', FALSE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))

# Section VI (b) - TD. #6290c1 is light blue color.
# appear freq - major state combined
mapping <- aes(x=majorStGap, y=majorStCombnFreq, color=group)
scatter.td_majorSt_Gap_Freq <- scatterPlotter(td_combn_majorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | major states', 'major st freq (combined)', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# duration of major states.
mapping <- aes(x=majorStGap, y=duration, color=group)
scatter.td_majorSt_Gap_Duration <- scatterPlotter(td_combn_majorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | major states', 'duration of major states', FALSE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# FIQ
mapping <- aes(x=majorStGap, y=FIQ, color=group)
scatter.td_majorSt_Gap_FIQ <- scatterPlotter(td_combn_majorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | major states', 'FIQ', FALSE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# Section VI(c) - major st FC gap - calculate correlation for ASD and TD.
#for (group in c("asd", "td")) {
#  for (ageDiv in c("child", "adolsc", "adult")) {
#   data <- eval(parse(text=sprintf('%s_combn_majorSt_gap', group))) %>% filter(age == ageDiv)
#   for (interest in c("ADOS_TOTAL", "majorStCombnFreq", "duration", "FIQ", "indirectMjrTrans", "directMnrTrans")) {
#         if (group == "td" && interest=="ADOS_TOTAL") { # not relevant, skip
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
## Section VII. Minor st. CAUTION - isolated networks which don't form modules have been removed.
# ASD
# combined appear freq of minor states
mapping <- aes(x=minorStGap, y=minorStCombnFreq, color=group)
scatter.asd_minorSt_Gap_Freq <- scatterPlotter(asd_combn_minorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states | ASD', 'minor state freq (combined)', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))
# indirect major trans freq
mapping <- aes(x=minorStGap, y=indirectMjrTrans, color=group)
scatter.asd_minorSt_Gap_indirMjrTrans <- scatterPlotter(asd_combn_minorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states | ASD', 'indirect trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))
# direct minor trans freq
mapping <- aes(x=minorStGap, y=directMnrTrans, color=group)
scatter.asd_minorSt_Gap_dirMnrTrans <- scatterPlotter(asd_combn_minorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states | ASD', 'direct trans freq between minor states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))
# FIQ
mapping <- aes(x=minorStGap, y=FIQ, color=group)
scatter.asd_minorSt_Gap_dirMnrTrans <- scatterPlotter(asd_combn_minorSt_gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states | ASD', 'FIQ', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))

# ADOS Total - 12 ASD child and 20 ASD adolsc have missing ADOS_TOTAL values. (both groups are from ABIDE I UniMichigan) 
# NOTE: TBD: (a) correlation code (b) need to consider other scores like ADOS_RRB, SOCIAL BEHAVIOR etc
# minor st FC gap - calculate correlation for ASD.
#NOTE: need to add ADOS scores also for correlation.
 for (ageDiv in c("child", "adolsc", "adult")) {
   data <- asd_combn_minorSt_gap %>% filter(age == ageDiv)
   for (interest in c("minorStCombnFreq", "indirectMjrTrans", "directMnrTrans", "FIQ")) {
         dataOfInterest <- eval(parse(text=sprintf("data$%s", interest)))
	 res <- cor.test(data$minorStGap, dataOfInterest)
	 if (res$p.value <= 0.05) {
		signif_star = "***"
	 } else {
		signif_star = ""
	 }
	 print(sprintf('%s (ASD %s) minorSt FCGap vs %s. r = %f, p = %f', signif_star, ageDiv, interest, res$estimate, res$p.value))
      } 
   }


# TD - all age groups to be treated individually. ONLY those modules considered where networks segregate as anti-correlated.
# (a) child - only minorSt_1-4 is to be considered.
# combined appear freq of minor states
mapping <- aes(x=minorStGap, y=minorStCombnFreq, color=group)
scatter.td_child_minorSt2_Gap_Freq <- scatterPlotter(td_child_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'minor state freq (combined)', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# indirect major trans freq
mapping <- aes(x=minorStGap, y=indirectMjrTrans, color=group)
scatter.td_child_minorSt2_Gap_indirMjrTrans <- scatterPlotter(td_child_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'indirect trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct minor trans freq
mapping <- aes(x=minorStGap, y=directMnrTrans, color=group)
scatter.td_child_minorSt2_Gap_dirMnrTrans <- scatterPlotter(td_child_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between minor states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct major trans freq
mapping <- aes(x=minorStGap, y=directMjrTrans, color=group)
scatter.td_child_minorSt2_Gap_dirMjrTrans <- scatterPlotter(td_child_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# FIQ
mapping <- aes(x=minorStGap, y=FIQ, color=group)
scatter.td_child_minorSt2_Gap_FIQ <- scatterPlotter(td_child_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'FIQ', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# combine the TD child plots
td_child_minorSt_plots <- arrangeGrob(scatter.td_child_minorSt2_Gap_Freq,
				    scatter.td_child_minorSt2_Gap_indirMjrTrans,
				    scatter.td_child_minorSt2_Gap_dirMnrTrans,
				    scatter.td_child_minorSt2_Gap_dirMjrTrans,
				    scatter.td_child_minorSt2_Gap_FIQ,
				    nrow=3, ncol=3,
				    top=textGrob("TD child modules | minor st A-D",gp=gpar(fontsize=18,font=3)))
# (b) adolsc - minorSt_2-5 (td_adolsc_minorSt2_Gap) and minorSt_1-6 (td_adolsc_minorSt3_Gap) are to be considered.
# adolsc - td_adolsc_minorSt2_Gap 
# minor st combn frequency 
mapping <- aes(x=minorStGap, y=minorStCombnFreq, color=group)
scatter.td_adolsc_minorSt2_Gap_Freq <- scatterPlotter(td_adolsc_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'minor state freq (combined)', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# indirect major trans freq
mapping <- aes(x=minorStGap, y=indirectMjrTrans, color=group)
scatter.td_adolsc_minorSt2_Gap_indirMjrTrans <- scatterPlotter(td_adolsc_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'indirect trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct minor trans freq
mapping <- aes(x=minorStGap, y=directMnrTrans, color=group)
scatter.td_adolsc_minorSt2_Gap_dirMnrTrans <- scatterPlotter(td_adolsc_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between minor states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct major trans freq
mapping <- aes(x=minorStGap, y=directMjrTrans, color=group)
scatter.td_adolsc_minorSt2_Gap_dirMjrTrans <- scatterPlotter(td_adolsc_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# FIQ
mapping <- aes(x=minorStGap, y=FIQ, color=group)
scatter.td_adolsc_minorSt2_Gap_FIQ <- scatterPlotter(td_adolsc_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'FIQ', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# combine the TD adolsc plots for minorSt2
td_adolsc_minorSt2_plots <- arrangeGrob(scatter.td_adolsc_minorSt2_Gap_Freq,
				    scatter.td_adolsc_minorSt2_Gap_indirMjrTrans,
				    scatter.td_adolsc_minorSt2_Gap_dirMnrTrans,
				    scatter.td_adolsc_minorSt2_Gap_dirMjrTrans,
				    scatter.td_adolsc_minorSt2_Gap_FIQ,
				    nrow=3, ncol=3,
				    top=textGrob("TD adolsc modules | minor st B-E",gp=gpar(fontsize=18,font=3)))
# adolsc - td_adolsc_minorSt3_Gap 
# minor st combn frequency 
mapping <- aes(x=minorStGap, y=minorStCombnFreq, color=group)
scatter.td_adolsc_minorSt3_Gap_Freq <- scatterPlotter(td_adolsc_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'minor state freq (combined)', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# indirect major trans freq
mapping <- aes(x=minorStGap, y=indirectMjrTrans, color=group)
scatter.td_adolsc_minorSt3_Gap_indirMjrTrans <- scatterPlotter(td_adolsc_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'indirect trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct minor trans freq
mapping <- aes(x=minorStGap, y=directMnrTrans, color=group)
scatter.td_adolsc_minorSt3_Gap_dirMnrTrans <- scatterPlotter(td_adolsc_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between minor states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct major trans freq
mapping <- aes(x=minorStGap, y=directMjrTrans, color=group)
scatter.td_adolsc_minorSt3_Gap_dirMjrTrans <- scatterPlotter(td_adolsc_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# FIQ
mapping <- aes(x=minorStGap, y=FIQ, color=group)
scatter.td_adolsc_minorSt3_Gap_FIQ <- scatterPlotter(td_adolsc_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'FIQ', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# combine the TD adolsc plots for minorSt3
td_adolsc_minorSt3_plots <- arrangeGrob(scatter.td_adolsc_minorSt3_Gap_Freq,
				    scatter.td_adolsc_minorSt3_Gap_indirMjrTrans,
				    scatter.td_adolsc_minorSt3_Gap_dirMnrTrans,
				    scatter.td_adolsc_minorSt3_Gap_dirMjrTrans,
				    scatter.td_adolsc_minorSt3_Gap_FIQ,
				    nrow=3, ncol=3,
				    top=textGrob("TD adolsc modules | minor st A-F",gp=gpar(fontsize=18,font=3)))
#
# (c) adult - minorSt_2-5 (td_adult_minorSt2_Gap) and minorSt_1-6 (td_adult_minorSt3_Gap) are to be considered. 
# minor st combn frequency 
mapping <- aes(x=minorStGap, y=minorStCombnFreq, color=group)
scatter.td_adult_minorSt2_Gap_Freq <- scatterPlotter(td_adult_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'minor state freq (combined)', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# indirect major trans freq
mapping <- aes(x=minorStGap, y=indirectMjrTrans, color=group)
scatter.td_adult_minorSt2_Gap_indirMjrTrans <- scatterPlotter(td_adult_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'indirect trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct minor trans freq
mapping <- aes(x=minorStGap, y=directMnrTrans, color=group)
scatter.td_adult_minorSt2_Gap_dirMnrTrans <- scatterPlotter(td_adult_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between minor states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct major trans freq
mapping <- aes(x=minorStGap, y=directMjrTrans, color=group)
scatter.td_adult_minorSt2_Gap_dirMjrTrans <- scatterPlotter(td_adult_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# FIQ
mapping <- aes(x=minorStGap, y=FIQ, color=group)
scatter.td_adult_minorSt2_Gap_FIQ <- scatterPlotter(td_adult_combn_minorSt2_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'FIQ', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# combine the TD adult plots for minorSt2
td_adult_minorSt2_plots <- arrangeGrob(scatter.td_adult_minorSt2_Gap_Freq,
				    scatter.td_adult_minorSt2_Gap_indirMjrTrans,
				    scatter.td_adult_minorSt2_Gap_dirMnrTrans,
				    scatter.td_adult_minorSt2_Gap_dirMjrTrans,
				    scatter.td_adult_minorSt2_Gap_FIQ,
				    nrow=3, ncol=3,
				    top=textGrob("TD adult modules | minor st B-E",gp=gpar(fontsize=18,font=3)))
## adult - td_adult_minorSt3_Gap 
# minor st combn frequency 
mapping <- aes(x=minorStGap, y=minorStCombnFreq, color=group)
scatter.td_adult_minorSt3_Gap_Freq <- scatterPlotter(td_adult_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'minor state freq (combined)', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# indirect major trans freq
mapping <- aes(x=minorStGap, y=indirectMjrTrans, color=group)
scatter.td_adult_minorSt3_Gap_indirMjrTrans <- scatterPlotter(td_adult_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'indirect trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct minor trans freq
mapping <- aes(x=minorStGap, y=directMnrTrans, color=group)
scatter.td_adult_minorSt3_Gap_dirMnrTrans <- scatterPlotter(td_adult_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between minor states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# direct major trans freq
mapping <- aes(x=minorStGap, y=directMjrTrans, color=group)
scatter.td_adult_minorSt3_Gap_dirMjrTrans <- scatterPlotter(td_adult_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'direct trans freq between major states', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# FIQ
mapping <- aes(x=minorStGap, y=FIQ, color=group)
scatter.td_adult_minorSt3_Gap_FIQ <- scatterPlotter(td_adult_combn_minorSt3_Gap, mapping, mapping, 'lm', '<within> - <across> FC | minor states', 'FIQ', TRUE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))
# combine the TD adult plots for minorSt3
td_adult_minorSt3_plots <- arrangeGrob(scatter.td_adult_minorSt3_Gap_Freq,
				    scatter.td_adult_minorSt3_Gap_indirMjrTrans,
				    scatter.td_adult_minorSt3_Gap_dirMnrTrans,
				    scatter.td_adult_minorSt3_Gap_dirMjrTrans,
				    scatter.td_adult_minorSt3_Gap_FIQ,
				    nrow=3, ncol=3,
				    top=textGrob("TD adult modules | minor st A-F",gp=gpar(fontsize=18,font=3)))

# minor st FC gap - calculate correlation for TD.
# for (ageDiv in c("child", "adolsc", "adult")) {
#   for (index in c("2", "3")) {
#   for (interest in c("minorStCombnFreq", "indirectMjrTrans", "directMnrTrans", "FIQ", "directMjrTrans")) {
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


