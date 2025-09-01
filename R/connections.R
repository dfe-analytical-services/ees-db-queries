

content_database <- function(){
  config_content <- config::get("content_con")
  DBI::dbConnect(
    odbc::odbc(),
    Driver = config_content$driver,
    Server = config_content$server,
    Database = config_content$database,
    Authentication = config_content$authentication,
    UID = config_content$uid
  )
}

