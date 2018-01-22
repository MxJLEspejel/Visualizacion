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