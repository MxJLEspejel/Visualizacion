library(shiny)
library(shinydashboard)
library(shinythemes)
library(quantmod)
library(ggplot2)
library(TTR)
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
        "Help: by default the following values are available with the 
        corresponding names to use with R code.",
        "current_stock: selected stock.
        capital: capital available for investment.
        returns: logarithmic returns of the selected stock.
        portfolio: Data Frame by time with the stocks owned.
        buy_function: the function to call the purchase of shares (Require: Pruchase Date, Investment, Portfolio, Stock).
        sell_function: the function to call the sale of shares (Require: Sale Date, No. of Stocks, Portfolio, Stock)."
      )
    ),
    dashboardBody(
      column(
        width = 8,
        valueBoxOutput("capital_valuebox"),
        valueBoxOutput("performance_valuebox"),
        valueBoxOutput("variance_valuebox"),
        box(title = "Stock Time Serie", 
            status = "primary",solidHeader = T, width = 12,
            textOutput("title_stock"),
            plotOutput("plot_stock")      
        )
      ),
      column(
        width = 4,
        box(title = "Stocks owned.", status = "danger",  width = 12, height = 180,
            tableOutput("table_actionowned")
        ),
        box(title = "Area for R code", status = "danger", solidHeader = T, width = 12,
            textAreaInput(
              "algorithm_code", label = "R code ", height = 180,
              value = 
                'portfolio <- buy_function("2017-05-01", 10000, current_stock, portfolio) 
              portfolio <- sell_function("2017-10-30", 50, current_stock,portfolio)'
            ),
            dateRangeInput("backtest_date_range", label = "Date range", 
                           min = '2010-01-01', max = '2017-12-30', start='2017-01-01',
                           end = '2017-12-30'),
            actionButton("action_backtest", label = "Evaluate")
        )
      )
    )
  )
)