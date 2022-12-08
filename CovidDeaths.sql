select * 
from MyPortfolio..covidDeaths$
order by 3,4

select *
from MyPortfolio..CovidVaccinations$
order by 3,4

select *
from MyPortfolio..['WHO-COVID-19-global-table-data$']
order by 3,4

--select *
--from my_portfolio ..covidvaccinations
--select data that we are going to using

select location, date, total_cases, new_cases, total_deaths, population_density
from MyPortfolio..covidDeaths$
order by 1,2

-- Looking at the Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from MyPortfolio..covidDeaths$
order by 1,2


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercenteage
from MyPortfolio..covidDeaths$
where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid

select location, date, population_density, total_cases, ((total_cases)*100)/population_density as DeathPercenteage
from MyPortfolio..covidDeaths$
order by 1,2

select location, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from MyPortfolio..['WHO-COVID-19-global-table-data$']
where location like '%states%'
order by 1,2


--Looking at countries with Highest infection rate compared to population

select location, population_density, MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/total_cases))*100 as 
PercenteagePopulationInfected
from MyPortfolio..covidDeaths$
--where location like '%states%'
group by location, population_density
order by 1,2

--showing countries with the Highest Death Count per Population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from MyPortfolio..covidDeaths$
--where location like '%states%'
where total_deaths is not null and continent is not null
group by location
order by TotalDeathCount desc

--breaking down by continents

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from MyPortfolio..covidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- To show continent with the highest Death count count per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from MyPortfolio..covidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


--To see Global View

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int)) / SUM(New_Cases)*100 as DeathPercenteage
from MyPortfolio..covidDeaths$
--Where location like '%states%'
where continent is not null
--Group By date
order by 1,2


--Total Vaccinated compared to the Population

select *
from MyPortfolio..covidDeaths$ da
join MyPortfolio..CovidVaccinations$  
	on da.location = lc.location
	and da.date = lc.date


select da.continent, da.location, da.date, da.population_density, lc.new_vaccinations
from MyPortfolio..covidDeaths$ da
join MyPortfolio..CovidVaccinations$ lc
	on da.location = lc.location
	and da.date = lc.date
where da.continent is not null
order by 1,2,3


select da.continent, da.location, da.date, da.population_density, lc.new_vaccinations,
SUM(cast(lc.new_vaccinations as int)) over (partition by da.location Order by da.location)
from MyPortfolio..covidDeaths$ da
join MyPortfolio..CovidVaccinations$ lc
	on da.location = lc.location
	and da.date = lc.date
where da.continent is not null
order by 2,3


select da.continent, da.location, da.date, da.population_density, lc.new_vaccinations,
SUM(convert(int,lc.new_vaccinations)) OVER (partition by da.location Order by da.location, da.date) as RollingPeopleVaccinated
from MyPortfolio..covidDeaths$ da
join MyPortfolio..CovidVaccinations$ lc
	on da.location = lc.location
	and da.date = lc.date
where da.continent is not null
order by 2,3

--Use CTE

 with popvsvac (Continent, location, date, poulation_density, New_Vacciantions, RollingPeopleVaccinated)
 as
 (
select da.continent, da.location, da.date, da.population_density, lc.new_vaccinations,
SUM(convert(int,lc.new_vaccinations)) over (Partition by da.location Order by da.location, 
da.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population_density)*100
from MyPortfolio..covidDeaths$ da
join MyPortfolio..CovidVaccinations$ lc
	on da.location = lc.location
	and da.date = lc.date
where da.continent is not null
order by 2,3
)
select*,  (RollingPeopleVaccinated/poulation_density)*100
from popvsvac
 

--Temp Table

Drop Table if exists #PercentagePopulationVaccinated
create table #PercentagePopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccincted numeric
 )

Insert into #PercentagePopulationVaccinated
select da.continent, da.location, da.date, da.population_density, lc.new_vaccinations,
SUM(convert(int,lc.new_vaccinations)) over (Partition by da.location Order by da.location, 
da.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population_density)*100
from MyPortfolio..covidDeaths$ da
join MyPortfolio..CovidVaccinations$ lc
	on da.location = lc.location
	and da.date = lc.date
where da.continent is not null
--order by 2,3

select *
from #PercentagePopulationVaccinated



Create View PercentagePopulationVaccinated as 
select da.continent, da.location, da.date, da.population_density, lc.new_vaccinations,
SUM(convert(int,lc.new_vaccinations)) over (Partition by da.location Order by da.location, 
da.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population_density)*100
from MyPortfolio..covidDeaths$ da
join MyPortfolio..CovidVaccinations$ lc
	on da.location = lc.location
	and da.date = lc.date
where da.continent is not null
--order by 2,3
