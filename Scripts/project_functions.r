##a file containing all the helper functions needed for plotting and running stats

## for bar plots
barPlotterAcrossAgeWithinGroup <- function(data, mapping, xLabel, yLabel, addPercent, expandedLimits=NULL) {
	desiredPlot <- ggplot(data, mapping) +
        #geom_violin(alpha=0.7) +
        geom_col(aes(fill=age), position= position_dodge(width=0.7), width=0.6) +
        #geom_signif(comparisons = asd_td_freq$state, test=`t.test`, map_signif_level=TRUE) + 
        facet_wrap(~group, ncol=2) +
        scale_y_continuous(labels = function(x) if(addPercent) paste0(x, "%") else paste0(x)) +
        xlab(xLabel) +
        ylab(yLabel)
     if(!is.null(expandedLimits)) {
	desiredPlot <- desiredPlot + expandedLimits
     }	
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
  desiredPlot <- ggplot(data) + geom_point(dataMapping)
  if (!is.null(smoothMapping) && !is.null(smoothMethod)) {
     desiredPlot <- desiredPlot + geom_smooth(smoothMapping, method=smoothMethod)
  }
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

#get the label for a metric
getLabelForMetric <- function(metricName) {
   #if (metricName == "majorStDuration") {
   #   return "duration of major states"
   #}
  switch(metricName, 
	 "majorStDuration" = return("duration of major states"),
	 "minorStCombnFreq" = return("minor state appear freq (combined)"),
	"indirMjrTrans" = return("indirect trans freq between major states"),
	"dirMnrTrans" = return("direct trans freq between minor states"))
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

# this function takes in a dataframe or tibble, runs partial correlation on all variables and print the result summary
printParCorResults <- function(data, prefix) {
	res <- pcor(data)
	estimates <- res$estimate
	pvalues <- res$p.value
	varnames <- colnames(estimates)
	Nvar = length(varnames)
	print(sprintf("(%s) running partial correlation for: (%s)", toupper(prefix), paste(varnames, collapse = ',')))
	cnt = 1;
	for(jj in c(1:(Nvar-1))) {
	 for (kk in c((jj+1):Nvar)) {
	   var1 <- varnames[jj]
	   var2 <- varnames[kk]
	   signif_star = "";
	   if (pvalues[var1, var2] <= 0.05) {
	   signif_star = "***"
	   }
	   print(sprintf("  %s(%s) %s vs %s. r = %f, p = %f", signif_star, letters[cnt], var1, var2, estimates[var1, var2], pvalues[var1, var2]))
	   cnt = cnt + 1;
	 }
	}
}
# hashMatch is a function which applies a hash `hashObj` on a list of vectors (keys) to get a list of values.
hashMatch <- function(hashObj, listObj)
{
    lapply(listObj, function(z)
        {
            hashObj[[z]]
        })
}

# finds outliers by calculating the residuals from a linear model fit. Any data point with |residual| > 2*std is tagged as outlier in a table where columns are `indp`, `depnd`, `residuals`, `outlier`
# indp and depnd are independent and dependent variables respectively
# reference: https://stats.libretexts.org/Bookshelves/Introductory_Statistics/Book%3A_Introductory_Statistics_(OpenStax)/12%3A_Linear_Regression_and_Correlation/12.07%3A_Outliers
outlierDetector <- function(data, indp, depnd, printMsg) {
  filteredData <- eval(parse(text=sprintf("data %%>%% filter(!is.na(%s), !is.na(%s))", indp, depnd)))
  fit <- eval(parse(text=sprintf("lm(%s ~ %s, filteredData)", depnd, indp)))
  lmTibble <- eval(parse(text=sprintf("tibble(group = filteredData$group, %s = filteredData$%s, %s = filteredData$%s, residuals = residuals(fit))", indp, indp, depnd, depnd))) 
  #square the residuals and sum them. 
  SSE <- sum((lmTibble$residuals)*(lmTibble$residuals))
  N <- length(lmTibble$residuals)
  std <- sqrt(SSE/(N-2))
  #outliers <- lmTibble %>% filter(abs(residuals) > 2*std)
  outlierRemoved <- lmTibble %>% filter(abs(residuals) <= 2*std)
  res <- eval(parse(text=sprintf("cor.test(outlierRemoved$%s, outlierRemoved$%s)", indp, depnd)))
  if (res$p.value <= 0.05) {
     signif_star = "***"
   } else { 
     signif_star = ""
   }
  print(sprintf('%s %s. r = %f, p = %f', signif_star, printMsg, res$estimate, res$p.value))
  # implement a vector of outlier boolean values
  lmTibble$outlier <- ifelse(abs(lmTibble$residuals) > 2*std, TRUE, FALSE)
  return(lmTibble)
}

# plotter  of multiple correlations of a group (ASD/TD) on a single plot
# the x-axis data will be a single val, but this implementation supports multiple vals
# the y-axis data can be multiple vals.
# nRows and nCols are user passed values to arrangeGrob
# addYAxisPercent contains true, false values for whether '%' symbol is to be added on y-axis.
# note: please add percentage support if required
plotMultipleCorrelation <- function(data, group, nRows, nCols, xDataList, yDataList, xLabelList, yLabelList, addYAxisPercent, plotTitle, dataInfo) {

	Nx <- length(xDataList);
	Ny <- length(yDataList);
	# please catch an error if length of x/y data points, don't match 
	if (Nx != length(unique(xLabelList))) {
	  stop("message - the number of x data points and x labels don't match")
	}
	if (Ny != length(yLabelList)) {
	  stop("message - the number of y data points and y labels don't match")
	}
	tdflag = FALSE; coloradjust <- NULL;
	if (tolower(group) == "td") { #TD, to use blue color for plotting later.
	  coloradjust <- scale_color_manual(values=c("TD"="#6290c1"))
	  tdflag = TRUE;
	}
	cnt = 0
	plots <- vector("list", Nx*Ny) # to contain individual plots
	# make the plots
	for (xind in c(1:Nx)) {
	 xval = xDataList[[xind]]; xlabel = xLabelList[[xind]];
	 for (yind in c(1:Ny)) {
	 yval = yDataList[[yind]]; ylabel = yLabelList[[yind]];
	 percentY="FALSE"
	 if (addYAxisPercent[[yind]] == TRUE) {percentY="TRUE"}
	 
         # insert outlier detection code here.
	 corrMessage <- sprintf('(outlier removed - %s) %s vs %s', dataInfo, xval, yval)  #message to be used in correlation
	 outlierTibble <- outlierDetector(data, xval, yval, corrMessage)
	 outlierRemoved <- outlierTibble %>% filter(outlier == FALSE)
	 outliers <- outlierTibble %>% filter(outlier == TRUE)
	 
         mapping <- eval(parse(text=sprintf('aes(x=%s, y=%s, color=group)', xval, yval))) 
	 cnt = cnt + 1;
	 plots[[cnt]] <- eval(parse(text=sprintf("scatterPlotter(outlierRemoved, mapping, mapping, 'lm', xlabel, ylabel, %s, FALSE, NULL)", percentY)))
	 # insert outliers on top of the previous plot
	 plots[[cnt]] <- plots[[cnt]] + geom_point(data=outliers, eval(parse(text=sprintf("aes(x=%s, y=%s)", xval, yval))), shape=7, size=3.5)  #shape 7 is a square with a cross inside

	 if (tdflag) { #set the color
	  coloradjust <- scale_color_manual(values=c("TD"="#6290c1"))
	  plots[[cnt]] <- plots[[cnt]] + coloradjust
	 }
	 # call ggsave to test - It works. 
	 plotname <- sprintf('%s_vs_%s', xval, yval)
	 #ggsave(plots[[cnt]], width=7, file=sprintf("%s.pdf", plotname))
	 }
	}
	# create arrangeGrob object
	headstart <- "arrangeGrob("
	payload <- "plots[[1]]"
	for (jj in seq(2,cnt,1)) {
	   payload <- c(payload, sprintf("plots[[%d]]", jj))
	}
	payload <- paste(payload, collapse=",")
	tailend <- sprintf(",nrow=%d, ncol=%d,top=plotTitle)", nRows, nCols)
	finalObj <- paste0(headstart, payload, tailend, collapse="")
	#print(finalObj)
	# evaluate the arrangeGrob object
	resultFig <- eval(parse(text=sprintf("%s", finalObj))) 
	#ggsave(resultFig, width=13, file="asd_child_majorStFCGap_plots.pdf")
	return(resultFig)
}


