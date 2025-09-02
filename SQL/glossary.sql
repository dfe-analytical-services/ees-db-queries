-- Update glossary entry slug
UPDATE GlossaryEntries
SET Slug = 'children-missing-education'
WHERE Id = '323c329c-71f3-466c-9592-04a462bdf1aa';

-- Add new glossary entry
INSERT INTO GlossaryEntries (Id, Title, Slug, Body, Created, CreatedById)
VALUES (NEWID(), 'Academic age', 'academic-age', '<p>Age at the start of the academic year. For example, age as at 31 August.</p>', CURRENT_TIMESTAMP, 'e3f6e356-1160-4de1-a9b6-b0c17cf2ba37');