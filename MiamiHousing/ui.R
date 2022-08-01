#
# Max Marion-Spencer
# ST 558 - Final Project
# UI file
#

library(shiny)

# Define UI for application
shinyUI(fluidPage(

    # Application title
    titlePanel("Miami Housing Dataset Analysis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(type = "tab",
                      tabPanel("About",
                    tags$div(
                      h3("About this Project"),
                      "The purpose of this project is to allow users to examine and model data from the dataset 'Miami Housing Dataset.",
                      tags$br(),
                      h3("Tabs"),
                      "This project contains the following tabs: ",
                      tags$br(),
                      tags$br(),
                      tags$ul(
                        tags$li(tags$b("About:"), "You are here! This tab explains the project and the dataset we are using"),
                        tags$li(tags$b("Data Exploration:"), "Create graphical and numerical summaries of each variable"),
                        tags$li(tags$b("Modeling Info:"), "An explanation of each of the three models that we are using"),
                        tags$li(tags$b("Model Fitting:"), "Allows the user to fit models"),
                        tags$li(tags$b("Prediction:"), "Specify predictors for a model and receive a prediction of the response"),
                        tags$li(tags$b("Data:"), "View, subset, and download the dataset"),
                      ),
                      h3("The Miami Housing Dataset"),
                      tags$img(src = "https://assets.site-static.com/userFiles/2103/image/Star_Island_overview.jpg", width = "518px", height = "333px"),
                      tags$br(),
                      tags$em("Image source: Discover Homes Miami"),
                      tags$br(),
                      tags$br(),
                      "This example dataset was pulled from Kaggle and contains information from 13,932 single-family home sales in Miami during the year 2016.",
                      tags$br(),
                      tags$br(),
                      tags$a(href = "https://www.kaggle.com/datasets/deepcontractor/miami-housing-dataset", "Click here to view the Miami Housing Dataset on Kaggle"),
                      h3("Variables"),
                      "Our dataset contains the following variables:",
                      tags$br(),
                      tags$br(),
                      tags$ul(
                        tags$li(tags$b("LATITUDE:"), tags$em("The latitude of the house")),
                        tags$li(tags$b("LONGITUDE:"), tags$em("The longitude of the house")),
                        tags$li(tags$b("LND_SQFOOT:"), tags$em("The square footage of the parcel of land involved in the sale")),
                        tags$li(tags$b("TOT_LVG_AREA:"), tags$em("The square footage of the livable area of the house")),
                        tags$li(tags$b("SPEC_FEAT_VAL:"), tags$em("Value of features such as swimming pools")),
                        tags$li(tags$b("age:"), tags$em("The age of the house")),
                        tags$li(tags$b("structure_quality:"), tags$em("Quality of the structure from 1 (worst) to 5 (best)")),
                        tags$li(tags$b("month:"), tags$em("The month that the house was sold in")),
                        tags$li(tags$b("CNTR_DIST:"), tags$em("The distance from the Miami central business district")),
                        tags$li(tags$b("SUBCNTR_DI:"), tags$em("The distance from the nearest subcenter")),
                        tags$li(tags$b("OCEAN_DIST:"), tags$em("Distance from the ocean")),
                        tags$li(tags$b("WATER_DIST:"), tags$em("Distance from a body of water")),
                        tags$li(tags$b("avno60plus:"), tags$em("0 or 1, for when airplane noise that exceeds the acceptable level")),
                        tags$li(tags$b("RAIL_DIST:"), tags$em("The distance from the nearest rail line, in feet")),
                        tags$li(tags$b("HWY_DIST:"), tags$em("Distance from the nearest highway, in feet")),
                      ),
                      tags$br(),
                            ),
                      tabPanel("Exploration"),
                              ),
                      tabPanel("Modeling Info"),
                      tabPanel("Model Fitting"),
                      tabPanel("Prediction"),
                      tabPanel("Data", tableOutput("data")))
        )
    )
))
