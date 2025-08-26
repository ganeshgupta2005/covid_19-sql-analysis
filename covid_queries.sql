create database sql_project2

use sql_project2

--data exploration

select * from covid19

select count(*) from covid19

select top 10 * from covid19

select distinct continent from covid19

select distinct location from covid19

--data cleaning

SELECT 
    SUM(CASE WHEN iso_code IS NULL THEN 1 ELSE 0 END) AS iso_code_nulls,
    SUM(CASE WHEN continent IS NULL THEN 1 ELSE 0 END) AS continent_nulls,
    SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS location_nulls,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS date_nulls,
    SUM(CASE WHEN total_cases IS NULL THEN 1 ELSE 0 END) AS total_cases_nulls,
    SUM(CASE WHEN new_cases IS NULL THEN 1 ELSE 0 END) AS new_cases_nulls,
    SUM(CASE WHEN new_cases_smoothed IS NULL THEN 1 ELSE 0 END) AS new_cases_smoothed_nulls,
    SUM(CASE WHEN total_deaths IS NULL THEN 1 ELSE 0 END) AS total_deaths_nulls,
    SUM(CASE WHEN new_deaths IS NULL THEN 1 ELSE 0 END) AS new_deaths_nulls,
    SUM(CASE WHEN new_deaths_smoothed IS NULL THEN 1 ELSE 0 END) AS new_deaths_smoothed_nulls,
    SUM(CASE WHEN total_cases_per_million IS NULL THEN 1 ELSE 0 END) AS total_cases_per_million_nulls,
    SUM(CASE WHEN new_cases_per_million IS NULL THEN 1 ELSE 0 END) AS new_cases_per_million_nulls,
    SUM(CASE WHEN new_cases_smoothed_per_million IS NULL THEN 1 ELSE 0 END) AS new_cases_smoothed_per_million_nulls,
    SUM(CASE WHEN total_deaths_per_million IS NULL THEN 1 ELSE 0 END) AS total_deaths_per_million_nulls,
    SUM(CASE WHEN new_deaths_per_million IS NULL THEN 1 ELSE 0 END) AS new_deaths_per_million_nulls,
    SUM(CASE WHEN new_deaths_smoothed_per_million IS NULL THEN 1 ELSE 0 END) AS new_deaths_smoothed_per_million_nulls,
    SUM(CASE WHEN stringency_index IS NULL THEN 1 ELSE 0 END) AS stringency_index_nulls,
    SUM(CASE WHEN population IS NULL THEN 1 ELSE 0 END) AS population_nulls,
    SUM(CASE WHEN population_density IS NULL THEN 1 ELSE 0 END) AS population_density_nulls,
    SUM(CASE WHEN median_age IS NULL THEN 1 ELSE 0 END) AS median_age_nulls,
    SUM(CASE WHEN aged_65_older IS NULL THEN 1 ELSE 0 END) AS aged_65_older_nulls,
    SUM(CASE WHEN aged_70_older IS NULL THEN 1 ELSE 0 END) AS aged_70_older_nulls,
    SUM(CASE WHEN gdp_per_capita IS NULL THEN 1 ELSE 0 END) AS gdp_per_capita_nulls,
    SUM(CASE WHEN extreme_poverty IS NULL THEN 1 ELSE 0 END) AS extreme_poverty_nulls,
    SUM(CASE WHEN cardiovasc_death_rate IS NULL THEN 1 ELSE 0 END) AS cardiovasc_death_rate_nulls,
    SUM(CASE WHEN diabetes_prevalence IS NULL THEN 1 ELSE 0 END) AS diabetes_prevalence_nulls,
    SUM(CASE WHEN female_smokers IS NULL THEN 1 ELSE 0 END) AS female_smokers_nulls,
    SUM(CASE WHEN male_smokers IS NULL THEN 1 ELSE 0 END) AS male_smokers_nulls,
    SUM(CASE WHEN handwashing_facilities IS NULL THEN 1 ELSE 0 END) AS handwashing_facilities_nulls,
    SUM(CASE WHEN hospital_beds_per_thousand IS NULL THEN 1 ELSE 0 END) AS hospital_beds_per_thousand_nulls,
    SUM(CASE WHEN life_expectancy IS NULL THEN 1 ELSE 0 END) AS life_expectancy_nulls,
    SUM(CASE WHEN human_development_index IS NULL THEN 1 ELSE 0 END) AS human_development_index_nulls
