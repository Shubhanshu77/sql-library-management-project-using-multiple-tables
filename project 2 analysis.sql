--Netflix Movies and TV Shows Data Analysis using SQL




---Overview This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.


---## Objectives

-- Analyze the distribution of content types (movies vs TV shows).
-- Identify the most common ratings for movies and TV shows.
-- List and analyze content based on release years, countries, and durations.
-- Explore and categorize content based on specific criteria and keywords.

--Dataset

--The data for this project is sourced from the Kaggle dataset:

-- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

-- Schema


drop table if exists netflix;
create table netflix
(
  show_id varchar (10),
  type varchar (10),
  title varchar (150),
  director varchar(208),
  casts varchar(1000),
  country	varchar(150),
  date_added varchar (50),
  release_year int,
  rating	varchar(10),
  duration	varchar(10),
  listed_in	varchar(100),
  description varchar(250) 
  );


select * from netflix

select count(*) show_id
from netflix

select distinct 
    type
	from netflix


-- Business Problems and Solutions	

---task 1. Count the Number of Movies vs TV Shows

select 
type,
count(type)
from netflix 
group by 1



--**Objective:** Determine the distribution of content types on Netflix.


---task 2 Find the Most Common Rating for Movies and TV Shows


select 
   type,
   rating
from
(
select 
type,
rating,
count(rating ),
rank() over(partition by type order by count(*) desc) as ranking
from netflix 
group by 1,2
 ) as t1
where ranking = 1




---task 3 List All Movies Released in a Specific Year (e.g., 2020)

--filter2020
--movies

select * from netflix
where
 type ='Movie'
 and
 release_year = 2020




---task 4. Find the Top 5 Countries with the Most Content on Netflix

---unnesting countries by comma 
select
unnest(string_to_array(country, ',')) as new_country
from netflix



 select 
 unnest(string_to_array(country, ',')) as new_country,
 count(show_id) as total_count
 from netflix
 group by 1
 order by 2 desc limit 5 




---task 5 Identify the Longest Movie

select* from netflix
where 
 type ='Movie'
 and
 duration = (select max(duration) from netflix)


--


-task 6 Find Content Added in the Last 5 Years

 select *
--- to_date (date_added,'month DD ,YYYY')
 from netflix
 where to_date (date_added,'month DD ,YYYY') >= current_date - interval'5year'





---task 7Find All Movies/TV Shows by Director 'Rajiv Chilaka'

 select * from netflix
 where director like '%Rajiv Chilaka%'
 



--task8List All TV Shows with More Than 5 Seasons

select 
*
from netflix
where 
type = 'TV Show'
and
split_part(duration,' ',1):: numeric > 5




--task9  Count the Number of Content Items in Each Genre
---unnesting first genre 

select
 unnest(string_to_array(listed_in,',')) as genre,  
 count(show_id)
 --unnest(string_to_array(listed_in,','))  
 from netflix
 group by 1


---task 10 Find each year and the average numbers of content release in India on netflix.

select 
extract (year from to_date(date_added, 'Month DD,YYYY') )as date,
count(*) as yearly_content,
count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric * 100 as average_contet
from netflix
where country ='India'
group by 1


---task 11 List All Movies that are Documentaries

---select
--unnest(string_to_arruay(listed_in,',')) as genre
--from netflix
--where unnest(string_to_arruay(listed_in,',')) = 'Documentries'

select* from netflix
where listed_in Ilike '%documentaries%'


---task12Find All Content Without a Director


select* from netflix 
 where director is null

---task13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

select * from netflix

where 
   casts ilike '%salman khan%' 
and
release_year > extract(year from current_date) - 10



---14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select

 unnest(string_to_array(casts,',')) as actors,
 count(*) as total_content
   from netflix
   where country ilike '%india%'
   group by 1
   order by 2 desc
   limit 10




   

---15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

with new_table
as(
select
*,
case 
when description ilike '%kill%' or description ilike '%violence%'
      then 'bad_content'
	  else 'good_content'
	  end category

from netflix
)
 select
 category,
 count(*) as total_count
 from new_table
 group by 1




--where 
--description ilike '%kill%'
--or
--description ilike '%violence%'

--## Findings and Conclusion

-- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
--**Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
--**Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
--**Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

--This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
---thank you





  