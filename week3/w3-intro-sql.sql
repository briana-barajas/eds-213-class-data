-- title: Intro to SQL Using DuckDB
-- author: Briana Barajas
-- date: 2024-04-15

-- =============================================================
--                   Tips for Getting Started
-- =============================================================
-- Use return+shift to highlight text w/in file and run in terminal
-- Make sure to be w/in folder before entering duckDB
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
