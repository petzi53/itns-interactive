# itns-03 PICTURE DATA 2020-04-17

shinyServer(function(input, output, session) {

    data <- reactiveVal(df)

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

    observeEvent(input$histPlotDT_cell_edit, {
        t <- data()
        info <- input$histPlotDT_cell_edit
        # info$value is always character. Has to be converted to numeric
        # check if string can be converted to numeric
        if (suppressWarnings(is.na(as.numeric(info$value)))) {
            session$sendCustomMessage(type = 'myMessage',
                          message = list(paste("'", info$value,
                          "'= wrong data type.",
                          "Only numeric values allowed.")))

            # replace with previous value
            # even if row is integer is "as.numeric" necessary
            # otherwise it would also replace variable name
            info$value <- as.numeric(data()[info$row, ])
            } else {

            # yes, it can be converted: then do it!
            info$value <- as.numeric(info$value)
        }

        # only input between 0 and 6 * sd is allowed
        maxData = round(sd(data()[[1]]) * 6, 0)
        if (info$value <= 0 ||
            info$value > maxData) {
            session$sendCustomMessage(type = 'myMessage',
              message = list(paste("'", info$value,
                                   "' = outside of possible range for this dataset.",
                                   " Values only between 0 and ",
                                   maxData, " allowed.")))

            # replace with previous value
            info$value <- as.numeric(data()[info$row, ]) # just the value, see above
        }

        t <- data()
        t[info$row, info$col] <- as.numeric(info$value)
        data(t)
        output$histPlotDTDT = renderDT(myData())
    })

    observeEvent(input$delete, {
        if (input$id == 'Histogram') {
            isolate(tableDT  <-  input$histoPlotDT_rows_selected)
        }
        if (input$id == 'Dot Plot') {
            isolate(tableDT = input$dotPlotDT_rows_selected)
        }

        if (is.null(tableDT)) {
            session$sendCustomMessage(type = 'myMessage',
              message = "Select row you want to delete.")
        } else {
            data(data()[-tableDT, , drop = FALSE])
        }
    })


    observeEvent(input$add, {
        t <- rbind(median(data()[[1]]), data())
        data(t)
        output$myDT = renderDT(myData())
    })

    observeEvent(input$reset, {
        data(dataOrig)
    })

    output$summary <- renderPrint({
        summary(data())
    })


}) # shinyServer
