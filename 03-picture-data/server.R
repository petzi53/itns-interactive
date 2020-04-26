# itns-03 PICTURE DATA 2020-04-24

###########   functions without reactive values   #############

source("R/init.R", local = TRUE)

###########   central server function #################

shinyServer(function(input, output, session) {

    # first UI-run displays button "Dot Plot"
    # and display the plot of the histogram
    # = plotHeader of "Histogram"
    plotHeader <- "Dot Plot"
    plotButton <- "Histogram"

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
            options = list(stateSave = TRUE),
            rownames = FALSE,
            selection = 'single',
            colnames = c('ID' = 1),
            editable = list(
                target = "cell", disable = list(columns = 0))
        ) %>%
        DT::formatRound(columns = 1, digits = 0) %>%
        # in future change number of digits
        # by maximal decimal places in vector (column)
        DT::formatRound(columns = 2, digits = 1)
    })

    proxy <- dataTableProxy("myDT")

    # getCellValue <-  function(info) {
    #     i = info$row
    ###   (+1 because of special colum rowid and rownames = FALSE)
    ###   https://stackoverflow.com/a/54887868/7322615
    #     j = info$col + 1
    #     k = info$value
    #         tryCatch({
    #             k = as.numeric(k)
    #             shinyjs::enable(id = "reset")
    #             shinyjs::enable(id = "update")
    #             print(data$virtual)
    #             print(class(data$virtual))
    #             cat(file = stderr(), "Cell1", data$virtual[i,j][[1]],
    #                 "Class Cell1", class(data$virtual[i,j][[1]]), "\n")
    #             data$virtual[i,j][[1]] = k
    #             print(data$virtual)
    #             print(class(data$virtual))
    #             cat(file = stderr(), "Cell2", data$virtual[i,j][[1]],
    #                 "Class Cell2", class(data$virtual[i,j][[1]]), "\n")
    #         }, warning = function(war) {
    #             print(data$virtual)
    #             print(class(data$virtual))
    #             cat(file = stderr(), "Cell3", data$virtual[i,j][[1]],
    #                 "Class Cell3", class(data$virtual[i,j][[1]]), "\n")
    #             data$virtual[i,j][[1]] = data$virtual[i,j][[1]]
    #             print(data$virtual)
    #             print(class(data$virtual))
    #             cat(file = stderr(), "Cell4", data$virtual[i,j][[1]],
    #                 "Class Cell4", class(data$virtual[i,j][[1]]), "\n")
    #         })
    #     data$virtual
    #
    # }


#######################  Outputs  ############################

    # check state of DT
    # observeEvent(input$myDT_rows_selected,{
    #     output$info = renderPrint(input$myDT_state)})

    output$myDT <- DT::renderDT(showData())


    output$N <- renderText({
        nrow(data$real)
    })

    output$summary <- renderPrint({
        summary(data$real)
    })


##########################   Observer (mostly Buttons)    ###########################

    #############   FIRST VERSION #############
    # getCellValue <-  function(info) {
    #     k = NULL
    #     i = info$row
    #     j = info$col + 1 # +1 because of rowid_to_column
    #     k =  tryCatch({
    #         as.numeric(info$value)
    #         }, warning = function(war) {
    #             shinyFeedback::showSnackbar("valueNotChanged")
    #             k <<- as.numeric(data$virtual[i,j][[1]])
    #         }, finally = {
    #             if (is.null(k)) {
    #                 shinyjs::enable(id = "reset")
    #                 shinyjs::enable(id = "update")
    #             }
    #             k = as.numeric(k)
    #         })
    #     shinyjs::disable(id = "delete")
    #     data$virtual[i,j][[1]] = k
    #     data$virtual
    # }


    #############   SECOND VERSION #############
    # checkValue <- function(info) {
    #     v = "[\\!#$%&()*/:;<=>?@_`|~{}ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ]"
    #     i = info$row
    #     j = info$col + 1 # +1 because of rowid_to_column
    #     k = info$value
    #     if (regexec(v, k) == -1) {
    #         data$virtual[i,j][[1]] = as.numeric(k)
    #     }
    #     data$virtual
    # }

    #############   THIRD VERSION   ##################
    checkValue <- function(info) {
        i = info$row
        j = info$col + 1
        oldValue  <-  data$virtual[i,j][[1]]
        newValue = suppressWarnings(isolate(DT::coerceValue(info$value, as.double(oldValue))))
        if (!is.na(newValue)) {data$virtual[i,j][[1]] <- newValue}
        data$virtual
    }

    # replaceData requires a dataframe in the second argument,
    # and the additional column for the rownames must be removed
    observeEvent(input$myDT_cell_edit, {
        showData <- DT::replaceData(
            proxy,
            checkValue(input$myDT_cell_edit)[,-1],
            resetPaging = FALSE
        )
    })


    # Do not change UI values in the first run
    # but otherwise run always, even with initial setting
    # where input$plotBtn = 0
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
                    sliderValue("bins1", "Number of bins: Histogram 1", value = 5),
                    sliderValue("bins2", "Number of bins: Histogram 2", value = 14)
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
    ignoreNULL = FALSE  # run this observer always, even with initial settings
    )


    observeEvent(input$delete, {
        data$virtual <- data$virtual[-input$myDT_rows_selected, , drop = FALSE]
        shinyjs::enable(id = "reset")
        shinyjs::enable(id = "update")
        shinyjs::disable(id = "delete")
        })

    # observeEvent(input$myDT_cell_edit, {
    #     shinyjs::toggleState(id = "reset", data$dirty == TRUE)
    #     shinyjs::toggleState(id = "update", data$dirty == TRUE)
    # })

    observeEvent(input$myDT_rows_selected, {
        shinyjs::enable(id = "delete")
    })

    observeEvent(input$reset, {
        data$virtual <- as_tibble(rowid_to_column(dataOriginal))
        data$real <- as_tibble(dataOriginal)
        shinyjs::disable(id = "reset")
        shinyjs::disable(id = "update")
        # TODO: eigenes Modalfenster von shinyWidgets für Warnung!
        shinyFeedback::showSnackbar("resetMessage")
    })

    observeEvent(input$update, {
        data$real <- as_tibble(data$virtual[2])
        data$virtual <- as_tibble(rowid_to_column(data$real))
        shinyjs::disable(id = "update")
    })


    observeEvent(input$add, {
        # TODO: Change to a shinyWidgets modal dialog
        showModal(dataModal(nrow(data$virtual) + 1))
    })

    observeEvent(input$ok, {
        # Check if input is allowed
        if (!is.logical(input$newValue)) {
            data$virtual <- rbind(data$virtual,
                                  c(data$virtual$rowid[nrow(data$virtual)] + 1,
                                    input$newValue))
            shinyjs::enable(id = "reset")
            shinyjs::enable(id = "update")
            shinyFeedback::showSnackbar("sucessfullyAdded")
        } else {
            shinyFeedback::showSnackbar("notAdded")
        }
        removeModal()
    })

}) # shinyServer
