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
    grafica = NULL
  )
  
  portfolio <-  reactiveValues(
    acquaried = data.frame(
      AAPL.Open = rep(0,2013),
      GOOGL.Open = rep(0,2013)
    ),
    capital = 1000000,
    performance = 1000000,
    risk=0
  )
  
  observeEvent(input$action_select_stock,ignoreNULL=F,{
    stocks$title <- paste0(input$select_stock ,' from ', 
                          as.Date(input$date_range[1]) ,' to ',
                          as.Date(input$date_range[2]) )
    df <- as.data.frame(stocks$df[
      paste0(as.Date(input$date_range[1]),'/',as.Date(input$date_range[2])),
      ])
    df$index <- as.Date(rownames(df))
    stocks$grafica <- ggplot(
      df, 
      aes_string(x="index", 
                 y=input$select_stock)
    ) + geom_line()
    
    updateDateRangeInput(
      session, "backtest_date_range", start = input$date_range[1], 
      end = input$date_range[2],min = input$date_range[1], max = input$date_range[2]
    )
  })
  
  observeEvent(input$action_download_stock,ignoreNULL=F, {
    stocks$df <- get_stocks_yahoo(input$download_name, stocks$df)
    portfolio$acquaried <- cbind(portfolio$acquaried,rep(0,nrow(stocks$df)))
    stocks$nombres <- colnames(stocks$df)
    colnames(portfolio$acquaried) <- colnames(stocks$df)
    rownames(portfolio$acquaried) <- index(stocks$df)
    updateSelectInput(session, "select_stock", choices = stocks$nombres)
  }) 
  
  observeEvent(input$action_backtest,{
    actualEnvir <- new.env()
    actualEnvir$current_stock <- as.data.frame(
      stocks$df[paste0(
        as.Date(input$backtest_date_range[1]),
        '/',
        as.Date(input$backtest_date_range[2])),input$select_stock])
    actualEnvir$capital <- portfolio$capital
    actualEnvir$returns <- log(
      actualEnvir$current_stock[-1,]/ actualEnvir$current_stock[-nrow(actualEnvir$current_stock),]
    )
    actualEnvir$portfolio <- portfolio$acquaried
    actualEnvir$buy_function <- buy_function
    actualEnvir$sell_function <- sell_function
    simple_source(input$algorithm_code,envir = actualEnvir)
    portfolio$acquaried <- actualEnvir$portfolio
    portfolio$capital <- portfolio$capital + 
      sum(stocks$df %>% as.matrix * -1 * portfolio$acquaried)
    portfolio$performance <- portfolio$capital  + 
      sum(apply(portfolio$acquaried,2,sum)*stocks$df[nrow(stocks$df),])
    portfolio$risk <- portafolioVar(stocks$df,portfolio$acquaried)
  })
  
  output$title_stock <- renderText(stocks$title)
  output$dates_Stock <- renderText(stocks$dates)
  output$plot_stock <- renderPlot(stocks$grafica)
  output$table_actionowned <- renderTable(
    apply(portfolio$acquaried,2,sum) %>% as_data_frame(),
    rownames = TRUE, colnames = FALSE, spacing = "xs", digits = 0, hover=TRUE
  )
  output$capital_valuebox <- renderValueBox({
    valueBox(
      value = formatC(portfolio$capital, format = "f", digits=0),  
      subtitle = "Current capital",width = 3,
      icon = icon("bank"),
      color = if (portfolio$capital >= 1000000) "blue" else "yellow"
    )
  })
  output$performance_valuebox <- renderValueBox({
    valueBox(
      value =  formatC(portfolio$performance/1000000-1, format = "f", digits=4), 
      subtitle = "Portfolio Performance", width = 3,
      icon = icon("line-chart"),
      color = if (portfolio$performance/1000000-1 >= 0) "light-blue" else "orange"
    )
  })
  output$variance_valuebox <- renderValueBox({
    valueBox(
      value = formatC(portfolio$risk, format = "f", digits=4), 
      subtitle = "Current Daily V.A.R",
      icon = icon("random"),width = 3,
      color = "red"
    )
  })
})