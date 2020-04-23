# itns-03 PICTURE DATA 2020-04-20


shinyServer(function(input, output, session) {

    ### Initialize server (first run)
    source("R/init.R", local = TRUE)

    ### Generate histograms with different bins ----
    source("R/histograms.R", local = TRUE)
    #
    ### Generate dotplots with rugs ----
    source("R/dotplots.R", local = TRUE)


############    prepare data & display data    ################

    data <- reactiveValues(
        real = as_tibble(dataOriginal),
        virtual = as_tibble(rowid_to_column(dataOriginal))
        )

    showData <- reactive({
        DT::datatable(
            data$virtual,
            rownames = FALSE,
            selection = 'single',
            colnames = c('ID' = 1),
            editable = list(
                target = "cell", disable = list(columns = 0))
        ) %>%
        DT::formatRound(columns = 1, digits = 0) %>%
        DT::formatRound(columns = 2, digits = 1)
    })

    proxy <- dataTableProxy("myDT")

    getCellValue <-  function(info) {
        data$dirty = TRUE
        i = info$row
        j = info$col
        k = tryCatch({
            as.numeric(info$value)
        }, warning = function(war) {
            data$dirty = FALSE
            k = data$virtual[i,j]
        })
        data$virtual[i,j] = k
        data$virtual
    }

    observeEvent(input$myDT_cell_edit, {
        showData <- DT::replaceData(
            proxy,
            getCellValue(input$myDT_cell_edit),
            resetPaging = FALSE
            )
    })


#######################  Outputs  ############################

    sliderInputUI <- function(id, label="Number of bins:", min=5, max=20, value=9) {
        sliderInput(
            id,
            label = label,
            min = min,
            max = max,
            value = value
        )
    }


    output$myDT <- DT::renderDT(showData())


    output$N <- renderText({
        nrow(data$real)
    })

    output$summary <- renderPrint({
        summary(data$real)
    })



##############  modalDialog for add value  ###################

    maxValue <- function() {
        round(sd(data$virtual[[2]]) * 6, 0)
    }

    # Return the UI for a modal dialog with data selection input. If 'failed' is
    # TRUE, then display a message that the previous value was invalid.
    dataModal <- function(failed = FALSE) {
        modalDialog(
            numericInput("newValue", "New value:",
                      value = NULL, min = 0, max = maxValue(),
                      width = '100px'
            ),
            span('(Allowed for this dataset are positive values smaller',
                 'than 6 times of the standard deviations, which is currently'),
            maxValue(),
            span('.)', .noWS = "before"),
            if (failed)
                div(tags$b("Invalid value.", style = "color: red;")),

            footer = tagList(
                modalButton("Cancel"),
                actionButton("ok", "OK")
            )
        )
    }



    # When OK button is pressed, check the new value.
    # If successful remove the modal.
    # If not successful than show another modal,
    # but this time with a failure message.
    observeEvent(input$ok, {
        # Check if input is allowed
        if (input$newValue >= 0 && input$newValue <= maxValue() &&
            !is.logical(input$newValue)) {
            data$virtual <- rbind(data$virtual,
                  c(data$virtual$rowid[nrow(data$virtual)] + 1, input$newValue))
            removeModal()
        } else {
            showModal(dataModal(failed = TRUE))
        }
    })

##########################    Buttons    ###########################

    observeEvent(input$plotBtn, {
        if (input$plotBtn > 0) {      # Do not change UI values in the first run
            if (plotButton == "Dot Plot") {
                updateActionButton(
                    session, "plotBtn", "Histogram")
                plotHeader <<- "Dot Plot"
                plotButton <<- "Histogram"
            } else if (plotButton == "Histogram") {
                updateActionButton(
                    session, "plotBtn", "Dot Plot")
                plotHeader <<- "Histogram"
                plotButton <<- "Dot Plot"
            } # else if
        } # outer if
        ## always print correct header and plot type
        output$plotUIHeader <- renderUI({
            HTML("<center><h2>", plotHeader, "</h2></center>")
        })
        if (plotHeader == "Dot Plot") {
            output$plotUISliders <- renderUI("") # output empty string
            output$showUIPlot <- renderUI({
                tagList(
                    output$dotPlotSimple <- renderPlot({
                        myDotPlot(myDotPlotSimple)
                    }),
                    br(),
                    output$dotPlotStacked <- renderPlot({
                        myDotPlot(myDotPlotStacked)
                    })
                ) # taglist
            }) # output dot plot
        }
        if (plotHeader == "Histogram") {
            output$plotUISliders <- renderUI({
                tagList(
                    sliderInputUI("bins1", "Number of bins: Histogram 1", value = 5),
                    sliderInputUI("bins2", "Number of bins: Histogram 2", value = 14)
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
    },
    ignoreNULL = FALSE            # run this observer also with initial settings
    )


    observeEvent(input$delete, {
        data$virtual <- data$virtual[-input$myDT_rows_selected, , drop = FALSE]
        shinyjs::enable(id = "reset")
        shinyjs::enable(id = "update")
        shinyjs::disable(id = "delete")
        })

    observeEvent(input$myDT_cell_edit, {
        shinyjs::toggleState(id = "reset", data$dirty == TRUE)
        shinyjs::toggleState(id = "update", data$dirty == TRUE)
    })

    observeEvent(input$myDT_rows_selected, {
        shinyjs::enable(id = "delete")
    })

    observeEvent(input$reset, {
        data$virtual <- as_tibble(rowid_to_column(dataOriginal))
        data$real <- as_tibble(dataOriginal)
        shinyjs::disable(id = "reset")
        shinyjs::disable(id = "update")
    })

    observeEvent(input$update, {
        data$real <- as_tibble(data$virtual[2])
        data$virtual <- as_tibble(rowid_to_column(data$real))
        shinyjs::disable(id = "update")
    })


    observeEvent(input$add, {
        showModal(dataModal())
        shinyjs::enable(id = "reset")
        shinyjs::enable(id = "update")
    })


}) # shinyServer
