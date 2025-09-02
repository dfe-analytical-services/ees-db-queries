-- Check role Ids
SELECT DISTINCT [Id],[Name]
  FROM [dbo].[AspNetRoles]

-- Get all user names who are approvers or analysts
SELECT u.[UserName]
FROM [dbo].[AspNetUserRoles] ur
INNER JOIN [dbo].[AspNetUsers] u ON ur.[UserId] = u.[Id]
WHERE ur.[RoleId] IN ('cf67b697-bddd-41bd-86e0-11b7e11d99b3', 'f9ddb43e-aa9e-41ed-837d-3062e130c425');