# itns-03 PICTURE DATA 2020-04-24
# histograms.R

#####################     included dataset    ###################

## dataset converted: so that no extra file load is necessary
## originated from df <- read_csv("Describe_Laptop.csv")
## produced with df <- dput(df)
df <- structure(list(`Transcription%` =
                         c(13.7, 21.1, 15.2, 30.4, 12.8, 9.6, 9.3, 17.7,
                           15.4, 8.7, 12.8, 10.6, 5.1, 16.7, 17.7, 8.7,
                           26.4, 18, 19, 16.9, 18.8, 8.5, 1.2, 11.5,
                           21.4, 10.3, 9, 12.8, 12, 34.7, 4.1)),
                class = c("spec_tbl_df", "tbl_df", "tbl", "data.frame"),
                row.names = c(NA, -31L),
                spec =
                    structure(list(cols = list(`Transcription%` =
                                                   structure(list(), class = c("collector_double",
                                                                               "collector"))),
                                   default = structure(list(), class = c("collector_guess",
                                                                         "collector")), skip = 1), class = "col_spec"))


################### Generate histograms #####################

plotHist <- function(binsNr, binBorders, histoTitle) {

    if (input$ragValue) {rugs = rugPlot
    } else {rugs = NULL}
        ggplot(data$real, aes_string(paste0("`", colnames(data$real)[1], "`"))) +
        geom_histogram(bins = binsNr, fill = myFillColor, color = myBorderColor) +
        ggthemes::theme_clean() +
        scale_y_continuous(expand = expansion(mult = 0.1),
                           breaks = scales::breaks_extended(8)) +
        scale_x_continuous(sec.axis =
                           sec_axis(trans = ~., breaks = binBorders,
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

