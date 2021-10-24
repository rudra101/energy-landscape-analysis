#prints demographic stats for subjects used
library(tidyverse)
library(hash)
# source the function file
source('~/Documents/Dissertation Docs & Papers/Scripts/project_functions.r')

# load ages of individual subjects.
asd_td_ages <- read.table('~/Documents/asd_td_ages_forR_empirical.csv', header=T, sep=",")
asd_td_ages$age <- factor(asd_td_ages$age, levels = c("child", "adolsc", "adult"))
# load fiqs of individual subjects.
asd_td_fiqs <- read.table('~/Documents/asd_td_fiqs_forR_empirical.csv', header=T, sep=",")
asd_td_fiqs$age <- factor(asd_td_fiqs$age, levels = c("child", "adolsc", "adult"))
## OUTLIER removal. ASD adult with age 39.1.
asd_td_ages = asd_td_ages %>% filter(ageInYears < 35)
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

#tables to column hash
tabToColHash = hash(keys = c("ages", "fiqs", "ados", "adosSocial", "adosRRB", "adosComm"),
	           values = c("ageInYears", "FIQ", "ADOS", "ADOS_SOCIAL", "ADOS_RRB", "ADOS_COMM"))

# FIQs and ages
for (ageDiv in c("child", "adolsc", "adult")) {
  for (interest in c("ages", "fiqs")) {
     colName = hashMatch(tabToColHash, interest)
     asd_tabl = eval(parse(text=sprintf('asd_td_%s %%>%% filter(group == \'ASD\', age == ageDiv)', interest)));
     td_tabl = eval(parse(text=sprintf('asd_td_%s %%>%% filter(group == \'TD\', age == ageDiv)', interest)));
     asd_data = eval(parse(text=sprintf('asd_tabl$%s', colName)));
     td_data = eval(parse(text=sprintf('td_tabl$%s', colName)));
     res = t.test(asd_data, td_data)
     cat(sprintf("ASD %s (N=%d). %s = [%f, %f] => %f±%f.\n", ageDiv, length(asd_data), colName, min(asd_data), max(asd_data), mean(asd_data), sd(asd_data)))
     cat(sprintf("TD %s (N=%d). %s = [%f, %f] => %f±%f.\n", ageDiv, length(td_data),colName, min(td_data), max(td_data), mean(td_data), sd(td_data)))
     cat(sprintf("  ASD,TD %s. %s => r=%f, p=%f.\n",ageDiv, colName, res$estimate, res$p.value))
  }
     cat('\n')
}
cat('\n')
# ADOS scores
for (ageDiv in c("child", "adolsc", "adult")) {
  for (interest in c("ados", "adosSocial", "adosRRB", "adosComm")) {
     colName = hashMatch(tabToColHash, interest)
     asd_tabl = eval(parse(text=sprintf('asd_%s %%>%% filter(group == \'ASD\', age == ageDiv, !is.na(%s))', interest, colName)));
     asd_data = eval(parse(text=sprintf('asd_tabl$%s', colName)));
     cat(sprintf("ASD %s (N=%d). %s = [%f, %f] => %f±%f.\n", ageDiv, length(asd_data), colName, min(asd_data), max(asd_data), mean(asd_data), sd(asd_data)))

  }
}




