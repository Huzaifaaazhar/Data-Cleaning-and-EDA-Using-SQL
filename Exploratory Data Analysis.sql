-- EXPLORATORY DATA ANALYSIS----------------------------------------------------------------------------------------------------
SELECT * FROM cleaned_layoff2;

-- MAX LAIDOFF
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM cleaned_layoff2;

-- FULL DESOLVE OF A COMPANY
SELECT *
FROM cleaned_layoff2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


-- TOTAL EMPLOYEES LAIDOFF OF A COMPANY
SELECT company, SUM(total_laid_off)
FROM cleaned_layoff2
GROUP BY company
ORDER BY 2 DESC;


-- DATE RANGE OF LAYING OFF
SELECT MIN(`date`), MAX(`date`)
FROM cleaned_layoff2;

-- TOTAL EMPLOYEES LAIDOFF IN A INDUSTRY
SELECT industry, SUM(total_laid_off)
FROM cleaned_layoff2
GROUP BY industry
ORDER BY 2 DESC;


-- TOTAL EMPLOYEES LAIDOFF BY COUNTRY
SELECT country, SUM(total_laid_off)
FROM cleaned_layoff2
GROUP BY country
ORDER BY 2 DESC;

-- TOTAL EMPLOYEES LAIDOFF BY YEAR
SELECT YEAR(`date`), SUM(total_laid_off)
FROM cleaned_layoff2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- ROLLING SUM (PROGRATION)
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM cleaned_layoff2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total
FROM cleaned_layoff2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total, SUM(total) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;



SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM cleaned_layoff2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- RAANKING IN WHICH YEAR THE COMPANY LAID OFF MOST OF THE EMPLOYEES
WITH company_year (company, years, total_laid_off) AS(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM cleaned_layoff2
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE years IS NOT NULL
ORDER BY Ranking
)
SELECT *
FROM company_year_rank
WHERE Ranking <= 5;




























































































































































































































