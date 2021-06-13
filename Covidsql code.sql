USE PortfolioProject;

Select * from CovidDeaths
Order by 3,4;


Select * from CovidVaccinations
Order by 3,4;



Select Location, date, total_cases, new_cases, total_deaths, population 
from CovidDeaths
Order by 1,2;



-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract COVID-19 in the UK. As of 6th June 2021 there is a 2.83% chance.

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
Where location = 'United Kingdom' 
Order by 2;




-- Looking at Total Cases vs Population
-- Shows what percentage of Uk population has contracted COVID-19. As of 6th June 2021, 6.68% of UK population had contracted the virus.

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths
Where location = 'United Kingdom'
Order by 2;


-- Looking at Countries with Highest Infection Rate compared to Population. As of 6th June 2021, Andorra is the highest at 17.8%. 

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
where continent is not null
Group by location, population
Order by PercentPopulationInfected DESC;


-- Showing Countries with Highest Death Count per Population. Data shows USA has the highest Death Toll
-- Note: Use of CAST function to convert "total_deaths" datatype from nvarachar(255) to integers

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by location
Order by TotalDeathCount DESC;


-- CONTINENTAL ANALYSIS

-- Showing continents with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount DESC;






-- Looking at Total Population vs Vaccinations
-- This query shows the rolling number of people vaccinated for each country.

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER 
(Partition by dea.location  Order by dea.location, dea.date ) as RollingPeopleVaccinated
from CovidDeaths dea
Join CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3;



-- Loooking at percentage of Countries population that are vaccinated as of 6th June 2021.


Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER 
(Partition by dea.location  Order by dea.location, dea.date ) as RollingPeopleVaccinated
from CovidDeaths dea
Join CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated from #PercentPopulationVaccinated;




-- Creating View to store data for future visualisations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER 
(Partition by dea.location  Order by dea.location, dea.date ) as RollingPeopleVaccinated
from CovidDeaths dea
Join CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null;





















