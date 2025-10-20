# install.packages("dplyr")

library(dplyr)

data_sets_recent <- function(){
  conn_content <- content_database()
  dplyr::tbl(conn_content, DBI::Id(schema = "dbo", "ReleaseFiles")) |> 
    dplyr::select(Name, Summary, Order, Published) |>
    dplyr::filter(!is.na(Name)) |>
    dplyr::collect() |>
    dplyr::arrange(desc(Published))
}