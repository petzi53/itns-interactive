# itns-03 PICTURE DATA 2020-04-28

#### Textstrings for messages and UI text elements

showObs = "Individual observations"
resetMsg = "Data sucessfully reset to the original dataset."
updateMsg = "Dataset with your changes successfully updated."
addedRowMsg = "Value added successfully at the end of the dataset."
notAddedRowMsg = "Input not valid. Only numbers allowed."
deleteMsg = "Selected row sucessfully deleted."
deleteSeveralMsg = "Selected rows sucessfully deleted."

mySnackbar <- function(snackbarID, snackbarMsg, snackbarType) {
    if (snackbarType == "success") {
        snackbarStyle = "text-align: center;
                            background-color: green; color: white;"
    }
    if (snackbarType == "warning") {
        snackbarStyle = "text-align: center;
                            background-color: orange; color: white;"
    }
    if (snackbarType == "danger") {
        snackbarStyle = "text-align: center;
                            background-color: red; color: white;"
    }
    if (snackbarType == "primary") {
        snackbarStyle = "text-align: center;
                            background-color: steelblue; color: white;"
    }
    if (snackbarType == "info") {
            snackbarStyle = "text-align: center;
                            background-color: black; color: white;"
    }

    # cat(file = stderr(), "rowsSelected in mySnackbar", input$myDT_rows_selected, "\n")
    shinyFeedback::snackbar(snackbarID, snackbarMsg, style = snackbarStyle)
}



###########




shinyUI <- fluidPage(

    # collection of snackbar messages
    mySnackbar("resetID", resetMsg, "success"),
    mySnackbar("updateID", updateMsg, "success"),
    mySnackbar("addedID", addedRowMsg, "success"),
    mySnackbar("notAddedID", notAddedRowMsg, "warning"),
    mySnackbar("deleteID", deleteMsg, "success"),
    mySnackbar("deleteIDs", deleteSeveralMsg, "success"),

    shinyjs::useShinyjs(),
    shinyFeedback::useShinyFeedback(),

    fluidRow(
        column(2,
           wellPanel(
               HTML("<center><h2>Picture Data</h2></center>"),
               HTML("<center><h4>(Control Panel)</h4></center>"),
               hr(),
               shinyWidgets::radioGroupButtons(
                            inputId = "plotBtn",
                            choices = c("Histogram",
                                        "Dot Plot"),
                            selected = "Histogram",
                            status = "success",
                            checkIcon = list(
                                yes = icon("check-square"),
                                no = icon("square-o")
                            ),
                            justified = TRUE
                        ),
               br(),
               div(style = "text-align: center",
                   "Actual sample size =",
                   textOutput("N", inline = TRUE)
               ), # end of sample size text
               verbatimTextOutput("summary"),
               br(),
               actionButton("add", "Add Value",
                            class = "btn btn-primary",
                            width = "100px"),
               shinyjs::disabled(actionButton("delete", "Delete Value",
                                              class = "btn btn-primary",
                                              width = "100px")),
               br(),br(),
               shinyjs::disabled(actionButton("update", "Update",
                                              class = "btn btn-primary",
                                              width = "100px")),
               shinyjs::disabled(actionButton("reset", "Reset",
                                              class = "btn btn-warning",
                                              width = "100px")),
               hr(),
               checkboxInput("ragValue",
                             label = strong(showObs), value = FALSE),

               #### conditional UI: Histogram sliders
               uiOutput("plotUISliders")
           ),
        ),
        column(2,
           wellPanel(
               div(
               h2("Dataset"),
                   actionBttn(
                       inputId = "msgHelp",
                       label = NULL,
                       style = "material-circle",
                       color = "success",
                       icon = icon("question")
                   ),
                   style = "text-align: center",
               ),
               hr(),
               DT::DTOutput("myDT"),
           ),
        ),
        column(8,
               uiOutput("plotUIHeader"),
               uiOutput("showUIPlot"),
        ),
    )
) # fluidPage


