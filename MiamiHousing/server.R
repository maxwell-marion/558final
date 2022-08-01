#
# Max Marion-Spencer
# ST 558 - Final Project
# Server file
#

library(shiny)
library(readr)
library(DT)

library(dplyr)
library(ggplot2)

miami <- read_csv("C:/Users/mxmx/Documents/repos/558final/miami-housing.csv", 
                          col_types = cols(avno60plus = col_character(), 
                                           month_sold = col_character(), 
                                           structure_quality = col_character()))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$exp_hist <- renderPlot({

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
    output$data <- DT::renderDataTable(miami[1:input$rows_NI, c(input$data_variables), 
                                             drop = FALSE], 
                                       extensions = 'Buttons',
                                       options = list(scrollX = TRUE,
                                                      scrolly = TRUE,
                                                      buttons = c('csv'),
                                                      dom = 'Bfrtip'),
                                       class = "display"
                                       )
    
})
