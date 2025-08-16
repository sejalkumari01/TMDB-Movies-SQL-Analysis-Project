CREATE DATABASE movies;

USE movies;

SHOW TABLES;

SELECT * 
FROM movie;

CREATE TABLE movie AS
SELECT id,
original_title AS title,
budget,
revenue,
release_date,
genres,
popularity,
vote_average,
vote_count,
runtime,
original_language,
production_companies,
production_countries,
status
FROM movies;

CREATE VIEW TotalMovies AS
SELECT COUNT(*) AS TotalNumberOfMovies
FROM movies;

SELECT * FROM TotalMovies;

DESC movie;

UPDATE movie
SET release_date = STR_TO_DATE(release_date, '%d-%m-%Y');

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE movie
MODIFY release_date DATE;

CREATE VIEW MoviePerYear AS
SELECT Year(release_date) AS year, 
COUNT(*) AS TotalMovies
FROM movie 
GROUP BY Year(release_date)
ORDER BY Year(release_date);

CREATE VIEW MostVotedMovie as
SELECT title
FROM movie
ORDER BY vote_average DESC
LIMIT 10;

CREATE VIEW LongestRunTime as
SELECT title
FROM movie
ORDER BY runtime DESC
LIMIT 1;

CREATE VIEW MoviePerGenre AS
SELECT g.genre,
       COUNT(*) AS movie_count
FROM movie
CROSS JOIN JSON_TABLE(
    movie.genres,
    '$[*]' COLUMNS (
        genre VARCHAR(100) PATH '$.name'
    )
) AS g
GROUP BY g.genre
ORDER BY movie_count DESC;

CREATE VIEW AvgBudget AS
SELECT Year(release_date) AS year, 
ROUND(AVG(budget), 0) AS AvgBudget
FROM movie 
GROUP BY Year(release_date)
ORDER BY Year(release_date);

CREATE VIEW After2000 AS 
SELECT COUNT(*)
FROM movie 
WHERE Year(release_date)>2000;

CREATE VIEW Zero AS
SELECT title
FROM movie 
WHERE budget= 0 OR revenue= 0;

CREATE VIEW TopBugdet AS
SELECT title AS TopBugdetMovie
FROM movie 
ORDER BY budget DESC
LIMIT 5;

CREATE VIEW TopRevenue AS
SELECT title AS TopRevenueMovie
FROM movie 
ORDER BY revenue DESC
LIMIT 5;

CREATE VIEW Top5Genre AS
SELECT g.genre,
       COUNT(*) AS movie_count
FROM movie
CROSS JOIN JSON_TABLE(
    movie.genres,
    '$[*]' COLUMNS (
        genre VARCHAR(100) PATH '$.name'
    )
) AS g
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 5;

CREATE VIEW AvgRevenue AS
SELECT g.genre,
       ROUND(AVG(revenue),0) AS AvgRevenue
FROM movie
CROSS JOIN JSON_TABLE(
    movie.genres,
    '$[*]' COLUMNS (
        genre VARCHAR(100) PATH '$.name'
    )
) AS g
GROUP BY g.genre
ORDER BY AvgRevenue DESC
LIMIT 5;

CREATE VIEW AvgVote AS
SELECT g.genre,
       ROUND(AVG(vote_average),0) AS vote_average
FROM movie
CROSS JOIN JSON_TABLE(
    movie.genres,
    '$[*]' COLUMNS (
        genre VARCHAR(100) PATH '$.name'
    )
) AS g
GROUP BY g.genre
ORDER BY vote_average DESC;

CREATE VIEW MovieCountDacade AS
SELECT 
    (YEAR(release_date) DIV 10) * 10 AS decade,
    COUNT(*) AS total_movies
FROM movie
WHERE release_date IS NOT NULL
GROUP BY decade
ORDER BY decade;

CREATE VIEW Corr AS
SELECT 
    title,
    budget,
    revenue,
    (revenue - budget) AS profit,
    ROUND((revenue - budget) / NULLIF(budget, 0), 2) AS roi
FROM movie
WHERE budget > 0 AND revenue > 0
ORDER BY roi DESC;

CREATE VIEW MostProfitable AS
SELECT 
    title,
    (revenue - budget) AS profit
FROM movie
ORDER BY (revenue - budget) DESC
LIMIT 1;    

CREATE VIEW HigestRevPopularity AS
SELECT 
    title,
    revenue,
    popularity
FROM movie 
ORDER BY revenue DESC,
    popularity DESC;  
    
CREATE VIEW HigestRated AS
SELECT 
    title,
    budget,
    vote_average
FROM movie 
ORDER BY vote_average DESC,
    budget; 
    
CREATE VIEW Ranked AS
WITH genre_revenue AS (
    SELECT 
        YEAR(m.release_date) AS release_year,
        g.genre,
        SUM(m.revenue) AS total_revenue
    FROM movie m
    CROSS JOIN JSON_TABLE(
        m.genres,
        '$[*]' COLUMNS (
            genre VARCHAR(100) PATH '$.name'
        )
    ) AS g
    WHERE m.revenue > 0 
      AND m.release_date IS NOT NULL
    GROUP BY release_year, g.genre
),
ranked_genres AS (
    SELECT 
        release_year,
        genre,
        total_revenue,
        RANK() OVER (PARTITION BY release_year ORDER BY total_revenue DESC) AS genre_rank
    FROM genre_revenue
)
SELECT 
    release_year,
    genre,
    total_revenue,
    genre_rank
FROM ranked_genres
WHERE genre_rank <= 5
ORDER BY release_year, genre_rank;

CREATE VIEW vote_average AS
SELECT 
    title,
    vote_average,
    revenue
FROM movie
WHERE vote_average >= 8
  AND revenue < 1000000   -- threshold for "low revenue"
ORDER BY vote_average DESC, revenue ASC;

WITH genre_revenue AS (
    SELECT 
        YEAR(m.release_date) AS release_year,
        g.genre,
        SUM(m.revenue) AS total_revenue
    FROM movie m
    CROSS JOIN JSON_TABLE(
        m.genres,
        '$[*]' COLUMNS (
            genre VARCHAR(100) PATH '$.name'
        )
    ) AS g
    WHERE m.revenue > 0 
      AND m.release_date IS NOT NULL
    GROUP BY release_year, g.genre
),
ranked_genres AS (
    SELECT 
        release_year,
        genre,
        total_revenue,
        RANK() OVER (PARTITION BY release_year ORDER BY total_revenue DESC) AS genre_rank
    FROM genre_revenue
)
SELECT *
FROM ranked_genres
WHERE genre_rank <= 5
ORDER BY release_year, genre_rank;

CREATE VIEW Analysis AS
SELECT 
    title,
    vote_average,
    vote_count,
    CASE 
        WHEN vote_average >= 8 AND vote_count < 3000 THEN 'Underrated'
        WHEN vote_average < 6 AND vote_count > 8000 THEN 'Overrated'
        ELSE 'Neutral'
    END AS rating_category
FROM movie
WHERE vote_count > 0;
   
CREATE VIEW genres AS  
WITH movie_genres AS (
    SELECT 
        m.title,
        g.genre,
        m.popularity,
        RANK() OVER (PARTITION BY g.genre ORDER BY m.popularity DESC) AS genre_rank
    FROM movie m
    CROSS JOIN JSON_TABLE(
        m.genres,
        '$[*]' COLUMNS (
            genre VARCHAR(100) PATH '$.name'
        )
    ) AS g
)
SELECT *
FROM movie_genres
WHERE genre_rank <= 10   -- top 10 per genre
ORDER BY genre, genre_rank;

-- END