##a file containing all the helper functions needed for plotting and running stats

## for bar plots
barPlotterAcrossAgeWithinGroup <- function(data, mapping, xLabel, yLabel, addPercent) {
	desiredPlot <- ggplot(data, mapping) +
        #geom_violin(alpha=0.7) +
        geom_col(aes(fill=age), position= position_dodge(width=0.7), width=0.6) +
        #geom_signif(comparisons = asd_td_freq$state, test=`t.test`, map_signif_level=TRUE) + 
        facet_wrap(~group, ncol=2) +
        scale_y_continuous(labels = function(x) if(addPercent) paste0(x, "%") else paste0(x)) +
        xlab(xLabel) +
        ylab(yLabel)
	
	return(desiredPlot)
}

barPlotterAcrossAgeBetwnGroup <- function(data, mapping, xLabel, yLabel, addPercent) {
	desiredPlot <- ggplot(data, mapping) +
        #geom_violin(alpha=0.7) +
        geom_col(aes(fill=group), position= position_dodge(width=0.7), width=0.6) +
        #geom_signif(comparisons = asd_td_freq$state, test=`t.test`, map_signif_level=TRUE) + 
        facet_wrap(~age, ncol=3) +
        scale_y_continuous(labels = function(x) if(addPercent) paste0(x, "%") else paste0(x)) +
        xlab(xLabel) +
        ylab(yLabel)
	
	return(desiredPlot)
}

## for box plots
boxPlotterAcrossAgeWithinGroup <- function(data, mapping, xLabel, yLabel, addPercent) {
	desiredPlot <- ggplot(data, mapping) +
        #geom_violin(alpha=0.7) +
        geom_boxplot(aes(fill=age), alpha=0.6) + 
        #geom_signif(comparisons = asd_td_freq$state, test=`t.test`, map_signif_level=TRUE) + 
        facet_wrap(~group, ncol=2) +
        scale_y_continuous(labels = function(x) if(addPercent) paste0(x, "%") else paste0(x)) +
        xlab(xLabel) +
        ylab(yLabel)
	
	return(desiredPlot)
}

boxPlotterAcrossAgeBetwnGroup <- function(data, mapping, xLabel, yLabel, addPercent) {
	desiredPlot <- ggplot(data, mapping) +
        #geom_violin(alpha=0.7) +
        geom_boxplot(aes(fill=group), alpha=0.6) + 
        #geom_signif(comparisons = asd_td_freq$state, test=`t.test`, map_signif_level=TRUE) + 
        facet_wrap(~age, ncol=3) +
        scale_y_continuous(labels = function(x) if(addPercent) paste0(x, "%") else paste0(x)) +
        xlab(xLabel) +
        ylab(yLabel)
	
	return(desiredPlot)
}

scatterPlotter <- function(data, dataMapping, smoothMapping, smoothMethod, xLabel, yLabel, addPercentYaxis=FALSE, addPercentXaxis=FALSE, facetWrap=NULL) {
 desiredPlot <- ggplot(data) + 
	 geom_point(dataMapping) +
	 geom_smooth(smoothMapping, method=smoothMethod)

 if (!missing(addPercentXaxis) && addPercentXaxis) {
      desiredPlot <- desiredPlot + 
	scale_x_continuous(labels = function(x) paste0(x, "%"))
 }
 if (!missing(addPercentYaxis) && addPercentYaxis) {
      desiredPlot <- desiredPlot + 
	scale_y_continuous(labels = function(x) paste0(x, "%"))
 }
 if (!is.null(facetWrap)) {
     desiredPlot <- desiredPlot + facetWrap
 }
      desiredPlot <- desiredPlot + xlab(xLabel) + ylab(yLabel)
      return(desiredPlot)
}

# for plottting across and within FC.
# depending upon dataMapping and facetWrap provided,
# we can plot (a) across age within a diagnosis group OR,
# (b) across age between groups.
generalFCBarPlotter <- function(data, dataMapping, facetWrap, xLabel, yLabel, addRawData=TRUE, expandedLimits=NULL) {
    desiredPlot <- ggplot(data, dataMapping) + 
	     geom_bar(position = "dodge", stat = "summary", fun = "mean")
    if (!is.null(facetWrap)) {
    desiredPlot <- desiredPlot + facetWrap
    }
    if(addRawData) {
        desiredPlot <- desiredPlot + geom_point(colour="black", position=position_dodge(width=0.9));
    }
    if(!is.null(expandedLimits)) {
	desiredPlot <- desiredPlot + expandedLimits
    }
    # add labels
    desiredPlot <- desiredPlot + xlab(xLabel) + ylab(yLabel);
    
    return(desiredPlot)
}

## functions for running anova
# print contrast results from TukeyHSD on ANOVA results
anovaResultsPostTukeyHSD <- function(formula, inputData, contrastList, identifierText) {
  aov.result <- aov(formula, data=inputData)
  tidy.tukey.aov.result <- tidy(TukeyHSD(aov.result))

  for(contra in contrastList) {
  eval(parse(text=sprintf('res <- tidy.tukey.aov.result %%>%% filter(contrast == \"%s\")', contra)))
  cat(sprintf("%s. contrast(%s) : %f (p=%f).\n", identifierText, contra, res$estimate, res$adj.p.value))
  }

}

# this function to get a tibble containing major st combn frequency for a group
getMajorStCombnFreqTibble <- function(data, diaggroup) {
	diaggroup_majorSt1 <- data %>% filter(group==diaggroup, state=='majorSt1')
	diaggroup_majorSt2 <- data %>% filter(group==diaggroup, state=='majorSt2')
	diaggroup_major_combn <- tibble(group = diaggroup, age = diaggroup_majorSt1$age, majorStCombnFreq=diaggroup_majorSt1$freq + diaggroup_majorSt2$freq)
	return(diaggroup_major_combn)
}

