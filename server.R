shinyServer(function(input, output, clientData, session) {
  source("functions.R")
  
  stocks <- reactiveValues( 
    title <- NULL, 
    df <- data.frame() ,
    nombres <- list("AAPL" = "AAPL", "GOOGL" = "GOOGL", "MSFT" = "MSFT"),
    grafica <- NULL
  )
  
  stocks$df <- get_stocks_yahoo("AAPL",stocks$df)  %>% 
    get_stocks_yahoo("GOOGL",.) %>% 
    get_stocks_yahoo("MSFT",.)
  
  observeEvent(input$action_select_stock,{
    stocks$title <- paste0(input$select_stock ,' from ', 
                          as.Date(input$date_range[1]) ,' to ',
                          as.Date(input$date_range[2]) )
    stocks$grafica <- ggplot(stocks$df, 
                             aes_name(x="index", y= input$select_stock)) + geom_line()
  })
  
  observeEvent(input$action_download_stock,{
    stocks$df <- get_stocks_yahoo(input$download_name, stocks$df)
    stocks$nombres <- colnames(stocks$df)
    updateSelectInput(session, "select_stock", choices = stocks$nombres)
  })
  
  output$title_stock <- renderText(stocks$title)
  output$dates_Stock <- renderText(stocks$dates)
  output$plot_stock <- renderPlot(stocks$grafica)
})