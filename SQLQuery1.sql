--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                                                     
																	 --Queries for Covid-19 Analysis in Power BI--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Simple queries for productivity--
SELECT * FROM Covidproject..['Covid_Deaths (Project)$']
where continent is not null

select * from Covidproject..['Covid_Vaccinations (Project)$']
where continent is not null

Select Location, date, total_cases, total_deaths
from Covidproject..['Covid_Deaths (Project)$']
order by 1,2

		                                                            -- {Looking at Total Cases vs Total Deaths} --

-- Likelihood of dying from covid (Time Series)
Select Location, date, total_cases, total_deaths, (cast(total_deaths as numeric))/(cast(total_cases as numeric))*100 as DeathPercentage
from Covidproject..['Covid_Deaths (Project)$']
--where location like '%states%'
order by 1,2


--Total Cases vs Population (Time Series)
Select Location, date, population, total_cases, (cast(total_deaths as numeric))/(cast(population as numeric))*100 as DeathPercentage
from Covidproject..['Covid_Deaths (Project)$']
--where location like '%states%'
order by 1,2


--Countries with Highest Infection Rate compared to Population
Select Location, date, population, max(total_cases) as Count_HighestInfection, max((cast(total_deaths as numeric))/(cast(population as numeric)))*100 as Percent_PopulationInfected
from Covidproject..['Covid_Deaths (Project)$']
--where location like '%states%'
group by location, population
order by Percent_PopulationInfected desc


--Countries with Highest Death Count per Population
Select location, date, max(cast(total_deaths as numeric)) as TotalDeathCount
from Covidproject..['Covid_Deaths (Project)$']
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc


--Contintents with the hightest death count per population
Select continent, max(cast(total_deaths as numeric)) as TotalDeathCount
from Covidproject..['Covid_Deaths (Project)$']
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Numbers
select Sum(new_cases) as Total_Cases, Sum(cast(new_deaths as numeric)) as Total_Deaths, Sum(cast(new_deaths as numeric))/Sum(new_cases) *100 as DeathPercentage
from Covidproject..['Covid_Deaths (Project)$']
--where location like '%states%'
where continent is not null
--group by date
order by 1,2


--Total Population vs Vaccinations (Time Series) Table Join
select d.continent, d.location, d.date, d.population, v.new_vaccinations
	, sum(cast(v.new_vaccinations as numeric)) 
	over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from Covidproject..['Covid_Deaths (Project)$'] d
join ['Covid_Vaccinations (Project)$'] v
	on d.location = v.location
	and d.date = v.date
	where d.continent is not null
	order by 2,3


