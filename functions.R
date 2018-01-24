library("dplyr")
library("quantmod")
get_stocks_yahoo <- function(stock_name, data_frame){
  stock_name <- tryCatch( getSymbols(stock_name, from = "2010-01-01", 
                                     to ="2017-12-31", auto.assign = FALSE, 
                                     src = "yahoo")[,1]
                          , error = function(e) NULL 
  )
  data_frame <- cbind(data_frame, stock_name, deparse.level = 1)
  return(data_frame)
}

simple_source <- function(text, envir = new.env()) {
  stopifnot(is.environment(envir))
  exprs <- parse(text = text)
  
  n <- length(exprs)
  if (n == 0L) return(invisible())
  
  for (i in seq_len(n - 1)) {
    eval(exprs[i], envir)
  }
  invisible(eval(exprs[n], envir))
}

buy_function <- function(purchase_date, investment, stock, df_portfolio){
  if (match(purchase_date,rownames(stock)) %>% is.na) {
    showNotification("The stock market does not quote the selected day.")
    return(df_portfolio)
  }
  else{
    price <- stock[purchase_date,]
    NoStocks <- (investment/price) %>% floor
    df_portfolio[purchase_date, 
                 colnames(stock)] <- df_portfolio[purchase_date,
                                                  colnames(stock)] +  NoStocks
    return(df_portfolio)
  }
}

sell_function <-function(sell_date, no_stocks, stock, df_portfolio){
  if (match(sell_date,rownames(stock)) %>% is.na) {
    showNotification("The stock market does not quote the selected day.")
    return(df_portfolio)
  }
  else{
    if( df_portfolio[rownames(df_portfolio) <= sell_date,
                     colnames(stock)] %>% sum >= no_stocks){
      df_portfolio[sell_date,
                   colnames(stock)] <- df_portfolio[sell_date,
                                                    colnames(stock)] - no_stocks
    }
    else{
      showNotification("You are trying to sell more stocks than the owned. 
                     Therefore, all the shares with this name were sold.")
      df_portfolio[sell_date,colnames(stock)] <- df_portfolio[sell_date,
                                                              colnames(stock)] - df_portfolio[sell_date,
                                                                                              colnames(stock)]
    }
    return(df_portfolio)
  }
}

portafolioVar <- function(df_stocks, portfolio){
  continousReturns <- log(df_stocks[-nrow(df_stocks),] %>% as.matrix / 
                            df_stocks[-1,] %>% as.matrix)
  stockVolatility <- apply(continousReturns,2,sd)
  matrixCorrelation <- cor(continousReturns)
  riskFactor <- qnorm(0.95)
  stocks_position <- apply(portfolio,2,sum) %>% abs
  individual_Var <- stocks_position * stockVolatility * riskFactor 
  total_Var <- t(individual_Var) %*% matrixCorrelation %*% individual_Var
  return(total_Var)
}

