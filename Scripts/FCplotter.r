# exclusively for FC related plots as project_plotter.r has become too long.

library(tidyverse)
library(broom)
# source the function file
source('~/Documents/Dissertation Docs & Papers/Scripts/project_functions.r')
# CAUTION: the ASD adult subject (ABIDE I NYU) with age 39.1 years should be removed?

asd_td_netMods <- read.table('~/Documents/asd_td_netModsFC_forR_empirical.csv', header=T, sep=",");
asd_td_netMods_Gap <- read.table('~/Documents/asd_td_netModsFC_Gap_forR_empirical.csv', header=T, sep=",");
asd_td_netMods$age <- factor(asd_td_netMods$age, levels = c("child", "adolsc", "adult"))
asd_td_netMods_Gap$age <- factor(asd_td_netMods_Gap$age, levels = c("child", "adolsc", "adult"))

# SECTION I. plot major states for ASD, TD
# across age between groups
data <- asd_td_netMods %>% filter(stateType == "majorSt");
majorStAcrossAgeBetwnGroups <- generalFCBarPlotter(data, aes(group,FCval,fill=FCtype), facet_wrap(~age, ncol=3), "diagnosis", "Mean FC (Z value) | major state modules", TRUE, expand_limits(y=0.82)); 
#within ASD/TD, across age
majorStAcrossAgeWithinGroups <- generalFCBarPlotter(data, aes(age,FCval,fill=FCtype), facet_wrap(~group, ncol=2), "diagnosis", "Mean FC (Z value) | major state modules", TRUE, expand_limits(y=0.87));

## save major state figures
#ggsave(majorStAcrossAgeBetwnGroups, width=12, file="majorSt_FC_acrossAgeBetweenGroups.pdf");
#ggsave(majorStAcrossAgeWithinGroups, width=12, file="majorSt_FC_acrossAgeWithinGroups.pdf");

## ANOVA for major states
# summarise mean (of within, across and within `minus` across) and anova results from each group.
for(ageDiv in c("child", "adolsc", "adult")) {
   data = asd_td_netMods %>% filter(age==ageDiv, stateType == 'majorSt') 
   anovaResultsPostTukeyHSD(FCval ~ FCtype*group, data, c("within:ASD-across:ASD", "within:TD-across:TD"), sprintf("major st modules in %s", ageDiv))
}

# major state modules - compare the mean difference in (within `minus` across FC) between ASD and TD
# summarise results for gap in FC (within `minus` across) for each age group.
for(ageDiv in c("child", "adolsc", "adult")) {
   data = asd_td_netMods_Gap %>% filter(age==ageDiv, stateType == 'majorSt') 
   anovaResultsPostTukeyHSD(FCval ~ group, data, c("TD-ASD"), sprintf("major st. within-across gap in %s", ageDiv))
}
## ASD gap - child, adolsc, adult
# summarise results for gap in FC (within `minus` across) for withing each diag group across age.
for(grp in c("ASD", "TD")) {
   data =asd_td_netMods_Gap %>% filter(group== grp, stateType == 'majorSt') 
   anovaResultsPostTukeyHSD(FCval ~ age, data, c("adolsc-child", "adult-adolsc", "adult-child"), sprintf("major st. within-across gap in %s group", grp))
}

# SECTION II. plot minor states for ASD, TD
# first filter relevant minor states as there are many pairs of minor states and they need to be tackled.
asd_child_minorSt <- asd_td_netMods %>% filter(group=="ASD", age == "child", stateType=="minorSt_3-4");
asd_adolsc_minorSt <- asd_td_netMods %>% filter(group=="ASD", age == "adolsc", stateType=="minorSt_3-4");
asd_adult_minorSt <- asd_td_netMods %>% filter(group=="ASD", age == "adult", stateType=="minorSt_1-4");

# TD child has three pairs of minor states. There are two unique network modules. 
td_child_minorSt1 <- asd_td_netMods %>% filter(group=="TD", age == "child", stateType=="minorSt_1-5");
td_child_minorSt2 <- asd_td_netMods %>% filter(group=="TD", age == "child", stateType=="minorSt_1-4");

# TD adolsc has four pairs of minor states. There are three unique network modules.
td_adolsc_minorSt1 <- asd_td_netMods %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_1-2");
td_adolsc_minorSt2 <- asd_td_netMods %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_2-5");
td_adolsc_minorSt3 <- asd_td_netMods %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_1-6");

# TD adult has four pairs of minor states. There are three unique network modules.
td_adult_minorSt1 <- asd_td_netMods %>% filter(group=="TD", age == "adult", stateType=="minorSt_1-2");
td_adult_minorSt2 <- asd_td_netMods %>% filter(group=="TD", age == "adult", stateType=="minorSt_2-5");
td_adult_minorSt3 <- asd_td_netMods %>% filter(group=="TD", age == "adult", stateType=="minorSt_1-6");

## bind all the data frames into a single frame
#bind ASD data
asd_td_minorst_combined <- rbind(asd_child_minorSt, asd_adolsc_minorSt, asd_adult_minorSt);
#bind TD data 
asd_td_minorst_combined <- rbind(asd_td_minorst_combined, td_child_minorSt1, td_child_minorSt2);
asd_td_minorst_combined <- rbind(asd_td_minorst_combined, td_adolsc_minorSt1, td_adolsc_minorSt2, td_adolsc_minorSt3);
asd_td_minorst_combined <- rbind(asd_td_minorst_combined, td_adult_minorSt1, td_adult_minorSt2, td_adult_minorSt3);

