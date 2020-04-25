# itns-03 PICTURE DATA 2020-04-24
# dotplots.R

################### Generate dotplots #####################

myDotPlot <-  function(thePlot, distance = 0.05) {
    # parameter thePlot (simple or stacked) and
    # parameter distance (x-axis from graphical object)

    if (input$ragValue) {rugs = rugPlot} else {rugs = NULL}

    ggplot(data$real,
        aes_string(paste0("`", colnames(data$real)[1], "`"))) +
        ggthemes::theme_clean() +
        scale_x_continuous(paste0("X (", colnames(data$real)[1], ")"),
           breaks = seq(0, max(data$real[[1]] + 1), 1)) +
        scale_y_continuous(
           expand = expansion(add = distance),
                    NULL, breaks = NULL) +
        thePlot() +
        rugs
}

