-- Database: netflix

-- DROP DATABASE IF EXISTS netflix;

CREATE DATABASE netflix
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
    show_id VARCHAR(8),
    type VARCHAR(10),    
    title VARCHAR(150),    
    director VARCHAR(208),
    casts VARCHAR(1000),    
    country VARCHAR(150),    
    date_added VARCHAR(50),    
    release_year INT,
    rating VARCHAR(10),    
    duration VARCHAR(15),    
    listed_in VARCHAR(100),    
    description VARCHAR(258)
);

SELECT* FROM netflix;

SELECT 
COUNT(*) as total_content
FROM netflix;

SELECT 
      DISTINCT type
FROM netflix;

SELECT COUNT(*) AS movie_count
FROM netflix
WHERE type = 'Movie';

SELECT
     type,
	 COUNT(*) as total_count
FROM netflix

GROUP BY type 

SELECT
     type,
	 rating,
	 COUNT(*) 
	 RANK() OVER (PARTITION BY type ORDER BY COUNT(*)) as ranking
FROM netflix
GROUP BY type,rating;

SELECT
    type,
    rating,
    COUNT(*) AS total_count,
    RANK() OVER (
        PARTITION BY type
        ORDER BY COUNT(*) DESC
    ) AS ranking
FROM netflix
GROUP BY type, rating;

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added
FROM netflix
WHERE EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) = 2008;

SELECT
    country,
    show_id,
    type,
    COUNT(*) AS total_count
FROM netflix
GROUP BY country, show_id, type
ORDER BY type DESC
LIMIT 5;


SELECT 
    UNNEST(STRING_TO_ARRAY(country,',')) as new_country
FROM netflix

SELECT DISTINCT duration
FROM netflix

SELECT *,
       TO_DATE(date_added, 'Month DD, YYYY') AS added_date
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') = CURRENT_DATE - INTERVAL '5 years';


SELECT title
FROM netflix
WHERE director LIKE  '%Rajiv Chilaka%';

SELECT *,
      --SPLIT_PART(duration, ' ', 1) as sessions
FROM netflix 

WHERE 
     type = 'TV Show'
      SPLIT_PART(duration, ' ', 1) as  > 5 sessions

SELECT *,
       CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) AS numeric_duration
FROM netflix
WHERE (
        (type = 'TV Show' AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5)
     OR (type = 'Movie'   AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 90)
      );

SELECT 
   listed_in,
   show_id,
   UNNEST (STRING_TO_ARRAY(listed_in, ','))
FROM netflix
GROUP BY listed_in;


SELECT 
    show_id,
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre
FROM netflix;

SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS total_shows,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix WHERE country = 'India') AS avg_content_percentage
FROM netflix
WHERE country = 'India'
GROUP BY year
ORDER BY year;


SELECT *
FROM netflix
WHERE listed_in ILIKE '%documentaries%';

SELECT *
FROM netflix
WHERE 
     casts ILIKE '%Salman Khan%'
	 AND
	 release_year> EXTRACT(YEAR FROM CURRENT_DATE -INTERVAL 18)
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '10 years');


SELECT 
---show_id
---cast,

UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) AS total_cotent
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1 
ORDER BY 2 DESC


WITH new_table AS (
    SELECT *,
           CASE 
               WHEN description ILIKE '%kill%' 
                 OR description ILIKE '%violence%' 
               THEN 'Bad_Content'
               ELSE 'Good Content'
           END AS category
    FROM netflix
)

SELECT 
      category,
      COUNT(*) as total_count
FROM new_table
GROUP BY 1



