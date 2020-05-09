# itns-03 PICTURE DATA 2020-04-24
# dotplots.R

################### Generate dotplots #####################

renderUIDotPlot <-  function() {
    output$plotUISliders <- renderUI("") # output empty string
    output$showUIPlot <- renderUI({
        tagList(
            output$dotPlotSimple <- renderPlot({
                myDotPlot(myDotPlotSimple, "Dot Plot 1 (Simple)")
            }),
            br(),
            output$dotPlotStacked <- renderPlot({
                myDotPlot(myDotPlotStacked, "Dot Plot 2 (Stacked)")
            })
        ) # taglist
    }) # output dot plot
}

myDotPlot <-  function(thePlot, dotPlotTitle, distance = 0.05) {
    # parameter thePlot (simple or stacked)
    # parameter dotPlotTitle (title of the Dot Plot)
    # distance (x-axis from graphical object),
        # distance only used as experimental constant to change manually

    if (input$rugValue) {rugs = rugPlot
    } else {rugs = NULL}
    if (input$locationMean) {myMean = meanPlot(data$real[[1]])
    } else {myMean = NULL}
    if (input$locationMedian) {myMedian = medianPlot(data$real[[1]])
    } else {myMedian = NULL}
    if (input$locationMode) {myMode = modePlot(data$real[[1]])
    } else {myMode = NULL}
    if (input$`spreadZ Scores`) {myZScores = zScoresPlot(data$real[[1]])
    } else {myZScores = NULL}
    if (input$spreadQuartiles) {myQuartiles = quartilesPlot(data$real[[1]])
    } else {myQuartiles = NULL}
    if (input$spreadPercentiles) {myPercentiles = percentilesPlot(data$real[[1]])
    } else {myPercentiles = NULL}

    ggplot(data$real,
        aes_string(paste0("`", colnames(data$real)[1], "`"))) +
        ggthemes::theme_clean() +
        ggtitle(dotPlotTitle) +
        scale_x_continuous(
            name = paste0("X (", colnames(data$real)[1], ")"),
            n.breaks = 20) +
        scale_y_continuous(
           expand = expansion(add = distance),
                    NULL, breaks = NULL) +
        thePlot() +
        rugs + myMean + myMedian + myMode + myZScores + myQuartiles + myPercentiles
}


