# itns-03 PICTURE DATA 2020-04-28

###########   functions without reactive values   #############

source("R/init_server.R", local = TRUE)

###########   central server function #################

shinyServer(function(input, output, session) {

    ### Generate histograms with different bins ----
    source("R/histograms.R", local = TRUE)
    #
    ### Generate dotplots ----
    source("R/dotplots.R", local = TRUE)

    ### Generate stats lines ----
    source("R/plot_stats.R", local = TRUE)


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

    checkValue <- function(info) {
        i = info$row
        j = info$col + 1
        oldValue  <-  data$virtual[i,j][[1]]
        newValue = suppressWarnings(
            isolate(DT::coerceValue(info$value, oldValue)))
        if (!is.na(newValue)) {
            data$virtual[i,j][[1]] <- newValue
            shinyjs::enable(id = "update")
            shinyjs::enable(id = "reset")
            showElement("updateString")
        }
        shinyjs::disable(id = "delete")
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

    observeEvent({
            input$bins1
            input$bins2} , {
        slider1 <<- input$bins1
        slider2 <<- input$bins2
    })

    observeEvent(input$plotBtn, {
        output$plotUIHeader <- renderUI({
            HTML("<center><h2>", input$plotBtn, "</h2></center>")
        })
        if (input$plotBtn == "Dot Plot") {
            renderUIDotPlot()
        } else {
            renderUIHistogram()
        }
    })


    observeEvent(input$delete, {
        data$virtual <- data$virtual[-input$myDT_rows_selected, , drop = FALSE]
        shinyjs::enable(id = "reset")
        shinyjs::enable(id = "update")
        shinyjs::disable(id = "delete")
        showElement("updateString")
        l <- isolate(length(input$myDT_rows_selected))
        if (l > 1) {
            shinyFeedback::showToast("success",
                 paste(l, deleteSeveralMsg),
                 .options = myToastOptions)
        } else {
            shinyFeedback::showToast("success", deleteMsg,
                 .options = myToastOptions)
        }
        })

    observeEvent(input$myDT_rows_selected, {
        shinyjs::enable(id = "delete")
    })

    observeEvent(input$wantReset, {
        if (input$wantReset) {
            data$virtual <- as_tibble(rowid_to_column(dataOriginal))
            data$real <- as_tibble(dataOriginal)
            shinyjs::disable(id = "reset")
            shinyjs::disable(id = "update")
            hideElement("updateString")
            shinyFeedback::showToast("success", resetMsg,
              .options = myToastOptions)
        }
    })

    observeEvent(input$reset, {
        confirmSweetAlert(
            session = session,
            inputId = "wantReset",
            type = "warning",
            title = "You will loose all your changes.
            Do you really want to reset the dataset? "
        )

    })

    observeEvent(input$update, {
        data$real <- as_tibble(data$virtual[2])
        data$virtual <- as_tibble(rowid_to_column(data$real))
        shinyjs::disable(id = "update")
        hideElement("updateString")
        shinyFeedback::showToast("success", updateMsg,,
                                 .options = myToastOptions)
    })

    observeEvent(input$add, {
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
            showElement("updateString")
            shinyFeedback::showToast("success", addedRowMsg,
                                     .options = myToastOptions)
        } else {
            shinyFeedback::showToast("warning", notAddedRowMsg,
                                     .options = myToastOptions)
        }
        removeModal()
    })

    observeEvent(input$msgHelp, {
        sendSweetAlert(
            session = session,
            title = msgHelpTitle,
            text = msgHelpText,
            html = TRUE,
            width = 1000
        )
    })

}) # shinyServer
