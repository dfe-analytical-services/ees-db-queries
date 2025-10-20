library(readr)

ssu_team <- c("explore.statistics", "cameron.race", "richard.bielby", "jen.machin", "menna.zayed", "lauren.snaathorst", "laura.selby")
automated_mailers <- c(
  "DefenderCloudnoreply@microsoft.com",
"notifications@github.com",
"microsoft@powerapps.com",
"globalsign.com",
"pulsetic",
"statuspage",
"github.com",
"postmaster"
)

dfe_teams <- c(
  "hop.statistics",
  "FE.OFFICIALSTATISTICS@education.gov.uk",
  "Primary.ATTAINMENT@education.gov.uk",
  "Schools.STATISTICS@education.gov.uk",
  "SchoolWorkforce.STATISTICS@education.gov.uk",
  "Attainment.STATISTICS@education.gov.uk"
)


spam <- c("toiletr", "holidays", "carpark", "parking", "airport", "promotions", "sales")


folder <- "~/../Explore education statistics platforms/Analytics and performance/mailbox-stats/"



mailbox_stats <- readr::read_csv(file.path(folder, "ees-mailbox-record-2025-10-20.csv"))

most_common <- mailbox_stats |>
  dplyr::summarise(n = dplyr::n(), .by = "From") |>
  dplyr::arrange(-n)



mailbox_cleaned <- mailbox_stats |>
  dplyr::filter(
    !grepl(paste(ssu_team, collapse = "|"), From, ignore.case=TRUE),
    !grepl(paste(automated_mailers, collapse = "|"), From, ignore.case=TRUE),
    !grepl(paste(dfe_teams, collapse = "|"), From, ignore.case=TRUE),
    !grepl(paste(spam, collapse = "|"), From, ignore.case=TRUE)
  ) |>
  dplyr::mutate(
    Source = factor(
      dplyr::case_when(
      grepl("education.gov.uk", From, ignore.case=TRUE) ~ "DfE",
      grepl("trust|sch.uk|school|academy|academies", From, ignore.case=TRUE) ~ "School or trust",
      grepl("gov.uk|nhs.uk", From, ignore.case=TRUE) ~ "Other Gov department",
      grepl("ac.uk|.edu", From, ignore.case=TRUE) ~ "Higher education",
      grepl("bbc.co.uk|theguardian.co.uk|the-times.co.uk|thetimes.co.uk", From, ignore.case=TRUE) ~ "Media",
      .default = "Other"
    ),
  levels = c("DfE", "Other Gov department", "School or trust", "Higher education", "Media", "Other"))
  )

most_common_cleaned <- mailbox_cleaned |>
  dplyr::summarise(n = dplyr::n(), .by = "From") |>
  dplyr::arrange(-n)


# This creates a bar chart of weekly e-mails to the mailbox
mailbox_cleaned |>
  ggplot2::ggplot(ggplot2::aes(x=received)) +
  ggplot2::geom_bar(
    stat="bin", 
    fill = afcharts::af_colour_values[["dark-blue"]], 
    bins = 52
  ) +
  afcharts::theme_af() +
  ggplot2::xlab("Date received")  +
  ggplot2::ylab("Weekly e-mails") 

ggplot2::ggsave("images/mailbox-charts/mailbox_timeseries_summary.png")

# This creates a bar chart of monthly e-mails to the mailbox split by source (i.e. DfE, 
# Other Gov, Schools etc, HE, Media enquiries...)
mailbox_cleaned |>
  ggplot2::ggplot(ggplot2::aes(x=received, fill = Source)) +
  ggplot2::geom_bar(
    stat="bin", 
    bins = 12
  ) +
  afcharts::theme_af() +
  ggplot2::xlab("Date received")  +
  ggplot2::ylab("Monthly e-mails") +
  ggplot2::theme(legend.position = "bottom") +
  ggplot2::scale_fill_manual(values = afcharts::af_colour_values |> unname())

ggplot2::ggsave("images/mailbox-charts/mailbox_timeseries_by_source.png", width = 12)