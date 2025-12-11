# 🍽️ Swiggy Sales Analysis - SQL (ETL + Star Schema + KPI Insights)

An end-to-end SQL analytics project analyzing 197K+ Swiggy food delivery records to generate business insights on orders, revenue, cuisine performance, and location trends.

---

## 📌 Table of Contents

* <a href="#overview">Overview</a>
* <a href="#business-problem">Business Problem</a>
* <a href="#dataset">Dataset</a>
* <a href="#tools--technologies">Tools & Technologies</a>
* <a href="#data-cleaning--validation">Data Cleaning & Validation</a>
* <a href="#dimensional-modeling--star-schema">Dimensional Modeling (Star Schema)</a>
* <a href="#etl-workflow">ETL Workflow</a>
* <a href="#sql-kpis--analysis">SQL KPI's & Analysis</a>
* <a href="#key-insights">Key Insights</a>
* <a href="#conclusion">Conclusion</a>
* <a href="#author--contact">Author & Contact</a>

---

<h2><a id="overview"></a>Overview</h2>

This SQL project analyzes **197,431 Swiggy food delivery records** to uncover insights across orders, pricing, cuisines, restaurant demand, customer spending behavior, and regional performance.
The workflow includes complete **data cleaning**, **validation**, **dimensional modeling**, and **ETL pipeline creation** using SQL Server.
A full **Star Schema** was built (5 dimensions + 1 fact table), enabling advanced analytical queries and enterprise-grade reporting.

---

<h2><a id="business-problem"></a>Business Problem</h2>

Swiggy operates on high-volume order data across cities, categories, and restaurants.
This project answers key business questions, including:

* Which cities and states generate the highest order volume and revenue?
* What cuisines and dishes dominate customer preferences?
* Which restaurants perform best in terms of demand and ratings?
* How do orders trend across days, months, and quarters?
* What spending ranges do customers most frequently fall into?
* How does rating behavior vary across categories and dishes?

---

<h2><a id="dataset"></a>Dataset</h2>

**Source:** Swiggy Food Delivery Dataset
**Records:** 197,431 rows (cleaned)

Key Columns:

* Location attributes: State, City, Location
* Restaurant attributes: Restaurant_Name, Category, Dish_Name
* Order attributes: Order_Date, Price_INR
* Rating attributes: Rating, Rating_Count

---

<h2><a id="tools--technologies"></a>Tools & Technologies</h2>

* **SQL Server** (ETL, Star Schema, KPI Analysis, Window Functions, Joins, Aggregations, Date Functions)
* **GitHub** (Version Control)

---

<h2><a id="data-cleaning--validation"></a>Data Cleaning & Validation</h2>

Performed comprehensive data profiling and cleaning on the raw `swiggy_data` table:

### Null Checks

Used conditional aggregation to detect null values in each column:

### Blank / Empty String Checks

Identify whitespace-only values and standardize text fields.

### Duplicate Detection & Removal

* Detected duplicates using `GROUP BY and HAVING Clause`
* Removed duplicates safely using a CTE with `ROW_NUMBER()`
* Ensured only unique, reliable rows remained

---

<h2><a id="dimensional-modeling--star-schema"></a>Dimensional Modeling (Star Schema)</h2>

Designed a full **Star Schema** for optimized analytics:

### **Dim Tables**

* **dim_date** → date_id, full_date, year, month, month_name, quarter, day, weeks
* **dim_location** → location_id, state, city, location
* **dim_restaurant** → restaurant_id, restaurant_name
* **dim_category** → category_id, category
* **dim_dish** → dish_id, dish_name

### **Fact Table**

* **fact_swiggy_orders**
  * order_id
  * price_inr
  * rating
  * rating_count
  * FK links: date_id, location_id, restaurant_id, category_id, dish_id

Star Schema enabled:

* Faster analytical queries
* Clear relationships
* Clean slice-and-dice analysis across all attributes

---

<h2><a id="etl-workflow"></a>ETL Workflow</h2>

### **Extract**

* Imported the raw CSV into SQL Server as `swiggy_data`
* Verified schema, row count, integrity

### **Transform**

* Cleaned nulls, blanks, and duplicates
* Normalized text and standardized data types
* Created dimension tables using DISTINCT values
* Generated date components (year, month, quarter, weekday)

### **Load**

* Loaded 5 dimension tables
* Loaded fact table using multi-table JOIN lookups

---

<h2><a id="sql-kpis--analysis"></a>SQL KPI's & Analysis</h2>

### **High-Level KPI's**

* Total Orders
* Total Revenue
* Average Dish Price
* Average Rating

### **Date-Based Analysis**

* Monthly Order Trends
* Quarterly Order Trends
* Yearly Orders
* Day-of-Week Order Distribution

### **Location-Based Analysis**

* Top 10 Cities by Orders
* Revenue Contribution by State
* Order Volume by State

### **Food & Restaurant Analysis**

* Top 10 Restaurants by Orders
* Top Categories by Orders
* Top 10 Dishes by Demand
* Cuisine Performance (Orders + Avg Rating)

### **Customer Spending Analysis**

* Price Range Order Distribution

### **Ratings Analysis**

* Rating Count Distribution

---

<h2><a id="key-insights"></a>Key Insights</h2>

* High Platform Activity: Swiggy recorded 197K+ orders, with steady growth observed across months and strong performance in Q1 and Q2
* Bengaluru Leads Demand: Bengaluru alone contributed 20K+ orders, making Karnataka the top state in both revenue and volume.
* Mid-Range Pricing Dominates: Orders are heavily concentrated in the ₹100–199 and ₹200–299 price bands, signaling strong mid-market customer behavior.
* Fast Food & Recommended Items Drive Volume: McDonald's, KFC, and the “Recommended” category significantly outperform all others, indicating strong brand and category pull.
* High Customer Satisfaction: With an average rating of 4.34 and consistently high category-level ratings, overall customer sentiment remains very positive.

---

<h2><a id="conclusion"></a>Conclusion</h2>

This analysis demonstrates that Swiggy's order ecosystem is driven by high-frequency metropolitan users, strong mid-range spending patterns, and consistent customer satisfaction across cuisines. Karnataka, particularly Bengaluru, emerges as the dominant market, while fast-food chains and "Recommended" items hold substantial influence over consumer ordering decisions.

The star-schema–based analytics pipeline enabled clean, structured insights into revenue, order behavior, cuisine preference, and pricing segments. The results indicate a stable, growing market with predictable demand cycles and strong brand loyalty, making Swiggy’s operational landscape both scalable and data-rich for deeper analysis.

---

<h2><a id="author--contact"></a>Author & Contact</h2>

**Hemanth S**      
Data Analyst        
📧 [Email](mailto:hemanths8181@gmail.com)    
🔗 [LinkedIn](https://www.linkedin.com/in/hemanth-s13/)   