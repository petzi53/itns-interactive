# itns-03 PICTURE DATA 2020-04-20
# init.R: initialize server (first run)

myFillColor = "steelblue"
myBorderColor = "black"

########

# df <- read_csv("Describe_Laptop.csv")

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
         spec =
             structure(list(cols = list(`Transcription%` =
             structure(list(), class = c("collector_double",
                    "collector"))),
             default = structure(list(), class = c("collector_guess",
                    "collector")), skip = 1), class = "col_spec"))

dataOriginal <- df
dataModified <- df
#
# df$ID <- 1:nrow(df)
# df <- df[, c(2,1)]




# first UI-run displays button "Dot Plot"
# and display the plot of the histogram
# = plotHeader of "Histogram"
plotHeader <- "Dot Plot"
plotButton <- "Histogram"

# df <-
#   gsheet2tbl(
#  'https://docs.google.com/spreadsheets/d/1xzDqZv3jbDsUVND8wwza19rSiogDXBt6F6sVUNCZWKw/edit?usp=sharing')

