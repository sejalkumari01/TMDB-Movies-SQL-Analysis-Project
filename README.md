# 🎬 TMDB Movies SQL Analysis Project

This project analyzes a **movies dataset (TMDB)** using SQL.  
It demonstrates **data cleaning, aggregation, JSON parsing, and advanced SQL queries** — all wrapped into reusable SQL views.  

---

## 📂 Features

- **Database setup**
  - Created `movies` database
  - Cleaned `release_date` column and fixed data types

- **Analysis via SQL Views**
  - 🎞️ Movies per year & per decade
  - ⭐ Top rated movies, most popular movies
  - 🎭 Movie counts & average revenue per genre (using `JSON_TABLE`)
  - 💰 Correlation of budget vs revenue, ROI, most profitable movies
  - 🏆 Top 5 genres per year based on revenue (using `RANK()`)
  - 🔎 Highly rated but low revenue movies
  - ⚖️ Underrated vs overrated movies (vote average vs vote count)
  - 📊 Ranking movies by popularity within each genre

---

## 🛠️ SQL Concepts Covered
- Database & table creation
- Data cleaning with `STR_TO_DATE` & type modification
- Aggregate functions (`COUNT`, `AVG`, `SUM`)
- `GROUP BY`, `HAVING`, `ORDER BY`
- Window functions (`RANK()`, `ROW_NUMBER()`)
- Common Table Expressions (CTEs)
- JSON handling with `JSON_TABLE`
- Views for modular analysis

---

## 🚀 Use Cases
This project can be used to:
- Practice **advanced SQL queries**
- Showcase **SQL data analysis** skills in a portfolio
- Explore **movie industry trends** with real-world styled data

