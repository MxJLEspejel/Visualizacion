library(shiny)
library(shinydashboard)
library(shinythemes)
library(quantmod)
library(ggplot2)

shinyUI(
  dashboardPage(
    dashboardHeader(title = "Stock Evaluation"),
    dashboardSidebar(
      selectInput("select_stock", label = "Select Stock", 
                  choices = list("AAPL.Open" = "AAPL.Open",
                                 "GOOGL.Open" = "GOOGL.Open", 
                                 "MSFT.Open" = "MSFT.Open"), 
                  selected = "AAPL.Open"),
      dateRangeInput("date_range", label = "Date range", min = '2010-01-01', max = '2017-12-30',
                     start = '2017-01-01', end = '2017-12-30'),
      actionButton("action_select_stock", label = "Select"),
      textInput("download_name", label = "Stock Name"),
      actionButton("action_download_stock", label = "Download"),
      p( class = "text-muted",
        paste("Help: by default the selected stock is save as stock to use with  ",
              "R code."
        )
      )
    ),
    dashboardBody(
      fluidRow(
        box(title = "Stock Time Serie", status = "primary",
            solidHeader = T, width = 9 ,
            textOutput("title_stock"),
            plotOutput("plot_stock")
        ),
        box(title = "Results", status = "danger",  width = 3,
            textOutput("output_backtest")
        ),
        box(title = "Back test", status = "danger", width = 3,
            dateRangeInput("backtest_date_range", label = "Date range", 
                           min = '2010-01-01', max = '2017-12-30', start='2017-01-01',
                           end = '2017-12-30'),
            actionButton("action_backtest", label = "Evaluate")
        )
      ),
      fluidRow(
        box(title = "Area for R code", status = "danger", solidHeader = T, width = 9, 
            textAreaInput("algorithm_code", label = "R code ")
        )
      )
    )
  )
)