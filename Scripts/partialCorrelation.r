# for generating partial correlation results
library(tidyverse)
library(ppcor) # allows par cor analysis of n vars at one go. The data frame or tibble should have columns as the vars one is interested in.

# four sets of partial correlation for each age group -
# (a) (ASD) indirect trans freq vs ADOS, appear freq of indiv or combn minor state
# (b) (ASD) duration of major state vs FIQ, appear freq of indiv major state
# (c) (TD) indirect trans freq vs FIQ, appear freq of indiv major states
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

# filter necessary data
# the following eval code will filter - (a) <group>_<age>_indirect_trans (b)<group>_<age>_minorSt_combn (c) <group>_<age>_duration (d) <group>_<age>_majorSt1_freq (e) <group>_<age>_majorSt2_freq (f) <group>_<age>_indirect_trans 
for (group in c("asd", "td")) {
for (ageDiv in c("child", "adolsc", "adult")) {
eval(parse(text=sprintf("%s_%s_indirect_trans <- asd_td_trans %%>%% filter(group == '%s', transType == 'indirect MajorTrans', age == \'%s\')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_minorSt_combn <- asd_td_freq %%>%% filter(group == '%s', state=='minorSt_Combn', age == '%s')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_duration <- asd_td_duration %%>%% filter(group == '%s', age == '%s')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_majorSt1_freq <- asd_td_freq %%>%% filter(group == '%s', age == '%s', state=='majorSt1')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_majorSt2_freq <- asd_td_freq %%>%% filter(group == '%s', age == '%s', state=='majorSt2')", group, ageDiv, toupper(group), ageDiv)))
eval(parse(text=sprintf("%s_%s_indirect_trans <- asd_td_trans %%>%% filter(group == '%s', transType == 'indirect MajorTrans', age == '%s')", group, ageDiv, toupper(group), ageDiv)))
}
}

# build up tibble for diagnostic groups (across age) to carry out par cor analysis

