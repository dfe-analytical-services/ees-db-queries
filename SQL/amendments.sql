-- Get a table of all amendments for a given period, and their publication titles

-- If using for regular reporting:
    -- Update the date range
    -- Export and manually add flags for 
        -- major / minor / discounted (discount any that aren't 'corrections', major corrections must impact national headlines)
        -- DISD / not-DISD

-- Need to join 3 tables to connect the publication titles to amendments
WITH version_names AS (
  SELECT 
        rv.[Id] as releaseVersion,
        [Title]
    FROM [dbo].[ReleaseVersions] rv
    LEFT JOIN [dbo].[Publications] p ON rv.[PublicationId] = p.[Id]
)

SELECT
    [Title],
    [On],
    [Reason]
FROM [dbo].[Update] u
LEFT JOIN version_names vn ON u.[ReleaseVersionId] = vn.[releaseVersion]

-- Filter to the reporting period used
WHERE MONTH([On]) IN (10,11,12) and YEAR([On]) = 2025