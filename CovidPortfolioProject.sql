--select *
--from PortfolioProject..CovidDeaths
--order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--shows likelihood of dying if you contact covid in your country
--select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentages
--from PortfolioProject..CovidDeaths
--where location like '%states'
--order by 1,2 

--people got covid
--select location, date, population, new_cases, total_deaths, total_cases, (total_cases/population)*100 as PeoplegotCovid
--from PortfolioProject..CovidDeaths
--where location like 'Canada'
--order by 1,2 desc

--country with highest infected rate compared to population
--select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as infected_rate
--from PortfolioProject..CovidDeaths
--group by location, population 
--order by infected_rate desc

--showing countries with highest deat count per population
--select location, max(cast(total_deaths as int)) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where location like 'Nepal' and continent is not null
--group by location
--order by TotalDeathCount desc

--by continent
--select continent, max(cast(total_deaths as int)) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by continent
--order by TotalDeathCount desc

--select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by date
--order by total_deaths desc

--select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
--,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

----use CTE
--with PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
--as
--(
--select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
--,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--)
--select *,(RollingPeopleVaccinated/population)*100
--from PopVsVac

--use temporary table

--drop table if exists #PercentPopVaccinated
--create table #PercentPopVaccinated
--(
--continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population numeric,
--New_Vaccinated numeric,
--RollingPeopleVaccinated numeric
--)
--insert into #PercentPopVaccinated
--select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
--,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
----order by 2,3
--select *,(RollingPeopleVaccinated/population)*100 as percentpopVacc
--from #PercentPopVaccinated

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

