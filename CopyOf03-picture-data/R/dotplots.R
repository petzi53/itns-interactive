################### Generate dotplots #####################

# test dotplot
output$dotPlot3 <- renderPlot({
        ggplot(data(),
            aes_string(paste0("`", colnames(data())[1], "`"))) +
            geom_dotplot(method = "dotdensity",
                     binwidth = 1, # or 0.1 for simple dot plot
                     dotsize = 1, # or 10 for simple dot plot
                     stackratio = 1, # or 0.0 for a simple dot plot (not stacked)
                     fill = myFillColor,
                     color = myBorderColor) +
            ggthemes::theme_clean() +
            scale_x_continuous(paste0("X (", colnames(data())[1], ")"),
                               breaks = seq(0, max(data()[[1]] + 1), 1)) +
            scale_y_continuous(NULL, breaks = NULL) +
            rugPlot
})

output$dotPlot2 <- renderPlot({
    ggplot(data(),
           aes_string(paste0("`", colnames(data())[1], "`"))) +
        geom_dotplot(method = "dotdensity",
                     binwidth = 0.1, # or 1 for stacked dot plot
                     dotsize = 10, # or 1 for stacked dot plot
                     stackratio = 0, # or or 1 for stacked dot plot
                     fill = myFillColor,
                     color = myBorderColor) +
        ggthemes::theme_clean() +
        scale_x_continuous(paste0("X (", colnames(data())[1], ")"),
                           breaks = seq(0, max(data()[[1]] + 1), 1)) +
        scale_y_continuous(NULL, breaks = NULL) +
        rugPlot
})


output$clickInfo2 <- renderPrint({
#    str(input$dotPlot2Click$x)
    dot <- as.numeric(input$dotPlot2Click$x)
    dot
    data()[abs(data()$dot - event.data$x)]
})

# factor out the same parts for both variants
myDotPlot <-
    isolate(ggplot(data(),
        aes_string(paste0("`", colnames(data())[1], "`"))) +
        ggthemes::theme_clean() +
        scale_x_continuous(paste0("X (", colnames(data())[1], ")"),
                           breaks = seq(0, max(data()[[1]] + 1), 1)) +
        scale_y_continuous(NULL, breaks = NULL)
    )
#

rugPlot <- geom_rug(color = "red",
                    sides = "b",
                    length = unit(3, "mm"))


# Generate a simple dotplot with rugs of the data ----
simpleDotPlot <-
    isolate(myDotPlot +
    labs(title = "Simple Dot Plot") +
    geom_dotplot(method = "dotdensity",
                 binwidth = 0.1, # or 1 for stacked dot plot
                 dotsize = 10, # or 1 for stacked dot plot
                 stackratio = 0, # or or 1 for stacked dot plot
                 fill = myFillColor,
                 color = myBorderColor
    ))


# Generate a stacked dotplot with rugs of the data ----
stackedDotPlot <-
    isolate(myDotPlot +
    labs(title = "Stacked Dot Plot") +
    geom_dotplot(method = "dotdensity",
                 binwidth = 1, # or 0.1 for simple dot plot
                 dotsize = 1, # or 10 for simple dot plot
                 stackratio = 1, # or 0.0 for a simple dot plot (not stacked)
                 fill = myFillColor,
                 color = myBorderColor
    ))

re_stackedDotPlot <- reactive({
    if (input$ragValue) { stackedDotPlot + rugPlot }
    else {stackedDotPlot}
})

re_simpleDotPlot <- reactive({
    if (input$ragValue) { simpleDotPlot + rugPlot }
    else {simpleDotPlot}
})


# put the two dotplots vartically together
# using package `cowplot`
re_plots <- reactive({
    plots <- list(re_simpleDotPlot(), re_stackedDotPlot())
    grobs <- lapply(plots, cowplot::as_grob)
    plot_widths <- lapply(grobs, function(x) {x$widths})

    # Aligning the left an right margins of all plots
    aligned_widths <- cowplot::align_margin(plot_widths, "first")
    aligned_widths <- cowplot::align_margin(aligned_widths, "last")

    # Setting the dimensions of plots to the aligned dimensions
    for (i in seq_along(plots)) {
        grobs[[i]]$widths <- aligned_widths[[i]]
    }

    # Draw aligned plots
    cowplot::plot_grid(plotlist = grobs, ncol = 1)
})

output$twoDotPlots <- renderPlot({
    re_plots()
})

