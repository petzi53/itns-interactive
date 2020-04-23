# itns-03 PICTURE DATA 2020-04-17

shinyServer(function(input, output, session) {

    data <- reactiveVal(df)
    reVal <-  reactiveValues()

    myData <- reactive({
        datatable(
            data(),
            selection = 'single',
            editable = list(
                target = "cell", disable = list(columns = 0)),
            colnames = c('ID' = 1)
        )
    })


    output$dotPlotDT = renderDT(myData())
    output$histPlotDT = renderDT(myData())


    # Generate histograms with different bins ----
    source("R/histograms.R", local = TRUE)
    #
    # # Generate dotplots with rugs ----
    source("R/dotplots.R", local = TRUE)


    # calculate sampe size for info string
    output$N <- renderText({
        length(data()[[1]])
    })

    observeEvent(reVal$info, {

        t <- data()
        info <- reVal$info

        # info$value is always character. Has to be converted to numeric
        # check if string can be converted to numeric
        if (suppressWarnings(is.na(as.numeric(info()$value)))) {
            session$sendCustomMessage(type = 'myMessage',
                          message = list(paste("'", info()$value,
                          "'= wrong data type.",
                          "Only numeric values allowed.")))

            # replace with previous value
            # even if row is integer is "as.numeric" necessary
            # otherwise it would also replace variable name
            tableValue <- as.numeric(data()[info()$row, ])
            } else {

            # yes, it can be converted: then do it!
            tableValue <- as.numeric(info()$value)
            }

        # only input between 0 and 6 * sd is allowed
        maxData = round(sd(data()[[1]]) * 6, 0)
        if (tableValue <= 0 ||
            tableValue > maxData) {
            session$sendCustomMessage(type = 'myMessage',
              message = list(paste("'", tableValue,
                                   "' = outside of possible range for this dataset.",
                                   " Values only between 0 and ",
                                   maxData, " allowed.")))

            # replace with previous value
            tableValue <- as.numeric(data()[info()$row, ]) # just the value, see above
        }

        t <- data()
        t[info()$row, info()$col] <- as.numeric(tableValue)
        data(t)
        if (reVal$table == "Histogram") {
            output$histPlotDT = renderDT(myData())
        } else {
            output$dotPlotDT = renderDT(myData())
        }
    })

    observeEvent(input$histPlotDT_cell_edit, {
        reVal$info <- reactive(input$histPlotDT_cell_edit)
        reVal$table <- "Histogram"
    })

    observeEvent(input$dotPlotDT_cell_edit, {
        reVal$info <- reactive(input$dotPlotDT_cell_edit)
        reVal$table <- "Dot Plot"
    })

    observeEvent(input$dataset, {
        if (input$dataset == "Histogram") {
            reVal$rows_selected <- reactive(input$histPlotDT_rows_selected)
        }
        if (input$dataset == "Dot Plot") {
            reVal$rows_selected <- reactive(input$dotPlotDT_rows_selected)
        }
    })

    updatePlots <- eventReactive(input$update, {
        input$delete
    })


    observeEvent(input$delete, {
        if (is.null(reVal$rows_selected())) {
            session$sendCustomMessage(type = 'myMessage',
              message = "Select row you want to delete.")
        } else {

            data(data()[-(reVal$rows_selected()), , drop = FALSE])
#            dataModified <<- data()[-(re()), , drop = FALSE]
        }
    })

    observeEvent(input$add, {
        t <- rbind(median(data()[[1]]), data())
        data(t)
    })

    observeEvent(input$reset, {
        data(dataOrig)
    })

    output$summary <- renderPrint({
        summary(data())
    })


}) # shinyServer
