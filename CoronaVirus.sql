select*
from PortfolioProjectCovid.dbo.RCovidVac
where continent is not null
order by continent, location

select*
from PortfolioProjectCovid.dbo.RCovidDeaths
where continent is not null
order by continent, location

select*
from PortfolioProjectCovid.dbo.RCovidDeaths
where continent is null
order by continent, location

--Deeath Perentage in Africa

Select continent, location, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float)) * 100 as deathPercentage
From PortfolioProjectCovid.dbo.RCovidDeaths
where continent is not null and continent = 'Africa'
Group by continent, location, total_cases, total_deaths
Order by continent, location

-- Death perentage in Nigeria
Select location, date, total_deaths, total_cases, (cast(total_deaths as float)/cast(total_cases as float)) * 100 as death_rate
From PortfolioProjectCovid.dbo.RCovidDeaths
where location = 'Nigeria'
Group by location, date, total_cases, total_deaths
Order by location

--percentage of population contracting covid in Nigeria
Select location, date, total_cases, population, (cast(total_cases as float)/cast (population as float)) * 100 as infection_rate
From PortfolioProjectCovid.dbo.RCovidDeaths
where location = 'Nigeria'
Group by location, date, total_cases, population
Order by location

--countries with the highest infection rate
select distinct location, max(total_cases) as MaxTotalCasesPERCountry, population, max(cast(total_cases as float)/cast(population as float))* 100 as infectionRate
From PortfolioProjectCovid.dbo.RCovidDeaths
Where continent is not null 
Group by location, population
Order by infectionRate desc

--highest infectionrate recorded in nigeria
select distinct location, max(total_cases) as MaxTotalCasesPERCountry, population, max(cast(total_cases as float)/cast(population as float))* 100 as infectionRate
From PortfolioProjectCovid.dbo.RCovidDeaths
Where continent is not null and location = 'Nigeria' 
Group by location, population
Order by infectionRate 

--just to compare the population sum in africa to the population of individual countries in afrtca
-- i used subqueries
select distinct location, population, (select sum(distinct population) From PortfolioProjectCovid.dbo.RCovidDeaths
Where continent = 'Africa') as TotalAfricanPopulation
From PortfolioProjectCovid.dbo.RCovidDeaths
Where continent = 'Africa'
Group by location, population
Order by location

select sum(distinct population)
From PortfolioProjectCovid.dbo.RCovidDeaths
Where continent = 'Africa'

--people fully vaccinated
select people_vaccinated, people_fully_vaccinated, people_fully_vaccinated_per_hundred, people_vaccinated_per_hundred
from PortfolioProjectCovid.dbo.RCovidVac
where people_vaccinated is not null
group by people_vaccinated, people_fully_vaccinated, people_fully_vaccinated_per_hundred, people_vaccinated_per_hundred
order by 1

select distinct location, max(people_vaccinated), max(people_fully_vaccinated), max(people_fully_vaccinated_per_hundred), max(people_vaccinated_per_hundred)
from PortfolioProjectCovid.dbo.RCovidVac
where continent is not null and people_vaccinated is not null and people_fully_vaccinated is not null and people_fully_vaccinated_per_hundred is not null
group by location, people_vaccinated, people_fully_vaccinated, people_fully_vaccinated_per_hundred, people_vaccinated_per_hundred
order by 1

select distinct max(people_vaccinated), max(people_fully_vaccinated), max(people_fully_vaccinated_per_hundred), max(people_vaccinated_per_hundred)
from PortfolioProjectCovid.dbo.RCovidVac
where continent is not null and people_vaccinated is not null and people_fully_vaccinated is not null and people_fully_vaccinated_per_hundred is not null
group by people_vaccinated, people_fully_vaccinated, people_fully_vaccinated_per_hundred, people_vaccinated_per_hundred
order by 1

