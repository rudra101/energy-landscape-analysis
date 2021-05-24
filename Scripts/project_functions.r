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
# groupInfoAvailable carries the truth value if there is a column called `group` in the data provided to this function.
outlierDetector <- function(data, indp, depnd, printMsg, display=TRUE, groupInfoAvailable=TRUE) {
  filteredData <- eval(parse(text=sprintf("data %%>%% filter(!is.na(%s), !is.na(%s))", indp, depnd)))
  fit <- eval(parse(text=sprintf("lm(%s ~ %s, filteredData)", depnd, indp)))
  if (groupInfoAvailable) {
    lmTibble <- eval(parse(text=sprintf("tibble(group = filteredData$group, %s = filteredData$%s, %s = filteredData$%s, residuals = residuals(fit))", indp, indp, depnd, depnd))) 
  } else {
    lmTibble <- eval(parse(text=sprintf("tibble(%s = filteredData$%s, %s = filteredData$%s, residuals = residuals(fit))", indp, indp, depnd, depnd))) 
  }

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
  if (display) {
     print(sprintf('%s %s. r = %f, p = %f', signif_star, printMsg, res$estimate, res$p.value))
  }
  # implement a vector of outlier boolean values
  lmTibble$outlier <- ifelse(abs(lmTibble$residuals) > 2*std, TRUE, FALSE)
  return(lmTibble)
}

# print partial correlation results, but with outlier removed for each pair at a time.
# Using the algorithm given in Wikipedia: https://en.wikipedia.org/wiki/Partial_correlation
# the algorithm calculates partial cor using the residuals(of X and Y) against the control var (Y).
removeOutlierAndPrintParCorResults <- function(data, identifier) {
	metrics <- colnames(data)
	N <- length(metrics)
	if (N != 3) {
          stop(sprintf("this function runs partial correlation for 3 variables. Found %d columns instead in the data provided.", N))
	}
	print((sprintf("(%s) partial cor analysis for (%s)", identifier, paste(metrics, collapse=","))))
	indices = c(1,2,3)
	for (ind in indices) { # each index will be the variable that acts as a controlling variable for this iteration
	  varIndices = setdiff(indices, ind) # calculate the difference of sets {1,2,3} - {ind} 
          metricsOfInterest = metrics[varIndices]
          metric1 = eval(parse(text=sprintf("data$%s", metricsOfInterest[1])));
	  metric2 = eval(parse(text=sprintf("data$%s", metricsOfInterest[2])));
	  control = eval(parse(text=sprintf("data$%s", metrics[ind])));
	  mm1 = lm(metric1 ~ control); res1 = mm1$residuals;
	  mm2 = lm(metric2 ~ control); res2 = mm2$residuals;
          dataRes = tibble("res1" = res1, "res2" = res2) 
	  resOutliers = outlierDetector(dataRes, "res1", "res2", "", FALSE, FALSE)
	  outliersRemoved = resOutliers %>% filter(!outlier)
	  res = cor.test(outliersRemoved$res1, outliersRemoved$res2)
	  signif_star = ""
	  if (res$p.value <= 0.05) {
	     signif_star = "***"
	  }
	  print(sprintf("  %s %s vs %s. r = %f, p = %f", signif_star, metricsOfInterest[1], metricsOfInterest[2], res$estimate, res$p.value))
	}
}

