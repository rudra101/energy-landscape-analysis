# exclusively for FC related plots as project_plotter.r has become too long.
## following is a mapping to be used for minima indices. The corresponding laters should be used. The arrows reflect (old index) -> (new index).
#NOTE: due to reordering of basin labels these labels are not valid. Here, is the mapping from number to letter indices that fixes the problem:-
#ASD child - 3->4, 4->3 
#ASD adols - 1->2, 2->1
#ASD adult - 1->4, 2->1, 3->2, 4->3 
#TD  child - 1->3, 2->1, 3->2 
#TD  adols - 1->6, 2->3, 3->1, 4->2, 5->4, 6->5 
#TD  adult - 1->4, 2->5, 3->2, 4->1, 5->6, 6->3

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
   anovaResultsPostTukeyHSD(FCval ~ age, data, c("adolsc-child", "adult-adolsc", "adult-child"), sprintf("major st | FC gap | %s group", grp))
}

# SECTION II. plot minor states for ASD, TD
# first filter relevant minor states as there are many pairs of minor states and they need to be tackled.
asd_child_minorSt <- asd_td_netMods %>% filter(group=="ASD", age == "child", stateType=="minorSt_3-4");
asd_adolsc_minorSt <- asd_td_netMods %>% filter(group=="ASD", age == "adolsc", stateType=="minorSt_3-4");
asd_adult_minorSt <- asd_td_netMods %>% filter(group=="ASD", age == "adult", stateType=="minorSt_1-4");
# create a newStateType column to reflect the updated minima indices. Refer to the comment about mapping in the beginning of this file.
#asd_child_minorSt$newStateType = 

# TD child has three pairs of minor states. There are two unique network modules. 
#td_child_minorSt1 <- asd_td_netMods %>% filter(group=="TD", age == "child", stateType=="minorSt_1-5"); #not considering because of single network as modules
td_child_minorSt2 <- asd_td_netMods %>% filter(group=="TD", age == "child", stateType=="minorSt_1-4");

# TD adolsc has four pairs of minor states. There are three unique network modules.
#td_adolsc_minorSt1 <- asd_td_netMods %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_1-2");
td_adolsc_minorSt2 <- asd_td_netMods %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_2-5");
td_adolsc_minorSt3 <- asd_td_netMods %>% filter(group=="TD", age == "adolsc", stateType=="minorSt_1-6");

# TD adult has four pairs of minor states. There are three unique network modules.
#td_adult_minorSt1 <- asd_td_netMods %>% filter(group=="TD", age == "adult", stateType=="minorSt_1-2");
td_adult_minorSt2 <- asd_td_netMods %>% filter(group=="TD", age == "adult", stateType=="minorSt_2-5");
td_adult_minorSt3 <- asd_td_netMods %>% filter(group=="TD", age == "adult", stateType=="minorSt_1-6");

## bind all the data frames into a single frame
#bind ASD data
asd_td_minorst_combined <- rbind(asd_child_minorSt, asd_adolsc_minorSt, asd_adult_minorSt);
#bind TD data 
asd_td_minorst_combined <- rbind(asd_td_minorst_combined, td_child_minorSt2);
asd_td_minorst_combined <- rbind(asd_td_minorst_combined, td_adolsc_minorSt2, td_adolsc_minorSt3);
asd_td_minorst_combined <- rbind(asd_td_minorst_combined, td_adult_minorSt2, td_adult_minorSt3);

# combine columns for sanity. Index 1 for group. Index 4 for stateType. 
asd_td_minorst_combined$groupAndState <- paste(asd_td_minorst_combined[,1], asd_td_minorst_combined[,4]) 

# make plots for three separate age groups as labels are becoming overlapping.
child_minorStBetweenGroups <- generalFCBarPlotter(asd_td_minorst_combined %>% filter(age=='child'), aes(groupAndState,FCval,fill=FCtype), NULL , "", "ASD & TD children | Mean FC (Z value) in minor state modules", TRUE, expand_limits(y=0.75))
adolsc_minorStBetweenGroups <- generalFCBarPlotter(asd_td_minorst_combined %>% filter(age=='adolsc'), aes(groupAndState,FCval,fill=FCtype), NULL , "", "ASD & TD adolescents | Mean FC (Z value) in minor state modules", TRUE, expand_limits(y=0.75))
# for adults, need to reorder xlabels 
data <- asd_td_minorst_combined %>% filter(age=='adult')
data$groupAndState <- factor(data$groupAndState, c("ASD minorSt_1-4", "TD minorSt_1-6", "TD minorSt_2-5"))
#adult_minorStBetweenGroups <- generalFCBarPlotter(data, aes(groupAndState,FCval,fill=FCtype), NULL , "", "ASD & TD adults | Mean FC (Z value) in minor state modules", TRUE, expand_limits(y=1))
adult_minorStBetweenGroups <- generalFCBarPlotter(data, aes(groupAndState,FCval,fill=FCtype), NULL , "", "ASD & TD adults | Mean FC (Z value) in minor state modules", TRUE,expand_limits(y=0.4))
#
#ggsave(child_minorStBetweenGroups, width=8, file="child_minorStFC_BetweenGroups.pdf");
#ggsave(adolsc_minorStBetweenGroups, width=8, file="adolsc_minorStFC_BetweenGroups.pdf");
#ggsave(adult_minorStBetweenGroups, width=8, file="adult_minorStFC_BetweenGroups.pdf");

