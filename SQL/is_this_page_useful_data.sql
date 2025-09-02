-- Get all page feedback data
/*
SELECT [Id]
  ,[Created]
  ,[Url]
  ,[UserAgent]
  ,[Response]
  ,[Context]
  ,[Issue]
  ,[Intent]
  ,[Read]
  FROM [dbo].[PageFeedback]
*/

-- Get all written pieces of feedback
SELECT [Created],
   [Url],
   [Response],
   [Context],
   [Issue],
   [Intent]
  FROM [dbo].[PageFeedback]
    WHERE [Context] IS NOT NULL
    OR [Issue] IS NOT NULL
    OR [Intent] IS NOT NULL;

-- Get count of each possible response by URL
SELECT [Url], [Response], COUNT(*) AS ResponseCount
  FROM [dbo].[PageFeedback]
  GROUP BY [Url], [Response];

-- Get overall summary
SELECT [Response], SUM(ResponseCount) AS TotalResponseCount
FROM (
  SELECT [Url], [Response], COUNT(*) AS ResponseCount
  FROM [dbo].[PageFeedback]
    GROUP BY [Url], [Response]
) AS SubQuery
GROUP BY [Response];