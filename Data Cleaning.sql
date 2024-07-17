-- DATA CLEANING USING SQL---------------------------------------------------------------------------------

-- OVERVIEW OF THE TABLE---------------------------------------------------------------------------------
SELECT * FROM cleaned_layoff;

-- IDENTIFYING AND REMOVING DUPLICATES FROM THE TABLE---------------------------------------------------------------------------
SELECT *,
ROW_NUMBER() OVER(partition by company,
location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM cleaned_layoff;

WITH duplicates AS (SELECT *,
ROW_NUMBER() OVER(partition by company,
location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM cleaned_layoff
)
SELECT * FROM duplicates
WHERE row_num > 1;

SELECT *
FROM cleaned_layoff
WHERE company = 'Casper';

CREATE TABLE `cleaned_layoff2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM cleaned_layoff2;

INSERT INTO cleaned_layoff2
SELECT *,
ROW_NUMBER() OVER(partition by company,
location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM cleaned_layoff;

SELECT * FROM cleaned_layoff2
WHERE row_num > 1;

DELETE
FROM cleaned_layoff2
WHERE row_num > 1;

SELECT * FROM cleaned_layoff2;


-- STANDARDIZING THE DATA----------------------------------------------------------------------------------------------------------
SELECT company, TRIM(company)
FROM cleaned_layoff2;

UPDATE cleaned_layoff2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM cleaned_layoff2
ORDER BY 1;

SELECT *
FROM cleaned_layoff2
WHERE industry LIKE 'Crypto%';

UPDATE cleaned_layoff2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM cleaned_layoff2
ORDER BY 1;

SELECT DISTINCT country
FROM cleaned_layoff2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM cleaned_layoff2;

UPDATE cleaned_layoff2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM cleaned_layoff2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM cleaned_layoff2;

UPDATE cleaned_layoff2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE cleaned_layoff2
MODIFY COLUMN `date` DATE;

SELECT *
FROM cleaned_layoff2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


UPDATE cleaned_layoff2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM cleaned_layoff2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM cleaned_layoff2
WHERE company = 'Airbnb';


SELECT t1.company, t1.industry, t2.industry
FROM cleaned_layoff2 t1
JOIN cleaned_layoff2 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry is NOT NULL;


UPDATE cleaned_layoff2 t1
JOIN cleaned_layoff2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry is NOT NULL;

DELETE
FROM cleaned_layoff2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE cleaned_layoff2
DROP COLUMN row_num;

SELECT *
FROM cleaned_layoff2;


