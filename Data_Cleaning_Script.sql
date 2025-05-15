USE Datasets;
GO

-- Step 1: Review raw data
SELECT * FROM layoffs;

-- Step 2: Create first staging table (structure + data)
IF OBJECT_ID('dbo.layoffs_staging', 'U') IS NOT NULL
    DROP TABLE dbo.layoffs_staging;
SELECT *
INTO layoffs_staging
FROM layoffs;
GO

-- Step 3: View staging data
SELECT * FROM layoffs_staging;

-- Step 4: Add row numbers to identify duplicates
WITH cte_rownum AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [date], stage, country, funds_raised_millions
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM layoffs_staging
)
SELECT * FROM cte_rownum
WHERE row_num > 1;

-- Step 5: View specific company for inspection
SELECT * FROM layoffs_staging
WHERE company = 'Hibob';

-- Step 6: Create cleaned staging table manually
IF OBJECT_ID('dbo.layoffs_staging2', 'U') IS NOT NULL
    DROP TABLE dbo.layoffs_staging2;


CREATE TABLE layoffs_staging2 (
    company NVARCHAR(255),
    location NVARCHAR(255),
    industry NVARCHAR(255),
    total_laid_off INT NULL,
    percentage_laid_off NVARCHAR(50),
    [date] NVARCHAR(50),
    stage NVARCHAR(255),
    country NVARCHAR(255),
    funds_raised_millions INT NULL,
    row_num INT
);
GO
-- Step 7: Populate staging2 with row numbers
WITH cte_insert AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [date], stage, country, funds_raised_millions
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM layoffs_staging
)
INSERT INTO layoffs_staging2 (
    company, location, industry, total_laid_off, percentage_laid_off, [date],
    stage, country, funds_raised_millions, row_num
)
SELECT
    company, location, industry, total_laid_off, percentage_laid_off, [date],
    stage, country, funds_raised_millions, row_num
FROM cte_insert;

-- Step 8: Delete duplicates
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- Step 9: Trim and clean company names
UPDATE layoffs_staging2
SET company = LTRIM(RTRIM(company));

-- Step 10: Standardize industry names
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Step 11: Clean country names
UPDATE layoffs_staging2
SET country = REPLACE(RTRIM(country), '.', '')
WHERE country LIKE 'United States%';

-- Step 12: Optional depending on the data type
-- Convert date if imported in different format
-- ALTER TABLE layoffs_staging2
-- ADD date_converted DATE;
GO

-- UPDATE layoffs_staging2
-- SET date_converted = TRY_CONVERT(DATE, [date], 101);  -- mm/dd/yyyy

-- Optional: drop or rename old column if date conversion worked
-- ALTER TABLE layoffs_staging2 DROP COLUMN date_raw;
-- EXEC sp_rename 'layoffs_staging2.date_converted', 'date', 'COLUMN';

-- Step 13: Remove rows with both layoffs and percentages missing
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Final clean table preview
SELECT * FROM layoffs_staging2;
