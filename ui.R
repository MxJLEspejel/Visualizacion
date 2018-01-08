library(shiny)
library(shinydashboard)
library(quantmod)
library(ggplot2)

getSymbols("AAPL", from = "2010-01-01", to ="2017-12-31", auto.assign = TRUE)
getSymbols("GOOGL", from = "2010-01-01", to ="2017-12-31", auto.assign = TRUE)
getSymbols("MSFT", from = "2010-01-01", to ="2017-12-31", auto.assign = TRUE)

shinyUI(
  dashboardPage(
    dashboardHeader(title = "Stock Evaluation"),
    dashboardSidebar(
      selectInput("select_stock", label = "Select Stock", 
                  choices = list("APPL" = "APPL", "GOOGL" = "GOOGL", "MSFT" = "MSFT"), 
                  selected = "APPL"),
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
        tabBox(
          tabsetPanel(
            tabPanel(title ="R Algorithm",
                     textAreaInput("algorithm_code",label = "Area for R code ")
            ),
            tabPanel(title = "Backtest", 
                     dateRangeInput("backtest_date_range", label = "Date range", 
                                    min = '2010-01-01', max = '2017-12-30', start='2017-01-01',
                                    end = '2017-12-30'),
                     actionButton("action_backtest", label = "Evaluate")
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
)