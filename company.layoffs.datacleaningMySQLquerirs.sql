select *
From layoffs;

Create table layoffs1 -- Creating a duplicate table so raw data can be intact
like layoffs;

select *
From layoffs1;

Insert layoffs1
select *
From layoffs; 

Describe layoffs1;

-- Identifying & Deleting duplicates

Select company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, Count(*) as dup
From layoffs1
Group by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
Having dup > 1
;

With CTE_duplicate As
(
  Select *,
		Row_Number () Over (partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as dup
  From layoffs1
) Select *
From CTE_duplicate
Where dup > 1;

With CTE_duplicate As
(
  Select *,
         Row_Number() Over (Partition By company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions Order By company) As dup
  From layoffs1
)
Delete From layoffs1
Where (company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) In
(
  Select company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
  From CTE_duplicate
  Where dup > 1
);
-- Another way to remove duplicates when there is no unique identifier 

CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `dup` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Insert Into layoffs2
  Select *,
		Row_Number () Over (partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as dup
  From layoffs1
;

Delete
From layoffs2
Where dup > 1
;

Select *
From layoffs2
Where dup > 1
;

-- Standerizing the data
Select *
From layoffs2
;

Select company, Trim(company)
From layoffs2;

Update layoffs2
Set company = Trim(company)
;

Update layoffs2
Set location = Trim(location)
;

Select Distinct(country)
From layoffs2
order by 1
;

Update layoffs2
Set country = 'United States'
Where country Like 'United States%'
;

Select Distinct(industry)
From layoffs2
order by 1
;

Update layoffs2
Set industry = 'Crypto'
Where industry like 'Crypto%'
;

Select `date`, str_to_date(`date`, '%m/%d/%Y')
From layoffs2 
;

Update layoffs2
Set `date` = str_to_date(`date`, '%m/%d/%Y')
;

Alter table layoffs2
Modify column `date` date
;

Select *
From layoffs2 
Order by `date` desc 
limit 1
;

Select * -- This is useless to us, so we goinna remove thoese rows.
From layoffs2 
Where  percentage_laid_off is Null And total_laid_off is Null
;

Delete 
From layoffs2
Where (percentage_laid_off is Null or percentage_laid_off = '') And (total_laid_off is Null or total_laid_off = '')
;

Select *
From layoffs2
Where (company is Null Or company = '') And (industry is Null or industry = '')
;

Delete
From layoffs2
Where (company is Null Or company = '') And (industry is Null or industry = '')
;

Alter Table layoffs2 -- Drop the column which is not necessary 
Drop Column dup;

Select *
From layoffs2




























