publication_contacts <- function(){
    conn_content <- content_database()
  dplyr::tbl(conn_content, DBI::Id(schema = "dbo", "Publications")) |>
    left_join(
      dplyr::tbl(conn_content, DBI::Id(schema = "dbo", "Contacts")),
      by = join_by(ContactId == Id)
    )
}