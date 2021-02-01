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

