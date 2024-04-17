-- title: Intro to SQL Using DuckDB
-- author: Briana Barajas
-- date: 2024-04-15 & 2024-04-17

-- =============================================================
--                   Tips for Getting Started
-- =============================================================
-- Use return+shift to highlight text w/in file and run in terminal
-- Make sure to be w/in folder before entering duckDB
-- run .open <FILENAME> once in duckdb
-- Run .help to view commands
-- Use SQLite.org to see more detailed documentation for functions 


-- =============================================================
--                  Exploring Relational Databases
-- =============================================================
-- View tables within the database
.tables

-- View the top 10 rows of species table
.maxrows 10
SELECT * FROM Species;

-- SQL is case-insensitive, but capitalization is traditional
-- Reduce words using `LIMIT`
select * from Species limit 5;

-- Count number of rows
SELECT Count(*) FROM Species;

-- View non-NULL values within a specific column
SELECT Count(Scientific_name) FROM Species; 

-- =============================================================
--                    View Distinct Values
-- =============================================================
-- Count distinct species are within the bird_nest data
SELECT DISTINCT Species FROM Bird_nests;

-- Return select columns
SELECT Code, Common_name, FROM Species;

-- Get distinct combinations of two columns
SELECT DISTINCT Species, Observer FROM Bird_nests;

-- View distinct species in alphabetical order
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species;

-- =============================================================
--                       Exercise
-- =============================================================
-- QUESTION: What distinct locations occur in the Site table? 
-- Order them by location, and limit to 3 results.
SELECT DISTINCT Location FROM Site ORDER BY Location LIMIT 3;


-- START LECTURE 3.2 
-- =============================================================
--                       Filtering
-- =============================================================
-- Filter using a single condition
SELECT * FROM Site WHERE Area < 200;

-- Filter using multiple condictions
SELECT * FROM Site WHERE Area < 200 AND Location ILIKE '%usa'; --ilike is NOT case sensitive

-- String concatenation
SELECT Site_name || 'foo' FROM Site;

-- =============================================================
--                      Mutating Columns
-- =============================================================
-- Convert directly using a selection
SELECT Site_name, Area*2.47 FROM Site;

-- Convert and rename column
SELECT Site_name, Area*2.47 AS Area_acres FROM Site;


-- =============================================================
--                    Counting Groups/Values
-- =============================================================
-- count number of rows
SELECT Count(*) FROM Site;

-- number of rows with custom rowname
SELECT Count(*) AS num_rows FROM Site;

-- count non-null values in row
SELECT Count(Scientific_name) FROM Species;

-- view distinct relavence values
SELECT DISTINCT Relevance FROM Species;

-- count how many distinct values 
SELECT Count(DISTINCT Relevance) FROM Species;


-- =============================================================
--                       Group Statistics
-- =============================================================
-- find summary stats
SELECT AVG(Area) FROM Site;
SELECT MIN(Area) FROM Site;
SELECT MAX(Area) FROM Site;

-- maximum area for each site
SELECT Location, MAX(Area)
    FROM Site
    GROUP BY Location;

--- count sites in each location
SELECT Location, Count(*)
    FROM Site
    GROUP BY Location;

-- how many non-null scientific names are in each group 
SELECT Relevance, COUNT(Scientific_name)
    FROM Species
    group by Relevance;

-- =============================================================
--                       WHERE Clauses
-- =============================================================
-- max area only in canada locations
SELECT Location, MAX(Area)
    FROM Site
    WHERE Location LIKE '%Canada' -- like is case sensitive
    GROUP BY Location;

-- max areas in canada locations, over 200 
SELECT Location, MAX(Area) as Max_area
    from Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200; --pay attention to the order of functions, it impacts the answer

-- =============================================================
--                    Relational Algebra
-- =============================================================
-- Notice that all the previous steps are returning tables, even if it is a table with only one values.
-- We can then reuse these tables in new operations

-- count the rows of a newly created table
SELECT Count(*) FROM (
    SELECT Count(*) FROM Site
);

-- check if there's nest data for all species
SELECT * FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species from Bird_nests);

-- =============================================================
--                    Creating Tables
-- =============================================================

-- creating temporary tables (will delete when duckdb restarts)
CREATE TEMP TABLE t AS
    SELECT * FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
    SELECT * FROM t;

-- creating permanent tables
CREATE TABLE t_perm AS  
    SELECT * FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
    SELECT * FROM t_perm;

-- view new tables in database.db
.tables

-- =============================================================
--                    Processing NULL Values
-- =============================================================
-- SQL is known as having "tri-value logic". Where the third value is NULL
-- In this example, you would think summing >5 and <=5 would equal the total number of rows
-- This is not the case, because the total number of rows includes NULL
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge > 5;
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge <=5;
SELECT COUNT(*) FROM Bird_nests;

-- Counting NULL values
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NULL;

-- =============================================================
--                       Joining Data
-- =============================================================
-- join camp assignments to personel 
SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation -- this method will keep both the join columns
    LIMIT 5;

-- join using select columns
SELECT Name, Year, Site, Start, "End"
    FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 5;

-- Change colnames while joining
-- this method also call column names directly using a .
SELECT * FROM Camp_assignment AS ca JOIN Personnel p
    ON ca.Observer = p.Abbreviation
    LIMIT 5;

-- joining multiple tables
SELECT * FROM Camp_assignment ca JOIN Personnel p
    ON ca.Observer = p.Abbreviation
    JOIN Site s
    ON ca.Site = s.Code
    LIMIT 5;