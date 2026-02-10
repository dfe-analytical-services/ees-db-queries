# Example usage:
# length_stats(nchar(ft_summaries$Description), "Featured table description", 200)

length_stats <- function(col, item_name, limit) {

  # Remove NULL values and count them
  initial_length <- nrow(col)
  col <- col[col != 'NULL']
  null_count <- initial_length - length(col)
  
  # Print the number of NULL values removed and remaining valid values
  cat("Number of NULL values removed:", null_count, "\n")
  cat("Number of remaining valid values:", length(col), "\n")
  
  # Convert to string lengths
  lengths <- nchar(col)

  # Calculate mean, median, and quartiles
  mean_length <- mean(lengths, na.rm = TRUE)
  median_length <- median(lengths, na.rm = TRUE)
  quartiles <- quantile(lengths, na.rm = TRUE)
  max_length <- max(lengths, na.rm = TRUE)
  
  # Print the results
  cat("Summary stats for:", item_name, "\n")
  cat("Mean length:", mean_length, "\n")
  cat("Median length:", median_length, "\n")
  cat("Max length:", max_length, "\n")
  cat("Quartiles:\n")
  print(quartiles)
  cat("Percentage below limit:", sum(lengths < limit) / length(lengths), "\n")
  
  # Calculate and print the percentile of the limit
  percentile <- ecdf(lengths)(limit) * 100
  cat("Percentile of the limit:", percentile, "\n")
}
# Source queries:
# SELECT [Description] FROM [dbo].[FeaturedTables]
# SELECT [Name] FROM [dbo].[FeaturedTables]
# SELECT [Summary] FROM [dbo].[ReleaseFiles] WHERE [Order] != 0 AND [Summary] NOT LIKE '%<%>%' -- filter out non-data files and old html summaries
# SELECT [Name] FROM [dbo].[ReleaseFiles] WHERE [Order] != 0
ft_summaries <- read.csv(file.choose())
ft_names <- read.csv(file.choose())
ds_summaries <- read.csv(file.choose())
ds_names <- read.csv(file.choose())

testthat::expect_equal(nrow(ft_summaries), nrow(ft_names))
testthat::expect_lt(nrow(ds_summaries), nrow(ds_names)) # less than as the data set summaries are dropping HTML summaries

# Calculate the lengths of the descriptions
length_stats(ft_summaries[1], "Featured table descriptions", 200)
length_stats(ft_names[1], "Featured table titles", 120)
length_stats(ds_summaries[1], "Data set descriptions", 250)
length_stats(ds_names[1], "Data set titles", 120)
