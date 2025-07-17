# 📊 Netflix SQL Analysis Project

This project explores the Netflix content dataset using advanced SQL queries. The goal is to derive meaningful insights from the data such as genre distribution, content type ratio, actor popularity, country-wise content production, and more.

---

## 🔍 Objectives

- Understand the composition of Netflix’s content catalog
- Explore viewer content preferences
- Analyze release patterns and trends
- Identify top-performing genres, countries, and actors
- Practice recursive CTEs, window functions, and string manipulation in SQL

---

## 📁 Files

- `netflix_analysis.sql` — Full SQL code with 15+ business-focused queries
- `cleaned_netflix.csv` — (Optional) Cleaned version of the dataset
- `netflix_summary.md` — (Optional) Summary of key insights and visual recommendations

---

## 🧠 Techniques Used

- Recursive CTEs for splitting comma-separated values (`country`, `cast`, `genre`)
- Window functions: `ROW_NUMBER()`, `DENSE_RANK()`, `LAG()`
- String functions: `TRIM()`, `SUBSTRING_INDEX()`, `SUBSTRING()`
- Aggregations with `GROUP BY`, conditional `CASE WHEN`
- Date extraction and formatting with `STR_TO_DATE()` and `YEAR()`
- Keyword filtering using `LIKE` in content descriptions

---

## 📌 Key Insights

- Movies dominate the catalog (~70%).
- The US leads in content production, followed by India and the UK.
- Top 10 actors identified from US-based movies.
- 'Documentaries' and 'Dramas' are the most common genres.
- Content labeled with keywords like "kill" or "violence" was flagged for sentiment tagging.

---

## 🛠️ Tools

- **MySQL** (8.0)
- SQL Workbench or any preferred SQL editor
- Dataset source: [Netflix Kaggle Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows)

---

## 📈 Next Steps

- Convert results into visual dashboards using **Power BI** or **Tableau**
- Create a separate Python script or Jupyter Notebook to support exploratory analysis
- Add filtering options for genre, country, year in a BI tool

---

## 📣 Author

**Pardeep Walia**  
_Data Analyst | SQL Enthusiast | Data Storyteller_  
[LinkedIn Profile](https://www.linkedin.com/in/pardeep-walia/)  
