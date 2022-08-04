#
# Max Marion-Spencer
# ST 558 - Final Project
# UI file
#

library(shiny)

# CODE USED TO RUN APP - 
# shiny::runGitHub("558final","maxwell-marion", subdir = "/MiamiHousing")

var_list <- c("LATITUDE",
              "LONGITUDE",
              "PARCELNO",
              "SALE_PRC",
              "LND_SQFOOT",
              "TOT_LVG_AREA",
              "SPEC_FEAT_VAL",
              "age",
              "structure_quality",
              "avno60plus",
              "month_sold",
              "CNTR_DIST",
              "SUBCNTR_DI",
              "OCEAN_DIST",
              "WATER_DIST",
              "RAIL_DIST",
              "HWY_DIST")

model_list <- c("TOT_LVG_AREA",
                "SPEC_FEAT_VAL",
                "age",
                "structure_quality",
                "avno60plus",
                "month_sold",
                "CNTR_DIST",
                "SUBCNTR_DI",
                "OCEAN_DIST",
                "WATER_DIST",
                "RAIL_DIST",
                "HWY_DIST")

# Define UI for application
shinyUI(fluidPage(

    # Application title
    titlePanel("Miami Housing Dataset Analysis"),

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
          # Setting ConditionalPanel setting for About tab
          conditionalPanel(condition="input.conditionedPanels == 'About'", 
                           h2("Welcome!"),
                           h4("Read this About page and click a tab on your right to get started.")),
          
          # Setting ConditionalPanel setting for Exploration
          conditionalPanel(condition="input.conditionedPanels == 'Exploration'",
                           h4("Use the features below to explore the data."),
                           
            # Adding row filter
            numericInput("expRows_NI",label = "Select the number of rows to use (max: 13,932)",
                                        value = 13932, min = 0, max = 13932),
          
            h4("Graph Options"),
                           
            # Dropdown for Exploration Tab - graphical summary
            selectInput("exp_graph", "Graphical Summary", c('Histogram' = "hist",
                                                        'Correlation Plot' = "corr",
                                                        'Scatterplot' = "scatter")),
          
            # Conditional for Histogram selection
            conditionalPanel(
              condition = "input.exp_graph == 'hist'",
              selectInput("hist_x", "Select a variable", var_list )
            ),
          
            # Conditional for Barplot selection
            conditionalPanel(
              condition = "input.exp_graph == 'bar'",
              selectInput("bar_x", "Select a variable", var_list)
            ),
          
            # Conditional for scatterplot selection
            conditionalPanel(
              condition = "input.exp_graph == 'scatter'",
              selectInput("scatter_x", "Select scatter plot  x variable", var_list ),
              selectInput("scatter_y", "Select scatter plot y variable", var_list, selected = "LONGITUDE")
            ),
          
            h4("Numeric Options"),
          
            # Dropdown for Exploration Tab - numerical summary
            selectInput("exp_num", "Choose a numeric summary", c('Summary' = "sum",
                                                      'Standard Deviation' = "sd",
                                                      'Correlations' = "corr")
            ),
          
            # Checkboxes for numeric data summaries
            checkboxGroupInput("exp_variables", "Variables to include for numeric summary (and corrplot):",
                             var_list, 
                             var_list),
            ),
          
          
          # Setting ConditionalPanel setting for Modeling Info
          conditionalPanel(condition="input.conditionedPanels == 'Model Info'",
                           h4("Background about our models.")),
          
          # Setting ConditionalPanel setting for Model Fitting
          conditionalPanel(condition="input.conditionedPanels == 'Model Fitting'",
            #h3("Settings"),
            
            # Slider control Train/Test
            sliderInput("trainRatio",
                        "Training Set Data Proportion",
                        min = 0.0, max = 1, value = 0.7),
            sliderInput("testRatio",
                        "Test Set Data Proportion",
                        min = 0.0, max = 1, value = 1-0.7),
            tags$br(),
            
            # Button for fitting all models
            actionButton("fitbutton", "Press to fit all models"),
            
            tags$br(),
            tags$br(),
            
            # Model Settings: Multiple Linear Regression
            h4("Multiple Linear Regression:"),
            
            # Variable selection - Response
            #selectInput("mlr_resp", "Choose a response variable", var_list),
            
            # Variable selection - Predictors
            checkboxGroupInput("mlr_preds",
                               "Choose response variables",
                               model_list, 
                               model_list),
            
            tags$br(),
            
            # Model Settings: Boosted Tree        
            h4("Boosted Tree:"),
            
            # Variable selection - Response
            #selectInput("rtree_resp", "Choose a response variable", var_list),
            
            # Variable selection - Predictors
            checkboxGroupInput("btree_preds",
                               "Choose response variables",
                               model_list, 
                               model_list),
            
            # Selecting nTrees
            selectInput("btree_num", "Choose # of trees", c('10,25,50' = '1',
                                                            '25,50,100' = '2',
                                                            '50,100,150' = '3')),
            
            # Selecting interactiondepth
            sliderInput("btree_depth",
                        "Select depth sequence: (e.g 1:X)",
                        min = 1, max = 5, value = 3),
            
            # Selecting shrinkage
            sliderInput("btree_shrinkage",
                        "Select shrinkage value",
                        min = 0, max = 0.5, value = 0.1),
            
            # Selecting n.minobsinnode
            sliderInput("btree_minobs",
                        "Select min. # obs in node: ",
                        min = 1, max = 15, value = 10),
            
            tags$br(),
            
            # Model Settings: Random Forest        
            h4("Random Forest:"),
            
            # Variable selection - Response
            #selectInput("rf_resp", "Choose a response variable", var_list),
            
            # Variable selection - Predictors
            checkboxGroupInput("rf_preds",
                               "Choose predictor variables",
                               model_list, 
                               model_list),
            # Selecting mTry
            sliderInput("rf_mtry",
                        "Select mtry sequence: (e.g 1:X)",
                        min = 1, max = 15, value = 5)
            
            
                           ),
          # Setting ConditionalPanel setting for Prediction
          conditionalPanel(condition="input.conditionedPanels == 'Prediction'",
                           h2("Prediction"), 
                           
              tags$br(),     
              
              # Button for creating prediction
              actionButton("predictionButton", "Press to output prediction"),
              
              tags$br(),
              tags$br(),
              
              h4("Choose a model:"),             
              # Dropdown for which model to use for prediction
              selectInput("pred_choice", helpText("Choose a fitted model from the previous tab to use for prediction"),
                          c('Multiple Linear Regression' = "mlr",
                            'Regression Tree' = 'rt',
                            'Random Forest' = 'rf')),
            
              # Enter Variable Values
              h4("Enter variable values:"),
              # Numeric Inputs galore
              numericInput("TOT_LVG_AREA_i", label = "Total Living Area", value = 0, min = 0),
              numericInput("SPEC_FEAT_VAL_i", label = "Special Feature Value", value = 0, min = 0),
              numericInput("age_i", label = "Age of House", value = 0, min = 1),
              numericInput("structure_quality_i", label = "Structure Quality", value = 0, min = 1, max = 5),
              numericInput("avno60plus_i", label = "Airport Noise Exceeds Limit", value = 0, min = 0, max = 1),
              numericInput("month_sold_i", label = "Month Sold", value = 0, min = 1, max = 12),
              numericInput("CNTR_DIST_i", label = "Distance to City Center", value = 0, min = 0),
              numericInput("SUBCNTR_DI_i", label = "Distance from Sub Center", value = 0, min = 0),
              numericInput("OCEAN_DIST_i", label = "Distance from Ocean", value = 0, min = 0),
              numericInput("WATER_DIST_i", label = "Distance from Water", value = 0, min = 0),
              numericInput("RAIL_DIST_i", label = "Distance from Railway", value = 0, min = 0),
              numericInput("HWY_DIST_i", label = "Distance from Highway", value = 0, min = 0)
            
              ),
                           
                           
                           
          #),

                           
          # Setting ConditionalPanel setting for Data tab 
          conditionalPanel(condition="input.conditionedPanels == 'Data'",
            # DATA TAB - Select Number of Rows to include
            numericInput("rows_NI",label = "Select the number of rows to view",
                                   value = 13932, min = 0, max = 13932),
            # DATA TAB - Select Which Variables to include
            checkboxGroupInput("data_variables", "Variables to include:",
                                              var_list, 
                                              var_list)
          )
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(type = "tab", id = "conditionedPanels",
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
                        tags$li(tags$b("PARCELNO:"), tags$em("The parcel number of the house, contains ~1% repeat sales")),
                        tags$li(tags$b("SALE_PRC:"), tags$em("The sale price of the house")),
                        tags$li(tags$b("LND_SQFOOT:"), tags$em("The square footage of the parcel of land involved in the sale")),
                        tags$li(tags$b("TOT_LVG_AREA:"), tags$em("The square footage of the livable area of the house")),
                        tags$li(tags$b("SPEC_FEAT_VAL:"), tags$em("Value of features such as swimming pools")),
                        tags$li(tags$b("age:"), tags$em("The age of the house")),
                        tags$li(tags$b("structure_quality:"), tags$em("Quality of the structure from 1 (worst) to 5 (best)")),
                        tags$li(tags$b("month_sold:"), tags$em("The month that the house was sold in")),
                        tags$li(tags$b("avno60plus:"), tags$em("0 or 1, for when airplane noise that exceeds the acceptable level")),
                        tags$li(tags$b("CNTR_DIST:"), tags$em("The distance from the Miami central business district")),
                        tags$li(tags$b("SUBCNTR_DI:"), tags$em("The distance from the nearest subcenter")),
                        tags$li(tags$b("OCEAN_DIST:"), tags$em("Distance from the ocean")),
                        tags$li(tags$b("WATER_DIST:"), tags$em("Distance from a body of water")),
                        tags$li(tags$b("RAIL_DIST:"), tags$em("The distance from the nearest rail line, in feet")),
                        tags$li(tags$b("HWY_DIST:"), tags$em("Distance from the nearest highway, in feet")),
                      )),
                      tags$br(),
                      ),
                      tabPanel("Exploration", plotOutput("graph_sum"), verbatimTextOutput("num_sum")),
                      tabPanel("Model Info", 
                               tags$div(
                                 h3("Information About Our Three Models"),
                                 tags$br(),
                                 h4("Multiple Linear Regression Model:"),
                                 " ",
                                 tags$br(),
                                 h4("Regression Tree:"), 
                                 " ",
                                 tags$br(),
                                 h4("Random Forest Model:"),
                                 " ",
                                 
                               )),
                      tabPanel("Model Fitting", verbatimTextOutput("mlr_sum"),verbatimTextOutput("bt_sum"), verbatimTextOutput("rf_sum"),
                             tableOutput("compare")),
                      tabPanel("Prediction"),
                      tabPanel("Data", DT::dataTableOutput("data"))
        )
    )
)))
