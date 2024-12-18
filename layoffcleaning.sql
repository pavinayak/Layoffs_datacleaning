-- Data Cleaning

Select * from layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any Columns and rows


-- creating and  copying from one table to another table
Create  table layoffs_staging
Like layoffs; 

Select * from layoffs_staging;

-- Copying all the columns data into another table
Insert layoffs_staging
Select * from layoffs;

-- Adding row numbers 

With duplicate_cte As
(
Select *,
Row_Number() Over(
Partition by company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) As row_num
from layoffs_staging
)
Select * from duplicate_cte where row_num > 1;

Select * from layoffs_staging where company = 'Casper';


With duplicate_cte As
(
Select *,
Row_Number() Over(
Partition by company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) As row_num
from layoffs_staging
)
Delete from duplicate_cte where row_num > 1;

Select * from layoffs_staging;

-- Standardizing data
Select company, TRIM(company)
from layoffs_staging;

Update layoffs_staging
set company = TRIM(company);

Select * 
from layoffs_staging
where industry like 'Crypto%';

Update layoffs_staging
set industry = 'Crypto'
where industry like 'Crypto%';

Select distinct industry from layoffs_staging ;


Select distinct location from layoffs_staging order by 1;

Select distinct country from layoffs_staging order by 1;

Select *
from layoffs_staging 
where country like 'United States%'
order by 1;


Select distinct country, trim(trailing '.' from country)
from layoffs_staging 
order by 1;

update layoffs_staging 
set country = trim(trailing '.' from country)
where country like 'United States%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging;


update layoffs_staging
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging
modify column `date` date;

select * 
from layoffs_staging 
where total_laid_off is null 
AND percentage_laid_off is null;

select *
from layoffs_staging
where industry is null
or industry = ''; 


select * from layoffs_staging where company = 'Airbnb';

select t1.industry, t2.industry 
from layoffs_staging t1
join layoffs_staging t2
on t1.company = t2.company
and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;


update layoffs_staging t1 
join layoffs_staging t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;


update layoffs_staging 
set industry = null
where industry = '';

















