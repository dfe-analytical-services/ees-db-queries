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
    dplyr::left_join(
      dplyr::tbl(conn_content, DBI::Id(schema = "dbo", "Publications")) |>
        dplyr::select(PublicationId = Id, Title, ThemeId) |>
        dplyr::distinct(),
      by = "PublicationId"
    )|> 
    dplyr::left_join(
      dplyr::tbl(conn_content, DBI::Id(schema = "dbo", "Themes")) |>
        dplyr::select(ThemeId = Id, Theme = Title) |>
        dplyr::distinct(),
      by = "ThemeId"
    ) |> 
    summarise(first_published = min(Published), .by = c(Id, ApprovalStatus, PublicationId, Title, Theme)) |> 
    filter(as.Date(first_published) > as.Date(cut_off_date)) |>
    as.data.frame()
}

releases_disd <- function(publication_level = FALSE){
  releases <- releases_published_since() |>
    dplyr::left_join(
      readr::read_csv("data/publication_info.csv") |>
        select(PublicationId, division), 
      by = "PublicationId"
    ) |>
      dplyr::filter(division == "Data insights and statistics division")
  if(publication_level){
    releases <- releases |> 
      dplyr::summarise(first_published = min(first_published), .by = c(PublicationId, Title, Theme, division))
  }
  return(releases)
}
