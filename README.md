# 558final

Maxwell Marion-Spencer
08/03/2022

-   [About](#about)
-   [Requirements](#requirements)
-   [Package Installation](#packages)
-   [Run Code](#runcode)


# About

The purpose of this project Shiny application is to allow users to examine and model data from the dataset 'Miami Housing Dataset`, in order to predict the `SALE_PRC variable using a variety of predictors and methods. 

# Requirements

List of required packages:

-   `shiny`
-   `readr`
-   `DT`
-   `dplyr`
-   `ggplot2`
-   `ggcorrplot`
-   `caret`

# Packages

``` r
install.packages('shiny')
install.packages('readr')
install.packages('DT')
install.packages('dplyr')
install.packages('ggplot2')
install.packages('ggcorrplot')
install.packages('caret')
``` 

# Run Code

``` r
shiny::runGitHub("558final","maxwell-marion", subdir = "/MiamiHousing")
``` 