-- Countries where vaccination tests were carried out
select distinct location, tests_units, max(tests_per_case) as MaxTestPerCase
from PortfolioProjectCovid.dbo.RCovidVac
where continent is not null and tests_units = 'samples tested'
group by location, tests_units
order by 1

select distinct tests_units
from PortfolioProjectCovid.dbo.RCovidVac
where continent is not null and tests_units is not null

select*
from PortfolioProjectCovid.dbo.RCovidDeaths
where continent is not null
order by continent, location

select*
from PortfolioProjectCovid.dbo.RCovidVac
where continent is not null
order by continent, location

-- Joining both tables to find valuable insights that can be derived from the table
select dea.continent, dea.location, dea.date, dea.population, dea.total_cases, dea.new_cases, dea.total_deaths, dea.new_deaths,
vac.total_tests,vac.new_tests,vac.tests_units,vac.total_vaccinations,vac.new_vaccinations,vac.people_fully_vaccinated
from PortfolioProjectCovid.dbo.RCovidDeaths dea
join PortfolioProjectCovid.dbo.RCovidVac vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- finding the sum of all cases, death, tests and vaccinations in each country 
select dea.continent, dea.location, dea.date, dea.population, dea.new_cases,
sum(cast(dea.new_cases as int)) over(partition by dea.location order by dea.location, dea.date) as NewCasesSummation, 
dea.new_deaths, sum(cast(dea.new_deaths as int)) over(partition by dea.location order by dea.location, dea.date) as NewDeathsSummation,
vac.new_tests, sum(cast(vac.new_tests as int)) over(partition by dea.location order by dea.location, dea.date) as NewTestsSummation,
vac.tests_units,vac.total_vaccinations,vac.people_fully_vaccinated
from PortfolioProjectCovid.dbo.RCovidDeaths dea
join PortfolioProjectCovid.dbo.RCovidVac vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


select dea.continent, dea.location, dea.date, dea.population, dea.new_cases,
sum(cast(dea.new_cases as int)) over(partition by dea.location order by dea.date) as NewCasesSummation, 
dea.new_deaths, sum(cast(dea.new_deaths as int)) over(partition by dea.location order by dea.date)  as NewDeathsSummation,
vac.new_tests, sum(cast(vac.new_tests as int)) over(partition by dea.location order by dea.date) as NewTestsSummation,
vac.tests_units,vac.total_vaccinations,vac.people_fully_vaccinated
from PortfolioProjectCovid.dbo.RCovidDeaths dea
join PortfolioProjectCovid.dbo.RCovidVac vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population, dea.new_deaths,vac.new_tests,
dea.new_cases,vac.tests_units,vac.total_vaccinations,vac.people_fully_vaccinated
--order by 2,3

--Extracting data For Nigeria alone  from the table above for infection rate, death rate and percentage of population fully vaccinated
With DeaAndVac as
(
select dea.continent, dea.location, dea.date, dea.population, dea.new_cases,
sum(cast(dea.new_cases as int)) over(partition by dea.location order by dea.date) as NewCasesSummation, 
dea.new_deaths, sum(cast(dea.new_deaths as int)) over(partition by dea.location order by dea.date)  as NewDeathsSummation,
vac.new_tests, sum(cast(vac.new_tests as int)) over(partition by dea.location order by dea.date) as NewTestsSummation,
vac.tests_units,vac.total_vaccinations,vac.people_fully_vaccinated
from PortfolioProjectCovid.dbo.RCovidDeaths dea
join PortfolioProjectCovid.dbo.RCovidVac vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population, dea.new_deaths, dea.new_cases,vac.new_tests,
vac.tests_units,vac.total_vaccinations,vac.people_fully_vaccinated
--order by 2,3
)
select location, population, max(cast(NewCasesSummation as float))/population * 100 as InfectionRate,
max(cast(NewDeathsSummation as float))/ population * 100 as DeathRate, max(cast(people_fully_vaccinated as float))/ population * 100 as percentPopulationFullyVaccinated
from DeaAndVac
where location = 'Nigeria'
group by location, population
