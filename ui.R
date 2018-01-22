library(shiny)
library(shinydashboard)
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
      actionButton("action_select_stock", label = "Select")
    ),
    dashboardBody(
      fluidRow(
        box(title = "Stock Time Serie", status = "primary", solidHeader = T, width = NULL ,
            textOutput("title_stock"),
            plotOutput("plot_stock")
        )
      ),
      fluidRow(
        tabsetPanel(
          tabPanel(title ="R Algorithm",
                   box(title = "Area for R code", status = "warning", solidHeader = T, 
                     textAreaInput("algorithm_code", label = "R code ")
                   ),
                   box(title = "Back test", status = "warning", solidHeader = T, width = 3,
                       dateRangeInput("backtest_date_range", label = "Date range", 
                                      min = '2010-01-01', max = '2017-12-30', start='2017-01-01',
                                      end = '2017-12-30'),
                       actionButton("action_backtest", label = "Evaluate")
                   ),
                   box(title = "Results", status = "success", solidHeader = T, width = 3,
                       textOutput("output_backtest")
                   )
          ),
          tabPanel(title = "Download Stock",
                   textInput("download_name", label = "Stock Name"),
                   actionButton("action_download_stock", label = "Download")
          )
        )
      )
    )
  )
)