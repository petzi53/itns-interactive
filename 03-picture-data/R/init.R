# itns-03 PICTURE DATA 2020-04-24
# dataset and initalizing app variables
# functions without reactive values
# init.R

#####################     included dataset      ###############

## dataset converted: so that no extra file load is necessary
## originated from df <- read_csv("Describe_Laptop.csv")
## produced with df <- dput(df)
df <- structure(list(`Transcription%` =
     c(13.7, 21.1, 15.2, 30.4, 12.8, 9.6, 9.3, 17.7,
       15.4, 8.7, 12.8, 10.6, 5.1, 16.7, 17.7, 8.7,
       26.4, 18, 19, 16.9, 18.8, 8.5, 1.2, 11.5,
       21.4, 10.3, 9, 12.8, 12, 34.7, 4.1)),
    class = c("spec_tbl_df", "tbl_df", "tbl", "data.frame"),
    row.names = c(NA, -31L),
    spec = structure(list(cols = list(`Transcription%` =
           structure(list(), class = c("collector_double", "collector"))),
           default = structure(list(),
           class = c("collector_guess", "collector")), skip = 1),
           class = "col_spec"))

dataOriginal <- df

###################  Some Parameters  #####################

myFillColor = "steelblue"
myBorderColor = "black"


#########  Functions without reactive Values  ###############



#################### dot plot ####################

myDotPlotSimple <- function(){
    p <- geom_dotplot(method = "dotdensity",
                      binwidth = 0.1,
                      dotsize = 10,
                      stackratio = 0,
                      fill = myFillColor,
                      color = myBorderColor)
}

myDotPlotStacked <- function(){
    p <- geom_dotplot(method = "dotdensity",
                      binwidth = 1,
                      dotsize = 1,
                      stackratio = 1,
                      fill = myFillColor,
                      color = myBorderColor)
}

###################### general #####################

sliderValue <- function(id, label="Number of bins:", min=5, max=20, value=9) {
    sliderInput(
        id,
        label = label,
        min = min,
        max = max,
        value = value
    )
}


rugPlot <- geom_rug(color = "red",
                    sides = "b",
                    length = unit(5, "mm"))

# Return the UI for a modal dialog
dataModal <- function(recordID) {
    modalDialog(
        numericInput("newValue", "New value:",
                     value = NULL,
                     width = '100px'
        ),
        span('(The new value will be added
             at the end of the datasetas as record ID ',
             strong(recordID), ')', .noWS = "before"),
        footer = tagList(
            modalButton("Cancel"),
            actionButton("ok", "OK")
        ),
        size = 's'
    )
}


# calculate number of decimal places
# see: https://stackoverflow.com/a/55738816/7322615
# return maximal number of decimal places in a vector:
# max(sapply(vec, decimalplaces))
decimalplaces <- function(x) {
    if ((x %% 1) != 0) {
        nchar(strsplit(sub('0+$', '', as.character(x)), ".", fixed = TRUE)[[1]][[2]])
    } else {
        return(0)
    }
}

