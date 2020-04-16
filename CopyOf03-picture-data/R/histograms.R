# itns-03 PICTURE DATA 2020-04-15

# Generate histograms with different bins ----

binsBoundary <-  function(binsNr) {
    bins <- round(seq(min(data()[[1]]), max(data()[[1]]), length.out = binsNr - 1), 2)
    binRange <- range(bins)
    binMargin <- round(((binRange[2] - binRange[1]) / (binsNr - 1)), 2)
    binStart <- 0 - (binMargin / 2)
    binEnd <- binRange[2] + (binMargin / 2)
    binBorders <- seq(from = binStart, to = binEnd, by = binMargin)
}

# binsBoundary <-  function(binsNr) {
#     bins <- seq(min(data()[[1]]), max(data()[[1]]), length.out = binsNr - 1)
#     binRange <- range(bins)
#     binMargin <- (binRange[2] - binRange[1]) / (binsNr - 1)
#     binStart <- 0 - (binMargin / 2)
#     binEnd <- binRange[2] + (binMargin / 2)
#     binBorders <- seq(from = binStart, to = binEnd, by = binMargin)
# }

plotHist <- function(binsNr, binBorders, histoTitle) {

    if (input$ragValue2) {rugs = rugPlot
    } else {rugs = NULL}
        ggplot(data(), aes_string(paste0("`", colnames(data())[1], "`"))) +
        geom_histogram(bins = binsNr, fill = myFillColor, color = myBorderColor) +
        ggthemes::theme_clean() +
        scale_y_continuous(breaks = scales::breaks_extended(8)) +
        scale_x_continuous(sec.axis =
           sec_axis(trans = ~., breaks = binBorders,
                    guide_axis(title = "Bin Boundaries"))) +
        ggtitle(histoTitle) +
        labs(x = paste0("X (", colnames(data())[1], ")"), y = "Frequency") +
        rugs
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

