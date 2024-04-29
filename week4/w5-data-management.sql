-- title: Data Management & Input/Output (IO)
-- author: Briana Barajas
-- date: 2024-04-29

-- =============================================================
--                   Tips for Getting Started
-- =============================================================
-- Used week4 data in eds-213-class-data repository

-- =============================================================
--                       Insert Statements
-- =============================================================
-- manual insertions
INSERT INTO Species
    VALUES ('abcd', 'thing', 'scientific name', NULL);

-- explicitly label new columns
INSERT INTO Species (Common_name, Scientific_name, Code, Relevance)
    VALUES ('thing 2', 'another scientific name', 'efgh', NULL);

-- PROBLEM: For the previous statements, we're relying on the fact that columns 
-- are in the same order. It's much safer to name columns like so:
INSERT INTO Species (Common_name, Code) VALUES
    ('thing3', 'ijkl');

-- view additions (last 3 rows)
SELECT * FROM Species;

-- =============================================================
--                        Update & Delete
-- =============================================================
-- update species relavance
-- adding "not sure yet" to NULL values
UPDATE Species SET Relevance = 'not sure yet'
    WHERE Relevance IS NULL;
SELECT * FROM Species;

-- delete newly added rows with "not sure yet"
DELETE FROM Species WHERE Relevance = 'not sure yet';
SELECT * FROM Species;

-- =============================================================
--                     Deleting Best-Practices
-- =============================================================
-- Deleting can be risky, it's easy to accidentally delete an
-- entire dataset. For best practice, create different statements to ensure
-- you're deleting the desired data. There's no undo button.

-- using SELECT statements to check what would be deleted
SELECT * from Species WHERE Relevance = 'Study species';

-- incomplete statements (type everything but delete)
-- [Add delete later] FROM Species WHERE...

-- =============================================================
--                     Import/Exporting Data
-- =============================================================
-- export data as CSV
COPY Species -- name of table
    TO 'species_fixed.csv' -- name of file
    (HEADER, DELIMITER ','); -- keep header & specify delimiter

-- NOTE: Two step process for importing data
-- 1. Create an empty table
CREATE TABLE Snow_cover2 (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Date DATE NOT NULL,
    Plot VARCHAR, -- some Null in the data :/
    Location VARCHAR NOT NULL,
    Snow_cover INTEGER CHECK (Snow_cover > -1 AND Snow_cover < 101),
    Observer VARCHAR
);

.tables;

-- 2. Import table
COPY Snow_cover2 FROM 'snow_cover_fixedman_JB.csv' (HEADER TRUE);
SELECT * FROM Snow_cover2;


