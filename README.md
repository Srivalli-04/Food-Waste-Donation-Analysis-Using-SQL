# 🍃 Food Waste & Donation Analysis Using SQL

## 📌 Project Overview

Food waste is a major challenge for restaurants, grocery stores, food suppliers, and charitable organizations. Large quantities of food may go unused or expire while many people face food insecurity.

The **Food Waste & Donation Analysis** project uses SQL to explore food inventory, monitor expiry dates, analyze food quantities, and support better food donation and waste management decisions.

The goal is to turn raw food inventory data into meaningful insights that can help reduce food waste and improve food donation planning.

---

## 🎯 Business Problem

Food providers may struggle to track available food inventory, identify items approaching their expiry dates, and determine which food items should be prioritized for donation.

Without proper inventory monitoring and analysis, usable food may go to waste, donation opportunities may be missed, and resources may not be distributed efficiently.

This project uses SQL queries to analyze food inventory information and support data-driven decisions for reducing waste and improving food redistribution.

---

## 🎯 Project Objectives

* Analyze food inventory and available quantities.
* Identify food items approaching their expiry dates.
* Examine food categories and their inventory distribution.
* Track food received dates and expiry dates.
* Identify opportunities to prioritize food donations.
* Generate insights to support food waste reduction.
* Improve inventory monitoring through SQL-based analysis.

---

## 🗂️ Dataset Description

The project uses food inventory data containing information about food items, providers, quantities, categories, and dates.

### Key Columns

| Column Name     | Description                             |
| --------------- | --------------------------------------- |
| `food_id`       | Unique identifier for a food item       |
| `provider_id`   | Identifier of the food provider         |
| `food_name`     | Name of the food item                   |
| `category`      | Category to which the food item belongs |
| `quantity`      | Quantity of food available              |
| `unit`          | Unit used to measure the quantity       |
| `received_date` | Date the food item was received         |
| `expiry_date`   | Expiry date of the food item            |

*Note: Column descriptions are based on the food inventory table structure. Additional tables can be documented separately if they are included in your database.*

---

## 🛠️ Tools & Technologies

* **SQL** — Data querying and analysis
* **MySQL** — Database management
* **MySQL Workbench** — Writing and executing SQL queries
* **GitHub** — Project documentation and version control

---

## 🔍 SQL Concepts Used

This project can demonstrate the following SQL concepts, depending on the queries implemented:

* `SELECT` and `WHERE` for data retrieval and filtering
* `ORDER BY` for sorting inventory records
* Aggregate functions such as `SUM()`, `COUNT()`, and `AVG()`
* `GROUP BY` for category-wise analysis
* `HAVING` for filtering aggregated results
* Date functions for expiry-date analysis
* `CASE` statements for classifying food items
* Subqueries for advanced analysis
* Joins for combining related tables, where applicable

---

## 📊 Key Analysis Areas

### 1. Food Inventory Analysis

Examine available food items, quantities, and inventory distribution.

### 2. Category-Wise Analysis

Determine which food categories account for the largest share of recorded inventory.

### 3. Expiry Date Monitoring

Identify expired items and food items approaching their expiry dates.

### 4. Food Donation Opportunities

Use inventory and expiry information to help prioritize potentially suitable food items for donation.

### 5. Waste Reduction Opportunities

Explore how inventory monitoring and timely redistribution could help reduce avoidable food waste.

---

## 💡 Expected Business Benefits

* Better visibility into food inventory.
* Earlier identification of items approaching expiry.
* Improved prioritization of potential food donations.
* More informed inventory management decisions.
* Support for reducing avoidable food waste.
* Better use of available food resources.

*These are intended benefits of the analysis, not measured outcomes unless validated by the dataset.*

---

## 📈 Key Insights

The final insights should be added after executing and validating the SQL queries.

Examples of questions the analysis can answer include:

* Which food categories contain the highest quantities?
* Which items are approaching their expiry dates?
* How much inventory is recorded for each food category?
* Which food items may require immediate attention?
* How can inventory information support better donation planning?

---

## 🚀 Project Workflow

1. Create the database and food inventory table.
2. Import the dataset into MySQL.
3. Inspect the data structure and records.
4. Check data quality and date formats.
5. Write SQL queries to analyze inventory and expiry dates.
6. Interpret the query results.
7. Document key findings and recommendations.

---

## 🌱 Recommendations

* Monitor expiry dates regularly.
* Prioritize suitable food items that are approaching expiry for timely redistribution.
* Maintain accurate food inventory records.
* Review food categories and quantities to improve inventory planning.
* Record donation and disposal information when available.
* Use consistent monitoring procedures to identify opportunities to prevent avoidable waste.

**Important:** Food safety and donation eligibility must be checked before redistributing any food item.

---

## 🏁 Conclusion

The Food Waste & Donation Analysis project demonstrates how SQL can be used to examine food inventory data and identify opportunities for better inventory management, timely donation planning, and waste reduction.

By transforming raw records into actionable information, the project illustrates the role of data analysis in supporting more efficient food resource management.

---

## 👩‍💻 Author

**Srivalli Janani**

Data Science Graduate | Aspiring Data Analyst

🔗 [GitHub Profile](https://github.com/Srivalli-04)
🔗 [LinkedIn Profile](https://www.linkedin.com/in/srivallijanani/)

---

⭐ If you find this project interesting, feel free to explore my other data analytics projects!
