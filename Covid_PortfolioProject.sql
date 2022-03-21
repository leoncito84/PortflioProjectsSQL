
Select*
From PortfolioProject..CovidDeaths
order by 3,4

Select*
From PortfolioProject..CovidVaccinations
order by 3,4

Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

Looking at Total Cases vs Total Deaths
Shows likeihood of dying if you contract covid in your country

Select Location, date, total_cases, new_cases, total_deaths,(Total_deaths/total_cases)
From PortfolioProject..CovidDeaths
Where location like '%germany%' 
order by 1,2

Select Location, date, Population, total_cases, (total_cases/population)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Ukraine%'
order by 1,2


Looking at Countries with Highest Infection Rate compared to Population

Select Location, date, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Russian%'
order by 1,2


Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- Where location like '%Russian%'
Group by Location, Population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like '%Russian%'
Group by Location
order by TotalDeathCount desc

--Showing countries are world, not location "Casting"
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like '%Russian%'
Group by Location
order by TotalDeathCount desc

--Let's Break things down by continent

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing contintents with highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select /*date, */SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) /SUM(New_Cases)
as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%germany%'
where continent is not null
--Group By date
order by 1,2

Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..covidvaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3