# plotter  of multiple correlations of a group (ASD/TD) on a single plot
# the x-axis data will be a single val, but this implementation supports multiple vals
# the y-axis data can be multiple vals.
# nRows and nCols are user passed values to arrangeGrob
# addYAxisPercent contains true, false values for whether '%' symbol is to be added on y-axis.
plotMultipleCorrelation <- function(data, group, nRows, nCols, xDataList, yDataList, xLabelList, yLabelList, addYAxisPercent, addXAxisPercent, plotTitle, dataInfo) {

	Nx <- length(xDataList);
	Ny <- length(yDataList);
	# please catch an error if length of x/y data points, don't match 
	if (Nx != length(unique(xLabelList))) {
	  stop("message - the number of x data points and x labels don't match")
	}
	if (Ny != length(yLabelList)) {
	  stop("message - the number of y data points and y labels don't match")
	}
	tdflag = FALSE; asdTdFlag = FALSE; coloradjust <- NULL;
	if (tolower(group) == "td") { tdflag = TRUE; }
	else if(tolower(group) == "asd+td") {asdTdFlag = TRUE;}
	cnt = 0
	plots <- vector("list", Nx*Ny) # to contain individual plots
	# make the plots
	for (xind in c(1:Nx)) {
	 xval = xDataList[[xind]]; xlabel = xLabelList[[xind]];
	 percentX="FALSE"
	 if (!is.null(addXAxisPercent) && addXAxisPercent[[xind]] == TRUE) {percentX="TRUE"}
	 
         for (yind in c(1:Ny)) {
	  yval = yDataList[[yind]]; ylabel = yLabelList[[yind]];
	  percentY="FALSE"
	  if (!is.null(addYAxisPercent) && addYAxisPercent[[yind]] == TRUE) {percentY="TRUE"}
	  
	  if (!asdTdFlag) {
		 # insert outlier detection code here.
		 corrMessage <- sprintf('(outlier removed - %s) %s vs %s', dataInfo, xval, yval)  #message to be used in outlierDetectorCode
		 outlierTibble <- outlierDetector(data, xval, yval, corrMessage)
		 outlierRemoved <- outlierTibble %>% filter(outlier == FALSE)
		 outliers <- outlierTibble %>% filter(outlier == TRUE)
		 
		 ##**** the main plot
		 mapping <- eval(parse(text=sprintf('aes(x=%s, y=%s, color=group)', xval, yval))) 
		 cnt = cnt + 1;
		 plots[[cnt]] <- eval(parse(text=sprintf("scatterPlotter(outlierRemoved, mapping, mapping, 'lm', xlabel, ylabel, %s, %s, NULL)", percentY, percentX)))
		 
		 ##*** insert outliers on top of the previous plot
		 outlierColor = "#8b0000ff"
		 if (tdflag) {
		    outlierColor = "#6290c1"
		 }
		 plots[[cnt]] <- plots[[cnt]] + geom_point(data=outliers, eval(parse(text=sprintf("aes(x=%s, y=%s)", xval, yval))), shape=7, size=3.2, color=outlierColor)  #shape 7 is a square with a cross inside

		 #coloradjust <- scale_color_manual(values=c("TD"="#6290c1", "ASD"="#8b0000ff"))
		 #plots[[cnt]] <- plots[[cnt]] + coloradjust
	  }
	  else { #handle both ASD and TD in same plots.
	        # start with ASD and its outliers
		asdData = data %>% filter(group == 'ASD')
	        corrMessage <- sprintf('(outlier removed - ASD %s) %s vs %s', dataInfo, xval, yval)  #message to be used in outlierDetectorCode
		asdOutlierTibble <- outlierDetector(asdData, xval, yval, corrMessage)
		# start with TD and its outliers
		tdData = data %>% filter(group == 'TD')
	        corrMessage <- sprintf('(outlier removed - TD %s) %s vs %s', dataInfo, xval, yval)  #message to be used in outlierDetectorCode
		tdOutlierTibble <- outlierDetector(tdData, xval, yval, corrMessage)
                # combine the outlier tibbles
	        asd_td_outlierTibble = rbind(asdOutlierTibble, tdOutlierTibble)
	        asd_td_outliersRemoved = asd_td_outlierTibble %>% filter(!outlier)	
	        asd_td_outliers = asd_td_outlierTibble %>% filter(outlier == TRUE)	
		
		# start the plotting code
		mapping <- eval(parse(text=sprintf('aes(x=%s, y=%s, color=group)', xval, yval))) 
                cnt = cnt + 1;
                plots[[cnt]] <- eval(parse(text=sprintf("scatterPlotter(asd_td_outliersRemoved, mapping, mapping, 'lm', xlabel, ylabel, %s, %s, NULL)", percentY, percentX)))
		# add outliers
		asd_outliers = asd_td_outliers %>% filter(group == "ASD")
		td_outliers = asd_td_outliers %>% filter(group == "TD")

		plots[[cnt]] <- plots[[cnt]] + geom_point(data=td_outliers, eval(parse(text=sprintf("aes(x=%s, y=%s)", xval, yval))), shape=7, size=3.2, color="#6290c1") + geom_point(data=asd_outliers, eval(parse(text=sprintf("aes(x=%s, y=%s)", xval, yval))), shape=7, size=3.2, color="#8b0000ff")  #shape 7 is a square with a cross inside
	  
	  }
	  coloradjust <- scale_color_manual(values=c("TD"="#6290c1", "ASD"="#f8766dff")) # blue for TD, red for ASD
	  plots[[cnt]] <- plots[[cnt]] + coloradjust #plotname <- sprintf('%s_vs_%s', xval, yval)
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


