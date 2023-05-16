/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

--Select * from [dbo].CovidDeaths;

--SELECT location, continent, iso_code, date, population 
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1, 4;

SELECT location, continent, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 3;


--Looking at total cases vs total death
SELECT location, date, total_cases, total_deaths, 
ROUND((CAST (total_deaths AS float)/CAST (total_cases AS float))*100, 4) AS DeathRate 
FROM PortfolioProject..CovidDeaths
--WHERE location = 'India'
ORDER BY 1,2;


--Shows what % of population got infected by covid
SELECT location, date, total_cases, population,
(CAST(total_cases AS int)/population) AS PopulationInfected 
FROM PortfolioProject..CovidDeaths
--WHERE location = 'India'
ORDER BY 1,2;


--Showing countries with Highest Infection Rate compared to Population
SELECT location, MAX(CAST (total_cases AS INT)) AS InfectedPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 desc

--Showing countries with Highest Death Count
SELECT location, MAX(CAST (total_deaths AS INT)) AS DesceasedPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 desc


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT * FROM PortfolioProject..Covid_Vaccination
order by location, date


--Using CTE to perform Calculation on Partition By
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..Covid_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (PeopleVaccinated/Population)*100 AS PercentagePeopleVaccinated
From PopvsVac
--WHERE Location= 'India'


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..Covid_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (PeopleVaccinated/Population)*100 AS PercentagePeopleVaccinated
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

--DROP VIEW IF EXISTS PercentPopulationVaccinated

CREATE VIEW PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..Covid_Vaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
