SELECT DISTINCT
    p.Title AS publication_title,
    t.Title AS theme_title
FROM
    dbo.Publications p
INNER JOIN
    dbo.Themes t ON p.ThemeId = t.Id;