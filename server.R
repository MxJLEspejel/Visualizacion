shinyServer(function(input, output, clientData, session) {
  
  stocks <- reactiveValues( 
    title = paste0('APPL' ,' from ', '2017-01-01',' to ','2017-12-31'), 
    grafica = ggplot(AAPL[paste0('2017-01-01','/','2017-12-31'),], 
                     aes(x = Index, y = AAPL.Open)
    ) + geom_line(),
    nombres = list("APPL" = "APPL", "GOOGL" = "GOOGL", "MSFT" = "MSFT")
  )
  
  observeEvent(input$action_select_stock,{
    stocks$title = paste0(input$select_stock ,' from ', 
                          as.Date(input$date_range[1]) ,' to ',
                          as.Date(input$date_range[2]) )
    stocks$grafica = ggplot(
      AAPL[paste0(as.Date(input$date_range[1]),'/',as.Date(input$date_range[2])),],
      aes(x = Index, y = AAPL.Open)
    ) + geom_line()
  })
  
  
  
  observeEvent(input$action_download_stock,{
    x <- input$download_name
    stocks$nombres[[x]]<- x
    updateSelectInput(session, "select_stock", choices = stocks$nombres)
  })
  
  output$title_stock <- renderText(stocks$title)
  output$dates_Stock <- renderText(stocks$dates)
  output$plot_stock <- renderPlot(stocks$grafica)
})