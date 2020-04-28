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

    if (input$ragValue) {rugs = rugPlot} else {rugs = NULL}

    ggplot(data$real,
        aes_string(paste0("`", colnames(data$real)[1], "`"))) +
        ggthemes::theme_clean() +
        ggtitle(dotPlotTitle) +
        scale_x_continuous(paste0("X (", colnames(data$real)[1], ")"),
           breaks = seq(0, max(data$real[[1]] + 1), 1)) +
        scale_y_continuous(
           expand = expansion(add = distance),
                    NULL, breaks = NULL) +
        thePlot() +
        rugs
}



