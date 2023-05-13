--Select * from [dbo].CovidDeaths;

--SELECT location, continent, iso_code, date, population 
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1, 4;

SELECT location, continent, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 3;


--Looking at total cases vs total death
SELECT location, continent, date, total_cases, total_deaths, 
(CAST (total_deaths AS float)/CAST (total_cases AS float))*100 AS DeathRate 
FROM PortfolioProject..CovidDeaths
WHERE location = 'India'
ORDER BY 3;

--Looking at total case vs total population
--Shows what % of population got covid
SELECT location, continent, date, total_cases, population,
(CAST(total_cases AS int)/population) AS PopulationInfected 
FROM PortfolioProject..CovidDeaths
--WHERE location = 'India'
ORDER BY 1,3;


--Showing countries with Highest Infection Rate compared to Population
SELECT location, MAX(CAST (total_cases AS INT)) AS InfectedPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 desc

--Showing countries with Highest Death Count per Population
SELECT location, MAX(CAST (total_deaths AS INT)) AS DesceasedPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 desc