shinyServer(function(input, output, clientData, session) {
  source("functions.R")
  
  stocks <- reactiveValues( 
    title = NULL, 
    df = data.frame() %>%  
      get_stocks_yahoo("AAPL",.)  %>% 
      get_stocks_yahoo("GOOGL",.) %>% 
      get_stocks_yahoo("MSFT",.),
    nombres = list("AAPL.Open" = "AAPL.Open",
                   "GOOGL.Open" = "GOOGL.Open", 
                   "MSFT.Open" = "MSFT.Open"),
    grafica = NULL,
    text=NULL
  )
  
  observeEvent(input$action_select_stock,ignoreNULL=F,{
    stocks$title <- paste0(input$select_stock ,' from ', 
                          as.Date(input$date_range[1]) ,' to ',
                          as.Date(input$date_range[2]) )
    df <- as.data.frame(stocks$df[
      paste0(as.Date(input$date_range[1]),'/',as.Date(input$date_range[2])),
      ])
    df$index <- as.Date(rownames(df))
    stocks$grafica <- ggplot(df, 
                             aes_string(x="index", 
                                        y=input$select_stock)
                             ) + geom_line()
  })
  
  observeEvent(input$action_download_stock,ignoreNULL=F, {
    stocks$df <- get_stocks_yahoo(input$download_name, stocks$df)
    stocks$nombres <- colnames(stocks$df)
    updateSelectInput(session, "select_stock", choices = stocks$nombres)
  }) 
  
  observeEvent(input$action_backtest,{
    stocks$text <- simple_source(input$algorithm_code)
  })
  
  output$title_stock <- renderText(stocks$title)
  output$dates_Stock <- renderText(stocks$dates)
  output$plot_stock <- renderPlot(stocks$grafica)
  output$output_backtest <- renderText(stocks$text)
})