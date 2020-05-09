# itns-03 PICTURE DATA 2020-05-08

meanPlot <- function(df) {
    geom_vline(xintercept = isolate(mean(df)),
               color = "Red",
               linetype = "solid",
               size = .8)
}

medianPlot <- function(df) {
    geom_vline(xintercept = isolate(median(df)),
               color = "Chartreuse",
               linetype = "solid",
               size = .8)
}

modePlot <- function(df) {
    myModes <- isolate(Modes(df))
    if (length(df) == length(myModes))
        return(NULL)
    geom_vline(xintercept = myModes,
               color = "Orange",
               linetype = "solid",
               size = .8)
}

Modes <- function(x) {
    ux <- unique(x)
    tab <- tabulate(match(x, ux))
    ux[tab == max(tab)]
}

zScoresPlot <- function(df) {
    x = NULL
    myMean <-  isolate(mean(df))
    myMin <- isolate(min(df))
    myMax <- isolate(max(df))
    mySD <- isolate(sd(df))
    if (is.null(myMin)) {
        i <- ceiling(myMean / mySD)
    } else {
        i <- ceiling(abs((myMean - myMin) / mySD))
    }
    j <- ceiling((myMax - myMean) / mySD)
    for(k in 1:i) {
        x <- c(x, myMean - (k * mySD))
    }
    for(k in 1:j) {
        x <- c(x, myMean + (k * mySD))
    }
    geom_vline(xintercept = c(x),
               color = "Orchid",
               linetype = "dotdash",
               size = .5)
}

quartilesPlot <- function(df) {
    geom_vline(xintercept = isolate(quantile(df)),
               color = "FireBrick",
               linetype = "dashed",
               size = .5)
}

percentilesPlot <- function(df) {
    geom_vline(xintercept = isolate(quantile(df, seq(0,1,0.1))),
               color = "Black",
               linetype = "dotted",
               size = .5)
}