FROM covid19

DELETE FROM covid19
WHERE 
    iso_code IS NULL OR
    continent IS NULL OR
    location IS NULL OR
    date IS NULL OR
    total_cases IS NULL OR
    new_cases IS NULL OR
    new_cases_smoothed IS NULL OR
    total_deaths IS NULL OR
    new_deaths IS NULL OR
    new_deaths_smoothed IS NULL OR
    total_cases_per_million IS NULL OR
    new_cases_per_million IS NULL OR
    new_cases_smoothed_per_million IS NULL OR
    total_deaths_per_million IS NULL OR
    new_deaths_per_million IS NULL OR
    new_deaths_smoothed_per_million IS NULL OR
    stringency_index IS NULL OR
    population IS NULL OR
    population_density IS NULL OR
    median_age IS NULL OR
    aged_65_older IS NULL OR
    aged_70_older IS NULL OR
    gdp_per_capita IS NULL OR
    extreme_poverty IS NULL OR
    cardiovasc_death_rate IS NULL OR
    diabetes_prevalence IS NULL OR
    female_smokers IS NULL OR
    male_smokers IS NULL OR
    handwashing_facilities IS NULL OR
    hospital_beds_per_thousand IS NULL OR
    life_expectancy IS NULL OR
    human_development_index IS NULL

--data analysis

--Q1.Find the top 10 countries with the highest total cases:

select top 10 location as Country,sum(total_cases) as Total_cases 
from covid19 
group by location order by total_cases desc

--Q2.Find the top 5 countries with the highest death rate:

select top 5 location as Country,sum(total_deaths) as Total_Deaths from covid19
group by location order by total_deaths desc

--Q3.Show daily new cases in India during 2020:

select location,sum(new_cases) as New_Cases from covid19 
where location='india' and year(date)=2020
group by location

--Q4.Top 5 countries with the highest average daily new cases:

SELECT TOP 5 location AS Country,AVG(new_cases) AS AvgDailyNewCases
FROM covid19
GROUP BY location
ORDER BY AvgDailyNewCases DESC

--Q5.Total deaths vs total cases per country:

SELECT location AS Country,
MAX(total_cases) AS TotalCases,
MAX(total_deaths) AS TotalDeaths
FROM covid19
GROUP BY location
ORDER BY TotalCases DESC

--Q6.Countries with the fastest decrease in daily new cases:

SELECT location AS Country,
MAX(new_cases) - MIN(new_cases) AS DecreaseInCases
FROM covid19
GROUP BY location
ORDER BY DecreaseInCases DESC

--Q7.Deaths vs. prevalence of diabetes / cardiovascular disease:

SELECT location, diabetes_prevalence, cardiovasc_death_rate,
SUM(total_deaths_per_million) AS deaths_per_million
FROM covid19
GROUP BY location, diabetes_prevalence, cardiovasc_death_rate
ORDER BY deaths_per_million DESC

--Q8.Show total COVID-19 cases per million for each country along with its GDP per capita:

SELECT location, gdp_per_capita, SUM(total_cases_per_million) AS cases_per_million
FROM covid19
GROUP BY location, gdp_per_capita
ORDER BY cases_per_million DESC

--Q9.Find total deaths per million for countries with median age above 40:

SELECT location, SUM(total_deaths_per_million) AS total_deaths_per_million
FROM covid19
WHERE median_age > 40
GROUP BY location
ORDER BY total_deaths_per_million DESC

--Q10.Find the month with the highest cases in 2020 for each country:

SELECT location, YEAR(date) AS year,
SUM(new_cases) AS total_new_cases
FROM covid19
WHERE YEAR(date) IN (2020, 2021)
GROUP BY location, YEAR(date)
ORDER BY location, year, total_new_cases DESC