# Libraries
library(DBI)
library(odbc)
library(dplyr)
library(crypto2)

# Daily Refresh for BTC
coin_list_all <- crypto_list(only_active = TRUE)

all_coins<-crypto_history(coin_list = coin_list_all,convert = "USD",limit = 10000,
                          sleep = 1, start_date = Sys.Date()-2, end_date = Sys.Date())

# Set up your Azure SQL Database connection
con <- dbConnect(odbc::odbc(), Driver = "ODBC Driver 17 for SQL Server",
                 Server = "cp-io-sql.database.windows.net", Database = "sql_db_ohlcv",
                 UID = "yogass09", PWD = "Qwerty@312",Port = 1433)


# Write data to the SQL database
dbWriteTable(con, "all_coins_ohlcv", all_coins, append = TRUE)

# Disconnect from the database
dbDisconnect(con)
