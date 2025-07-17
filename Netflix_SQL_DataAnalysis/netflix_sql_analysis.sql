
select * from netflix; 
select count(*) as total_content from netflix;

-- Basic exploration of the dataset
select distinct type from netflix;

-- Count the number of Movies vs TV Shows
select count(case when type ='Movie' then 1 else null end ) as movie_count, 
       count(case when type ='TV Show' then 1 else null end) as tv_show_count
from netflix;

-- Show distribution of types with grouping
select count(*) from netflix where type is not null group by type;

-- Find the most common rating for Movies and TV Shows
with cte1 as (
    select type, rating, 
           row_number() over(partition by type order by count(*) desc) as rnk 
    from netflix  
    where type is not null 
    group by type, rating
)
select type, rating from cte1 where rnk = 1;

-- List all Movies released in a specific year (2020)
select release_year, title, type, 
       row_number() over(partition by release_year) as row_num  
from netflix 
where lower(type) = 'movie' and release_year = 2020;

-- Top 5 countries with the most content on Netflix
-- Note: 'country' contains comma-separated values

WITH RECURSIVE split_country AS (
  -- Anchor member: extract the first country
  SELECT 
    show_id,
    TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country_part,
    SUBSTRING(country, LENGTH(SUBSTRING_INDEX(country, ',', 1)) + 2) AS remaining,
    1 AS part_num
  FROM netflix
  WHERE country IS NOT NULL

  UNION ALL

  -- Recursive member: extract next country
  SELECT
    show_id,
    TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS country_part,
    SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2),
    part_num + 1
  FROM split_country
  WHERE remaining != ''
)
SELECT country_part, count(show_id) as total_content
FROM split_country
WHERE country_part != ''
GROUP BY country_part
ORDER BY total_content DESC
LIMIT 5;

-- Identify the longest Movie based on duration
select show_id, title, country, duration, 
       dense_rank() over(order by duration desc) as rnk 
from netflix
where type = 'Movie';

-- Alternative method
select show_id, title, country, duration 
from netflix
where type = 'Movie'
order by duration desc;

-- List all Movies and Shows directed by 'Christopher Nolan'
select title 
from netflix 
where lower(director) like '%christopher nolan%';

-- List all TV shows with more than 5 seasons
select title, duration
from netflix
where lower(type) = 'tv show' and substr(duration, 1, 1) > 5;

-- Count the number of content items in each genre

WITH RECURSIVE split_genre AS (
  -- Anchor member: extract the first genre
  SELECT
    show_id,
    TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
    SUBSTRING(listed_in, LENGTH(SUBSTRING_INDEX(listed_in, ',', 1)) + 2) AS remaining
  FROM netflix
  WHERE listed_in IS NOT NULL

  UNION ALL

  -- Recursive member: extract next genre
  SELECT
    show_id,
    TRIM(SUBSTRING_INDEX(remaining, ',', 1)),
    SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2)
  FROM split_genre
  WHERE remaining != ''
)
SELECT count(show_id) as total_content, genre
FROM split_genre
WHERE genre != ''
GROUP BY genre;

-- Find top 5 years with the highest average content released by the US

WITH cte1 AS (
    SELECT *, 
           str_to_date(trim(date_added), '%d-%b-%y') AS added_date  
    FROM netflix
),
cte2 AS (
    SELECT year(added_date) AS years, 
           count(show_id) AS total_content 
    FROM cte1 
    WHERE country = 'United States' AND added_date IS NOT NULL 
    GROUP BY year(added_date)
),
cte3 AS (
    SELECT years, 
           ROUND((total_content / 
               (SELECT count(*) FROM netflix WHERE country = 'United States')) * 100, 2) AS avg_content 
    FROM cte2
),
cte4 AS (
    SELECT *, 
           dense_rank() OVER (ORDER BY avg_content DESC) AS rnks 
    FROM cte3
)
SELECT * FROM cte4;

-- List all Movies that are Documentaries
select distinct title, listed_in 
from netflix 
where lower(listed_in) like '%documentaries%';

-- Find all content with no director listed
select title, listed_in, director 
from netflix 
where director = '';

-- Find Movies where 'Shah Rukh Khan' appeared in the last 20 years
select * 
from netflix 
where cast like '%Shah Rukh Khan%' 
  and (year(current_date()) - release_year) <= 20;

-- Top 10 actors who appeared in the most films in the United States

WITH RECURSIVE split_cast AS (
  -- Anchor member: extract first actor
  SELECT 
    show_id, type, title,
    TRIM(SUBSTRING_INDEX(cast, ',', 1)) AS actor,
    TRIM(SUBSTRING(cast, LENGTH(SUBSTRING_INDEX(cast, ',', 1)) + 2)) AS remaining
  FROM netflix
  WHERE cast IS NOT NULL AND cast != '' 
    AND type = 'Movie' 
    AND country = 'United States'

  UNION ALL

  -- Recursive member: extract next actor
  SELECT 
    show_id, type, title,
    TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS actor,
    TRIM(SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2)) AS remaining
  FROM split_cast
  WHERE remaining IS NOT NULL AND remaining != '' 
)
SELECT count(show_id) AS total_movies, actor
FROM split_cast
WHERE actor != ''
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;

-- Categorize content as 'Bad' if description contains 'kill' or 'violence', otherwise 'Good'
WITH categorized AS (
    SELECT title, listed_in, description,
           CASE 
               WHEN lower(description) LIKE '%kill%' OR lower(description) LIKE '%violence%' THEN 'Bad' 
               ELSE 'Good' 
           END AS Categories
    FROM netflix
)
SELECT Categories, count(*) AS number_of_content 
FROM categorized 
GROUP BY Categories;
