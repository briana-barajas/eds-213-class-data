-- title: SQL Operations Cont.
--- subtitle: Joins, view, set operations, and triggers
-- author: Briana Barajas
-- date: 2024-04-22

-- =============================================================
--                   Tips for Getting Started
-- =============================================================
-- Data is NOT in the same folder as this file. Make sure to be 
-- within the week3 folder in the terminal to access the datanbase.

-- =============================================================
--                       Nested Queries
-- =============================================================
-- So far we've done single queries. Here, count nests by species
SELECT Species, COUNT(*) AS Nest_count
    FROM Bird_nests
    WHERE Site = 'nome'
    GROUP BY Species
    ORDER BY Species 
    LIMIT 2;

-- nested query: creating a nest count table while also joining to code
-- column in 
SELECT Scientific_name, Nest_count FROM
    (SELECT Species, COUNT(*) AS Nest_count
    FROM Bird_nests
    WHERE Site = 'nome'
    GROUP BY Species
    ORDER BY Species LIMIT 2) JOIN Species ON Species = Code;

-- =============================================================
--                     Join Types
-- =============================================================
-- create temporary tables for example
CREATE TEMP TABLE a (cola INTEGER, common INTEGER);
CREATE TEMP TABLE B (common INTEGER, colb INTEGER);

-- add values into temporary tables
INSERT INTO a VALUES (1,1), (2,2), (3,3);
INSERT INTO B VALUES (2, 2), (3, 3), (4, 4), (5, 5);

-- inner join is the default
SELECT * FROM a JOIN B USING (common); -- default i think this is inner
SELECT * FROM a INNER JOIN B USING (common); -- can specify inner join

-- left or right outer join
-- this returns NULL values where there are not matches
SELECT * FROM a LEFT JOIN B USING (common);
SELECT * FROM a RIGHT JOIN B USING (common);

-- =============================================================
--                     EXAMPLE: Join Bird Data
-- =============================================================
-- QUESTION: What species do *not* have nest data?

-- this example is done without a join, using a nested query
SELECT * FROM Species
    WHERE Code NOT IN
    (SELECT DISTINCT Species FROM Bird_nests);

-- using LEFT JOIN keeps everything in the species table, 
-- even if there's no Bird_nest data, which is why there's
-- extra rows with NULL values
SELECT Code, Scientific_name, Nest_ID, Species, Year FROM Species
    LEFT JOIN Bird_nests ON Code = Species;

-- compare to an INNER JOIN, which will drop values without 
-- matches, returning no NULL values. Inner is default
SELECT Code, Scientific_name, Nest_ID, Species, Year FROM Species
    INNER JOIN Bird_nests ON Code = Species;

-- to answer the same Q using a join, join data and filter
SELECT Code, Scientific_name, Nest_ID, Species, Year FROM Species
    LEFT JOIN Bird_nests ON Code = Species
    WHERE Nest_ID IS NULL;

-- =============================================================
--                     Caution While Joining
-- =============================================================
-- QUESTION: How many eggs are in each nest?

-- This join is adding additinal replicated rows bc of the join
SELECT * FROM Bird_eggs LIMIT 3;
SELECT * FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01';

-- This result (i think) better shows how many eggs are within 
-- this single nest by using a GROUP BY
SELECT Nest_ID, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID;

-- solutions ?
SELECT Nest_ID, ANY_VALUE(Species), COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID;

-- =============================================================
--                           Views
-- =============================================================
-- lets say you keep recreating this table
SELECT Year, Site, Name, Start, "End"
    FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation;

-- use view to recreate the table above
CREATE VIEW v AS
    SELECT Year, Site, Name, Start, "End"
    FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation;

-- View is more dynamic than a temp table. The computation in the
-- step above is being called every time you use v in a query
SELECT * FROM v;

-- =============================================================
--                           Set Operations
-- =============================================================
-- PROBLEM: lets say we suspect the book page length is in the wrong units
-- UNION lets you to fix select page numbers by matching tables together
SELECT Book_page, Nest_ID, Egg_num, Length*25.4, Width*25.4 FROM Bird_eggs
    WHERE Book_page = 'b14.6'
    UNION
    SELECT Book_page, Nest_ID, Egg_num, Length, Width, FROM Bird_eggs
    WHERE Book_page != 'b14.6';

-- UNION vs. UNION ALL
-- union all is considered unintelligent, as it mashes tables together
-- QUESTION: Which species have *no* nest data?
SELECT Code FROM Species
    EXCEPT SELECT DISTINCT Species FROM Bird_nests;