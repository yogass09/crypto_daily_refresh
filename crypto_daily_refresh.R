# Libraries
library(DBI)
library(odbc)
library(dplyr)
library(crypto2)


start.time <- Sys.time()

## 1. Crypto List
crypto.list <- crypto_list(only_active = FALSE, add_untracked = TRUE)

## 3. Crypto Global Latest
crypto.global.latest <- crypto_global_quotes(
  which = "latest",
  convert = "USD",
  start_date = NULL,
  end_date = NULL,
  interval = "daily",
  quote = TRUE,
  requestLimit = 1,
  sleep = 0,
  wait = 60,
  finalWait= FALSE
)

## 4. Crypto Global Historical
crypto.global.historical <- crypto_global_quotes(
  which = "historical",
  convert = "USD",
  start_date = Sys.Date()-2,
  end_date = Sys.Date(),
  interval = "daily",
  quote = TRUE,
  requestLimit = 10000,
  sleep = 0,
  wait = 60,
  finalWait = FALSE
)


## 5. Crypto Listing Latest
crypto.listings.latest <- crypto_listings(
  which = "latest",
  convert = "USD",
  limit = 10000,
  start_date = Sys.Date()-2,
  end_date = Sys.Date(),
  interval = "day",
  quote = TRUE,
  sort = "cmc_rank",
  sort_dir = "asc",
  sleep = 0,
  wait = 60,
  finalWait = FALSE
)

## 6. Crypto Listing Historical
crypto.listings.historical <- crypto_listings(
  which = "historical",
  convert = "USD",
  limit = 10000,
  start_date = Sys.Date()-2,
  end_date = Sys.Date(),
  interval = "day",
  quote = TRUE,
  sort = "cmc_rank",
  sort_dir = "asc",
  sleep = 0,
  wait = 0,
  finalWait = FALSE
)


## 7. Crypto Exhanges List

crypto.exchanges.list <- exchange_list(only_active = FALSE, add_untracked = TRUE)


## 8. Crypto Exhanges Info

crypto.exchanges.info <- exchange_info(limit=1)



# ------------------------ #

# Set up your Azure SQL Database connection
con <- dbConnect(odbc::odbc(),Driver = "ODBC Driver 17 for SQL Server",
                 Server = "cp-io-sql.database.windows.net",
                 Database = "sql_db_ohlcv",
                 UID = "yogass09",
                 PWD = "Qwerty@312",
                 Port = 1433)


# Assuming 'all_coins_historical' is your tibble
# 1
dbWriteTable(con, "crypto.list", as.data.frame(crypto.list), overwrite = TRUE)

# 2
dbWriteTable(con, "crypto.global.latest", as.data.frame(crypto.global.latest), overwrite = TRUE)
# 3
dbWriteTable(con, "crypto.global.historical", as.data.frame(crypto.global.historical), append = TRUE)
# 4
dbWriteTable(con, "crypto.listings.latest", as.data.frame(crypto.listings.latest), overwrite = TRUE)
# 5
dbWriteTable(con, "crypto.listings.historical", as.data.frame(crypto.listings.historical), append = TRUE)
# 6
dbWriteTable(con, "crypto.exchanges.list", as.data.frame(crypto.exchanges.list), overwrite = TRUE)

# Disconnect from the database
dbDisconnect(con)

