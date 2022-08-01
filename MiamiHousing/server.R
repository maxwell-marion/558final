#
# Max Marion-Spencer
# ST 558 - Final Project
# Server file
#

library(shiny)
library(readr)
miami <- read_csv("miami-housing.csv", 
                          col_types = cols(avno60plus = col_character(), 
                                           month_sold = col_character(), 
                                           structure_quality = col_character()))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })
    
    # Data Tab
    # Show entire dataset
    # Subset data (rows and columns)
    # Save the data as a file (.csv or other)
    output$data <- renderDataTable(miami)
    
})
