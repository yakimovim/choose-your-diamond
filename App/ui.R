#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

minWeight = min(diamonds$carat)
maxWeight = max(diamonds$carat)
meanWeight = mean(diamonds$carat)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Choose your diamond!"),
    h4(class="well", "Here you can find out approximate price for a diamond."),
    h4(class="well", "In the left panel choose 
     properties of a diamond you want. Then set the desired weight of the diamond using 
     the slider."),
    h4(class="well", "In the right panel you'll see the choice of your parameters and chart 
     with weights and prices of existing diamonds. Red line represents how price depends 
     on weight of a diamond. This line is obtained using linear regression of price to 
     weight and squared weight. Black vertical line will represent the weight of your 
     choice. Under the chart you'll see approximate price of the chosen diamond."),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("selectedCut", "Select diamond cut:", c("Any", levels(diamonds$cut))),
            selectInput("selectedColor", "Select diamond color:", c("Any", levels(diamonds$color))),
            selectInput("selectedClarity", "Select diamond clarity:", c("Any", levels(diamonds$clarity))),
            sliderInput("selectedWeight",
                        "Choose diamond's weight in carats:",
                        min = minWeight,
                        max = maxWeight,
                        value = meanWeight)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tags$table(class = "table",
                       tags$thead(
                           tags$tr(
                               tags$th("Selected cut"),
                               tags$th("Selected color"),
                               tags$th("Selected clarity")
                           )
                       ),
                       tags$tbody(
                           tags$tr(
                               tags$td(textOutput("cut")),
                               tags$td(textOutput("color")),
                               tags$td(textOutput("clarity"))
                           )
                       )
            ),
            plotOutput("diamondPrice"),
            h4(class="well text-danger", textOutput("price"))
        )
    )
))
