api_datasets <- readr::read_csv("data/api-dataset-log.csv")
api_datasets <- api_datasets |>
  dplyr::mutate(
        num = 1,
date= as.Date(date, "%d/%m/%y")
)
date_range <- data.frame(
  date = seq(min(api_datasets$date), by = "day", length.out = 8*30.),
  num = 0
)

api_cumulative <- api_datasets |> 
  dplyr::bind_rows(date_range |> dplyr::mutate(type="New")) |>
  dplyr::bind_rows(date_range |> dplyr::mutate(type="Patch")) |>
  dplyr::bind_rows(date_range |> dplyr::mutate(type="Update")) |>
  dplyr::arrange(date) |>
  dplyr::group_by(type) |> 
  dplyr::mutate(
`Release type` = factor(type, levels = c("Patch", "Update", "New")),
    cumulative=cumsum(num)
  ) |>
  dplyr::ungroup() |>
  dplyr::summarise(cumulative = max(cumulative), .by = c(date, "Release type"))




api_cumulative |>
  ggplot2::ggplot(ggplot2::aes(x = date, y = cumulative, fill = `Release type`)) +
  ggplot2::geom_bar(
width = 1,
stat = "identity", 
position="stack"    ) +
  afcharts::theme_af() +
  ggplot2::xlab("Date")  +
  ggplot2::ylab("Cumulative\nrelease\ncount")  +
  ggplot2::scale_fill_manual(values = afcharts::af_colour_values |> unname())

ggplot2::ggsave("images/mailbox-charts/api_datasets_cumulative_released.png", width = 12)

