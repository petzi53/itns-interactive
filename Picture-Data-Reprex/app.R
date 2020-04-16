library(shiny)
library(DT)
library(reactlog)

options(shiny.reactlog = TRUE,
        DT.options = list(
            paging = FALSE,
            info = FALSE,
            searching = FALSE,
            ordering = FALSE
        ))


df <- data.frame(x = 15:10)

ui <- fluidPage(
    fluidRow(column(1, DTOutput("myDT")),
    )
)

server <- function(input, output, session) {
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

    output$myDT = renderDT(myData())


    observeEvent(input$myDT_cell_edit, {
        info <- input$myDT_cell_edit
        if (suppressWarnings(isTruthy(is.na(as.numeric(info$value))))) {
            info$value <- as.numeric(data()[info$row,])
        }
        t <- data()
        t[info$row, info$col] <- as.numeric(info$value)
        data(t)
        output$myDT = renderDT(myData())
    })
}

shinyApp(ui, server)
