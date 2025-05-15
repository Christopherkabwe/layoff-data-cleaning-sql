## 🧹 Layoffs Data Cleaning Project (SQL Server)

This project focuses on cleaning and preparing a dataset of tech company layoffs using T-SQL in SQL Server.  
The original data contains inconsistencies, duplicates, and formatting issues that are cleaned step-by-step using SQL queries.

---

## 🛠️ Tools Used

- Microsoft SQL Server  
- SQL Server Management Studio (SSMS)  
- T-SQL (Transact-SQL)

---

## 📁 Dataset

The dataset includes tech industry layoffs with attributes like:

- Company  
- Location  
- Industry  
- Total Laid Off  
- Percentage Laid Off  
- Date  
- Stage  
- Country  
- Funds Raised  

---

## 🧽 Cleaning Steps

1. **Create Staging Tables**: Create a working copy of the data for transformation.  
2. **Identify & Remove Duplicates**: Use `ROW_NUMBER()` to find and delete exact duplicate records.  
3. **Trim Whitespaces**: Clean leading/trailing spaces from company names.  
4. **Standardize Values**:  
   - Group variations like `"CryptoX"` into `"Crypto"`  
   - Normalize `"United States."` to `"United States"`  
5. **Handle NULLs**: Remove rows where both `total_laid_off` and `percentage_laid_off` are NULL.  
6. **Date Cleaning (Optional)**: Convert non-standard date formats using `TRY_CONVERT()`.  

---

## 🧾 Before vs After (Example)

| Issue             | Before                      | After                   |
|-------------------|-----------------------------|-------------------------|
| Duplicate Rows    | Present                     | Removed using CTE       |
| Company Names     | `' Google '` (extra spaces) | `Google`                |
| Country Format    | `United States.`            | `United States`         |
| Industry Labels   | `CryptoX`                   | `Crypto`                |
| Null Records      | Blank rows                  | Cleaned out             |

---

## 🎯 Key Learning Outcomes

- Writing clean, modular T-SQL scripts  
- Using CTEs and window functions like `ROW_NUMBER()`  
- Handling real-world messy datasets  
- Applying data transformation best practices in SQL Server  

---

## ▶️ How to Run This Project

1. Clone this repository  
2. Open `cleaning_script.sql` in SQL Server Management Studio (SSMS)  
3. Run the script step by step on your `layoffs` table  

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