# combine columns for sanity. Index 1 for group. Index 4 for stateType. 
asd_td_minorst_combined$groupAndState <- paste(asd_td_minorst_combined[,1], asd_td_minorst_combined[,4]) 

# make plots for three separate age groups as labels are becoming overlapping.
child_minorStAcrossAgeBetweenGroups <- generalFCBarPlotter(asd_td_minorst_combined %>% filter(age=='child'), aes(groupAndState,FCval,fill=FCtype), NULL , "", "Mean FC (Z value) | children | minor state modules", TRUE, expand_limits(y=0.75))
adolsc_minorStAcrossAgeBetweenGroups <- generalFCBarPlotter(asd_td_minorst_combined %>% filter(age=='adolsc'), aes(groupAndState,FCval,fill=FCtype), NULL , "", "Mean FC (Z value) | adolescent | minor state modules", TRUE, expand_limits(y=0.75))
adult_minorStAcrossAgeBetweenGroups <- generalFCBarPlotter(asd_td_minorst_combined %>% filter(age=='adult'), aes(groupAndState,FCval,fill=FCtype), NULL , "", "Mean FC (Z value) | adult | minor state modules", TRUE, expand_limits(y=1))
#
#ggsave(child_minorStAcrossAgeBetweenGroups, width=8, file="child_minorStFC_acrossAgeBetweenGroups.pdf");
#ggsave(adolsc_minorStAcrossAgeBetweenGroups, width=8, file="adolsc_minorStFC_acrossAgeBetweenGroups.pdf");
#ggsave(adult_minorStAcrossAgeBetweenGroups, width=8, file="adult_minorStFC_acrossAgeBetweenGroups.pdf");

# plots for minor state modules - across age
# deal with ASD across age.
data <- rbind(asd_child_minorSt, asd_adolsc_minorSt, asd_adult_minorSt);
asd.minorStAcrossAgeWithinGroups <- generalFCBarPlotter(data, aes(age,FCval,fill=FCtype), NULL, "diagnosis", "Mean FC (Z value) | minor state modules | ASD subjects through age", TRUE, expand_limits(y=0.72));
# deal with TD across age.
# closely similar minor state modules - 
# (a) minorSt_1-5 (child), minorSt_1-2 (adolsc), minorSt_1-2 (adult)
# (b) minorSt_1-4 (child), minorSt_2-5 (adolsc), minorSt_2-5 (adult)
# (c) minorSt_1-4 (child), minorSt_1-6 (adolsc), minorSt_1-6 (adult) 
# (Note: TD child has three minor states - two different modules. TD adolsc and adult has three different modules. So, will need to use minorSt_1-4 for comparison again.)
data1 <- rbind(td_child_minorSt1, td_adolsc_minorSt1, td_adult_minorSt1)
data2 <- rbind(td_child_minorSt2, td_adolsc_minorSt2, td_adult_minorSt2)
data3 <- rbind(td_child_minorSt2, td_adolsc_minorSt3, td_adult_minorSt3)
# for (a)
td.minorStAcrossAgeWithinGroups1 <- generalFCBarPlotter(data1, aes(age,FCval,fill=FCtype), NULL, "diagnosis", "Mean FC (Z value) | minor state modules (a) | TD subjects through age", TRUE, expand_limits(y=0.93));
# for (b)
td.minorStAcrossAgeWithinGroups2 <- generalFCBarPlotter(data2, aes(age,FCval,fill=FCtype), NULL, "diagnosis", "Mean FC (Z value) | minor state modules (b) | TD subjects through age", TRUE, expand_limits(y=0.5));
# for (c)
td.minorStAcrossAgeWithinGroups3 <- generalFCBarPlotter(data3, aes(age,FCval,fill=FCtype), NULL, "diagnosis", "Mean FC (Z value) | minor state modules (c) | TD subjects through age", TRUE, expand_limits(y=0.3));
# run ANOVA for across age between groups
# child 
anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState,asd_td_minorst_combined %>% filter(age=='child'), c("within:ASD minorSt_3-4-across:ASD minorSt_3-4", "within:TD minorSt_1-4-across:TD minorSt_1-4", "within:TD minorSt_1-5-across:TD minorSt_1-5"), "child group") 
#adolsc
anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState, asd_td_minorst_combined %>% filter(age=='adolsc'), c("within:ASD minorSt_3-4-across:ASD minorSt_3-4", "within:TD minorSt_1-2-across:TD minorSt_1-2", "within:TD minorSt_1-6-across:TD minorSt_1-6", "within:TD minorSt_2-5-across:TD minorSt_2-5"), "adolsc group")
#adult
anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState, asd_td_minorst_combined %>% filter(age=='adult'), c("within:ASD minorSt_1-4-across:ASD minorSt_1-4", "within:TD minorSt_1-2-across:TD minorSt_1-2", "within:TD minorSt_1-6-across:TD minorSt_1-6", "within:TD minorSt_2-5-across:TD minorSt_2-5"), "adult group")
# run ANOVA for gap between minor state modules in all three groups
# minor state gap in child - between ASD and TD
data <- asd_td_netMods_Gap %>% filter((age== 'child') & (stateType == "minorSt_3-4" | stateType == "minorSt_1-4" | stateType == "minorSt_1-5"))
anovaResultsPostTukeyHSD(FCval ~ stateType, data, c("minorSt_1-5-minorSt_1-4", "minorSt_3-4-minorSt_1-4", "minorSt_3-4-minorSt_1-5"), "minor state modules in child")
# minor state gap in adolsc - between ASD and TD