# plots for minor state modules - across age
# deal with ASD across age.
data <- rbind(asd_child_minorSt, asd_adolsc_minorSt, asd_adult_minorSt);
asd.minorStAcrossAge <- generalFCBarPlotter(data, aes(age,FCval,fill=FCtype), NULL, "age", "ASD subjects | Mean FC (Z value) in minor state modules", TRUE, expand_limits(y=0.72));
# deal with TD across age.
# closely similar minor state modules - 
# (a) minorSt_1-5 (child), minorSt_1-2 (adolsc), minorSt_1-2 (adult)
# (b) minorSt_1-4 (child), minorSt_2-5 (adolsc), minorSt_2-5 (adult)
# (c) minorSt_1-4 (child), minorSt_1-6 (adolsc), minorSt_1-6 (adult) 
# (Note: TD child has three minor states - two different modules. TD adolsc and adult has three different modules. So, will need to use minorSt_1-4 for comparison again.)
#data1 <- rbind(td_child_minorSt1, td_adolsc_minorSt1, td_adult_minorSt1)
data2 <- rbind(td_child_minorSt2, td_adolsc_minorSt2, td_adult_minorSt2)
data3 <- rbind(td_child_minorSt2, td_adolsc_minorSt3, td_adult_minorSt3)
# for (a)
#td.minorStAcrossAge1 <- generalFCBarPlotter(data1, aes(age,FCval,fill=FCtype), NULL, "age", "Mean FC (Z value) | minor state module (a) | TD subjects through age", TRUE, expand_limits(y=0.96));
# for (b)
td.minorStAcrossAge2 <- generalFCBarPlotter(data2, aes(age,FCval,fill=FCtype), NULL, "age", "TD subjects | Mean FC (Z value) in minor state modules | Arrangement #1", TRUE, expand_limits(y=0.5));
# for (c)
td.minorStAcrossAge3 <- generalFCBarPlotter(data3, aes(age,FCval,fill=FCtype), NULL, "age", "TD subjects | Mean FC (Z value) in minor state modules | Arrangement #2", TRUE, expand_limits(y=0.42));

# save the plots
#ggsave(asd.minorStAcrossAge, width=8, file="asd_minorStFC_acrossAge.pdf")
#ggsave(td.minorStAcrossAge1, width=8, file="td_minorStFC_acrossAge_partition1.pdf")
ggsave(td.minorStAcrossAge2, width=8, file="td_minorStFC_acrossAge_arrange1.pdf")
ggsave(td.minorStAcrossAge3, width=8, file="td_minorStFC_acrossAge_arrange2.pdf")

# run ANOVA for across age between groups
# child 
#anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState,asd_td_minorst_combined %>% filter(age=='child'), c("within:ASD minorSt_3-4-across:ASD minorSt_3-4", "within:TD minorSt_1-4-across:TD minorSt_1-4", "within:TD minorSt_1-5-across:TD minorSt_1-5"), "(within vs across) child group") 
anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState,asd_td_minorst_combined %>% filter(age=='child'), c("within:ASD minorSt_3-4-across:ASD minorSt_3-4", "within:TD minorSt_1-4-across:TD minorSt_1-4"), "(within vs across) child group") 
#adolsc
#anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState, asd_td_minorst_combined %>% filter(age=='adolsc'), c("within:ASD minorSt_3-4-across:ASD minorSt_3-4", "within:TD minorSt_1-2-across:TD minorSt_1-2", "within:TD minorSt_1-6-across:TD minorSt_1-6", "within:TD minorSt_2-5-across:TD minorSt_2-5"), "(within vs across) adolsc group")
anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState, asd_td_minorst_combined %>% filter(age=='adolsc'), c("within:ASD minorSt_3-4-across:ASD minorSt_3-4", "within:TD minorSt_1-6-across:TD minorSt_1-6", "within:TD minorSt_2-5-across:TD minorSt_2-5"), "(within vs across) adolsc group")
#adult
#anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState, asd_td_minorst_combined %>% filter(age=='adult'), c("within:ASD minorSt_1-4-across:ASD minorSt_1-4", "within:TD minorSt_1-2-across:TD minorSt_1-2", "within:TD minorSt_1-6-across:TD minorSt_1-6", "within:TD minorSt_2-5-across:TD minorSt_2-5"), "(within vs across) adult group")
anovaResultsPostTukeyHSD(FCval ~ FCtype*groupAndState, asd_td_minorst_combined %>% filter(age=='adult'), c("within:ASD minorSt_1-4-across:ASD minorSt_1-4", "within:TD minorSt_1-6-across:TD minorSt_1-6", "within:TD minorSt_2-5-across:TD minorSt_2-5"), "(within vs across) adult group")

