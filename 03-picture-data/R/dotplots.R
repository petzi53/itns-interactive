# itns-03 PICTURE DATA 2020-04-17

# Generate 2 dotplots with cowplot --------

################### Generate dotplots #####################

myDotPlot <-  function(whichDotPlot) {
    if (input$ragValue) {rugs = rugPlot} else {rugs = NULL}

    ggplot(data(),
        aes_string(paste0("`", colnames(data())[1], "`"))) +
        ggthemes::theme_clean() +
        scale_x_continuous(paste0("X (", colnames(data())[1], ")"),
           breaks = seq(0, max(data()[[1]] + 1), 1)) +
        scale_y_continuous(expand = expansion(add = 0.1),
           NULL, breaks = NULL) +
        whichDotPlot() +
        rugs
}

myDotPlotSimple <- function(){
    geom_dotplot(method = "dotdensity",
                 binwidth = 0.1,
                 dotsize = 10,
                 stackratio = 0,
                 fill = myFillColor,
                 color = myBorderColor)
}

myDotPlotStacked <- function(){
    geom_dotplot(method = "dotdensity",
                 binwidth = 1,
                 dotsize = 1,
                 stackratio = 1,
                 fill = myFillColor,
                 color = myBorderColor)
}

rugPlot <- geom_rug(color = "red",
                    sides = "b",
                    length = unit(5, "mm"))

output$dotPlotSimple <- renderPlot({
    myDotPlot(myDotPlotSimple)
})

output$dotPlotStacked <- renderPlot({
    myDotPlot(myDotPlotStacked)
})

