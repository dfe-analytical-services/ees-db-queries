library(dplyr)

releases_published_since <- function(cut_off_date = "2024-12-31"){
  conn_content <- content_database()
  dplyr::tbl(conn_content, DBI::Id(schema = "dbo", "Releases")) |> 
    dplyr::select(Id, PublicationId, Created, Updated, Year, Label) |> 
    dplyr::left_join(
      dplyr::tbl(conn_content, DBI::Id(schema = "dbo", "ReleaseVersions")) |>
        dplyr::select(Id = ReleaseId, Published, ApprovalStatus),
      by = "Id"
    ) |> 
    summarise(first_published = min(Published), .by = c(Id, ApprovalStatus, PublicationId)) |> 
    filter(as.Date(first_published) > as.Date(cut_off_date)) |>
    as.data.frame()
}
