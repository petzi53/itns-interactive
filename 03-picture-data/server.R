# Define server logic
shinyServer(function(input, output) {

    # Generate histograms with different bins ----
    plotHist <-  function(newBins){
        bins <- seq(min(x_laptop), max(x_laptop), length.out = newBins + 1)

        hist(x_laptop, breaks = bins, col = "steelblue", border = myBorder,
             xlab = "X (Transcription in %)",
             main = "Histogram 2"
        )
    }

    observeEvent(input$bins1, {
        output$distPlot1 <-  renderPlot({plotHist(input$bins1)})
    })
    observeEvent(input$bins2, {
        output$distPlot1 <-  renderPlot({plotHist(input$bins2)})
    })


################### Generate dotplots #####################

    # factor out the same parts for both variants
    myDotPlot <-
        ggplot(df_laptop, aes(x = `Transcription%`)) +
        my_theme +
        scale_x_continuous("X (Transcription %)", breaks = seq(0, max(x_laptop + 1), 1)) +
        scale_y_continuous(NULL, breaks = NULL)

    rugPlot <- geom_rug(color = "red",
                        sides = "b",
                        length = unit(3, "mm"))


    # Generate a simple dotplot with rugs of the data ----
    simpleDotPlot <-
        myDotPlot +
        labs(title = "Simple Dot Plot") +
        geom_dotplot(method = "dotdensity",
                     binwidth = 0.1, # or 1 for stacked dot plot
                     dotsize = 10, # or 1 for stacked dot plot
                     stackratio = 0, # or or 1 for stacked dot plot
                     fill = myFillColor,
                     color = myColor
        )


    # Generate a stacked dotplot with rugs of the data ----
    stackedDotPlot <-
        myDotPlot +
        labs(title = "Stacked Dot Plot") +
        geom_dotplot(method = "dotdensity",
                     binwidth = 1, # or 0.1 for simple dot plot
                     dotsize = 1, # or 10 for simple dot plot
                     stackratio = 1, # or 0.0 for a simple dot plot (not stacked)
                     fill = myFillColor,
                     color = myColor
        )

    re_stackedDotPlot <- reactive({
        if (input$ragValue) { stackedDotPlot + rugPlot }
        else {stackedDotPlot + NULL}
    })

    re_simpleDotPlot <- reactive({
        if (input$ragValue) { simpleDotPlot + rugPlot }
        else {simpleDotPlot + NULL}
    })


    # put the two dotplots vartically together
    # using package `cowplot`
    re_plots <- reactive({
        plots <- list(re_simpleDotPlot(), re_stackedDotPlot())
        grobs <- lapply(plots, as_grob)
        plot_widths <- lapply(grobs, function(x) {x$widths})

        # Aligning the left an right margins of all plots
        aligned_widths <- align_margin(plot_widths, "first")
        aligned_widths <- align_margin(aligned_widths, "last")

        # Setting the dimensions of plots to the aligned dimensions
        for (i in seq_along(plots)) {
            grobs[[i]]$widths <- aligned_widths[[i]]
        }

        # Draw aligned plots
        plot_grid(plotlist = grobs, ncol = 1)
    })

    output$twoDotPlots <- renderPlot({
        re_plots()
    })

    # Generate a summary of the data ----
    # output$summary <- renderPrint({
    #     summary(df_laptop)
    # })


    # Generate an HTML table view of the data ----

    # re_dataTable <- reactive({
    #     df_laptop <- read_csv("Describe_Laptop.csv")
    #     x_laptop = df_laptop$`Transcription%`
    #     N = length(x_laptop)
    #     datatable(df_laptop, options = list(
    #       autoWidth = TRUE,
    #       columnDefs = list(list(width = '50px'))),
    #       editable = list(
    #           target = 'cell', disable = list(columns = 0)
    #       ),
    #     )
    # })

    # Generate an HTML table view of the data ----

    # v <- reactiveValues()
    # v$
    #     datatable(df_laptop,
    #               options = list(autoWidth = TRUE,
    #                              columnDefs = list(list(width = '10px', targets = c(0,1))))) %>%
    #         formatRound(columns = 'Transcription%', digits = 2)
    # )


    output$laptopTable <- renderDT({
        input$reset
        df_laptop <- read_csv("Describe_Laptop.csv")
        x_laptop = df_laptop$`Transcription%`
        dt_laptop

    })


    # observeEvent(input$reset, {
    #     df_laptop <- read_csv("Describe_Laptop.csv")
    #     x_laptop = df_laptop$`Transcription%`
    #     N = length(x_laptop)
    # })

    output$cellData <- renderPrint({
        cat(file = stderr(), "Endlich! ", input$laptopTable_cell_edit, "\n")
        # input$laptopTable_cell_edit
    })

})
