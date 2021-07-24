# plots correlation between model and state probabilityu
library(tidyverse)
library(grid)
library(gridExtra)
source('~/Documents/Dissertation Docs & Papers/Scripts/project_functions.r')

asd_td_stateProb <- read.table('~/Documents/asd_td_modelVsEmpr_StateProb.csv', header=T, sep=",")
asd_td_stateProb$age <- factor(asd_td_stateProb$age, levels = c("child", "adolsc", "adult"))
mapping <- aes(x=stateProbMEM, y=stateProbEmpr, color=group)
asd_plot <- scatterPlotter(asd_td_stateProb %>% filter(group=="ASD"), mapping, mapping, 'lm', 'appear freq (model)', 'appear freq (empirical)', FALSE, FALSE, facet_wrap(~age, scales="free_x", ncol=3))
td_plot <- scatterPlotter(asd_td_stateProb %>% filter(group=="TD"), mapping, mapping, 'lm', 'appear freq (model)', 'appear freq (empirical)', FALSE, FALSE, facet_wrap(~age, scales="free_x", ncol=3)) + scale_color_manual(values=c("TD"="#6290c1"))

combined_plots <- arrangeGrob(asd_plot, td_plot, nrow=2, top=textGrob("state probabilities from model and empirical data",gp=gpar(fontsize=15,font=3)))
#ggsave(combined_plots, width=10, file="asd_td_stateProb_emprModel.pdf")

# get correlation values
for (grp in c("ASD", "TD")) {
  for(ageDiv in c("child", "adolsc", "adult")) {
    data <- asd_td_stateProb %>% filter(group== grp, age == ageDiv)
    memData <- data$stateProbMEM
    emprData <- data$stateProbEmpr
    res <- cor.test(memData, emprData)
    print(sprintf('(%s %s) MEM vs empr state prob. r = %f, p = %f', grp, ageDiv, res$estimate, res$p.value))
  }
}

