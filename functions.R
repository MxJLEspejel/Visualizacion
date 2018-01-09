library("dplyr")
library("quantmod")

get_stocks_yahoo <- function(stock_name, data_frame){
  stock_name <- tryCatch( getSymbols(stock_name, from = "2010-01-01", 
                                     to ="2017-12-31", auto.assign = F)[,1]
                          , error = function(e) NULL
  )
  data_frame <- cbind(data_frame, stock_name)
  return(data_frame)
}

