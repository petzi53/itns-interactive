# itns-03 PICTURE DATA 2020-04-28
# histograms.R

################### Generate histograms #####################


renderUIHistogram <- function() {
    output$plotUISliders <- renderUI({
        tagList(
            sliderValue("bins1", "Number of bins: Histogram 1", value =  slider1),
            sliderValue("bins2", "Number of bins: Histogram 2", value =  slider2)
        ) # tagList
    }) # output sliders
    output$showUIPlot <- renderUI({
        tagList(
            br(),
            plotOutput("distPlot1", height = 350),
            br(), br(),
            plotOutput("distPlot2", height = 350),
        ) # tagList
    }) # output histogram
}


plotHist <- function(binsNr, binBorders, histoTitle) {

    if (input$ragValue) {rugs = rugPlot
    } else {rugs = NULL}
        ggplot(data$real, aes_string(paste0("`", colnames(data$real)[1], "`"))) +
        geom_histogram(bins = binsNr, fill = myFillColor, color = myBorderColor) +
        ggthemes::theme_clean() +
        scale_y_continuous(expand = expansion(mult = 0.1),
                           breaks = scales::breaks_extended(8)) +
        scale_x_continuous(
            n.breaks = 20,
            sec.axis = sec_axis(trans = ~., breaks = binBorders,
                    guide_axis(title = "Bin Boundaries"))) +
        ggtitle(histoTitle) +
        labs(x = paste0("X (", colnames(data$real)[1], ")"), y = "Frequency") +
        rugs
}


binsBoundary <-  function(binsNr) {
    bins <- round(seq(min(data$real[[1]]), max(data$real[[1]]), length.out = binsNr - 1), 2)
    binRange <- range(bins)
    binMargin <- round(((binRange[2] - binRange[1]) / (binsNr - 1)), 2)
    binStart <- 0 - (binMargin / 2)
    binEnd <- binRange[2] + (binMargin / 2)
    binBorders <- seq(from = binStart, to = binEnd, by = binMargin)
}

observeEvent(input$bins1, {
    output$distPlot1 <-
        renderPlot({plotHist(
            input$bins1,
            binsBoundary(input$bins1),
            "Histogram 1")
        })
})

observeEvent(input$bins2, {
    output$distPlot2 <-
        renderPlot({plotHist(
            input$bins2,
            binsBoundary(input$bins2),
            "Histogram 2")
            })
})

