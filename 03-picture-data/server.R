myFillColor = "steelblue"
myColor = "black"
myBorder = "white"

my_theme <- theme_light() +
    theme(plot.title = element_text(size = 10, face = "bold", hjust = 0.5)) +
    theme(plot.background = element_rect(color = NA, fill = NA)) +
    theme(plot.margin = margin(1, 0, 0, 0, unit = 'cm')) +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          plot.margin = margin(12, 12, 12, 12),
          plot.title = element_text(size = 14))

data <- read_csv("Describe_Laptop.csv")
dataOrig <- data

# data <-
#     gsheet2tbl(
#         'https://docs.google.com/spreadsheets/d/1xzDqZv3jbDsUVND8wwza19rSiogDXBt6F6sVUNCZWKw/edit?usp=sharing')


# Define server logic
shinyServer(function(input, output) {

    data <- reactiveVal(as.data.frame(data))

    output$myDT = renderDT(
        datatable(
            data(),
            selection = 'single',
            editable = TRUE,
            colnames = c('ID' = 1)
        ),
        server = FALSE
    )

    # # Generate histograms with different bins ----
    source("R/histograms.R", local = TRUE)
    #
    # # Generate dotplots with rugs ----
    source("R/dotplots.R", local = TRUE)


    # calculate sampe size for info string
    output$N <- renderText({
        length(data()[[1]])
    })

    observeEvent(input$myDT_cell_edit, {
        info <- input$myDT_cell_edit
        t <- data()
        t[info$row, info$col] <- as.numeric(info$value)
        data(t)
    })

    observeEvent(input$add, {
        t <- rbind(0, data())
        data(t)
    })

    observeEvent(input$reset, {
        data(dataOrig)
    })

    output$summary <- renderPrint({
        summary(data())
    })
})