# run ANOVA for gap between minor state modules in all three groups
# minor state gap in child - between ASD and TD
#data <- asd_td_netMods_Gap %>% filter((age== 'child') & (stateType == "minorSt_3-4" | stateType == "minorSt_1-4" | stateType == "minorSt_1-5"))
data <- asd_td_netMods_Gap %>% filter((age== 'child') & (stateType == "minorSt_3-4" | stateType == "minorSt_1-4"))
#anovaResultsPostTukeyHSD(FCval ~ stateType, data, c("minorSt_1-5-minorSt_1-4", "minorSt_3-4-minorSt_1-4", "minorSt_3-4-minorSt_1-5"), "minor state | FC gap | child (ASD vs TD)")
anovaResultsPostTukeyHSD(FCval ~ stateType, data, c("minorSt_3-4-minorSt_1-4"), "minor state | FC gap | child (ASD vs TD)")

# minor state gap in adolsc - between ASD and TD
#data <- asd_td_netMods_Gap %>% filter((age== 'adolsc') & (stateType == "minorSt_3-4" | stateType == "minorSt_1-2" | stateType == "minorSt_1-6" | stateType == "minorSt_2-5"))
data <- asd_td_netMods_Gap %>% filter((age== 'adolsc') & (stateType == "minorSt_3-4" | stateType == "minorSt_1-6" | stateType == "minorSt_2-5"))
#anovaResultsPostTukeyHSD(FCval ~ stateType, data, c("minorSt_3-4-minorSt_1-2", "minorSt_3-4-minorSt_1-6", "minorSt_3-4-minorSt_2-5"), "minor state | FC gap | adolsc (ASD vs TD)")
anovaResultsPostTukeyHSD(FCval ~ stateType, data, c("minorSt_3-4-minorSt_1-6", "minorSt_3-4-minorSt_2-5"), "minor state | FC gap | adolsc (ASD vs TD)")

# minor state gap in adult - between ASD and TD
#data <- asd_td_netMods_Gap %>% filter((age== 'adult') & (stateType == "minorSt_1-4" | stateType == "minorSt_1-2" | stateType == "minorSt_1-6" | stateType == "minorSt_2-5"))
data <- asd_td_netMods_Gap %>% filter((age== 'adult') & (stateType == "minorSt_1-4" | stateType == "minorSt_1-6" | stateType == "minorSt_2-5"))
#anovaResultsPostTukeyHSD(FCval ~ stateType, data, c("minorSt_1-4-minorSt_1-2", "minorSt_1-6-minorSt_1-4", "minorSt_2-5-minorSt_1-4"), "minor state | FC gap | adult (ASD vs TD)")
anovaResultsPostTukeyHSD(FCval ~ stateType, data, c("minorSt_1-6-minorSt_1-4", "minorSt_2-5-minorSt_1-4"), "minor state | FC gap | adult (ASD vs TD)")

# run ANOVA for gap between within and across FC within a diagnostic group
# asd - across age
data <- asd_td_netMods_Gap %>% filter(group == 'ASD')
anovaResultsPostTukeyHSD(FCval ~ age, data, c("adolsc-child", "adult-child", "adult-adolsc"), "minor state modules | FC gap | ASD")
# td - across age
# deal with modules under td.minorStAcrossAge1 above
#partition1.data1 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'child' & stateType == "minorSt_1-5")
#partition1.data2 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'adolsc' & stateType == "minorSt_1-2")
#partition1.data3 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'adult' & stateType == "minorSt_1-2")
#data <- rbind(partition1.data1, partition1.data2, partition1.data3)
#anovaResultsPostTukeyHSD(FCval ~ age, data, c("adolsc-child", "adult-child", "adult-adolsc"), "minor state modules | FC gap | TD partition1")

# deal with modules under td.minorStAcrossAge2 above
partition2.data1 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'child' & stateType == "minorSt_1-4")
partition2.data2 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'adolsc' & stateType == "minorSt_2-5")
partition2.data3 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'adult' & stateType == "minorSt_2-5")
data <- rbind(partition2.data1, partition2.data2, partition2.data3)
anovaResultsPostTukeyHSD(FCval ~ age, data, c("adolsc-child", "adult-child", "adult-adolsc"), "minor state modules | FC gap | TD division #1")

# deal with modules under td.minorStAcrossAge3 above
partition3.data1 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'child' & stateType == "minorSt_1-4")
partition3.data2 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'adolsc' & stateType == "minorSt_1-6")
partition3.data3 <- asd_td_netMods_Gap %>% filter(group == 'TD' & age == 'adult' & stateType == "minorSt_1-6")
data <- rbind(partition3.data1, partition3.data2, partition3.data3)
anovaResultsPostTukeyHSD(FCval ~ age, data, c("adolsc-child", "adult-child", "adult-adolsc"), "minor state modules | FC gap | TD division #2")

