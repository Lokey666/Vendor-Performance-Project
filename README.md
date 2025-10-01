# Vendor Performance Project

## 📌 Overview
The **Vendor Performance Project** is a data analytics solution to evaluate vendor efficiency, cost, and reliability.  
It integrates SQL (data extraction), Python (processing & analytics), and Power BI (visualization) to give actionable insights for procurement and operations teams.

---

## 📂 Repository Structure

```
├── sql/            # Created tables and loaded data and run queries
├── python/         # Python scripts / Jupyter notebooks
├── BI_Dashboard/   # Power BI dashboards & visuals
└── README.md       # Project documentation
```
---

## 🎯 Objectives
- Analyze **on-time delivery** vs delayed vendors  
- Track **cost efficiency** (freight, purchase variance)  
- Measure **quality metrics** (defects, rejection rates)  
- Build **dashboards** to compare vendor KPIs  
- Provide insights for **decision making** in vendor selection  

---

## 🛠️ Tech Stack
- **SQL** – Tables Creation, data extraction & transformations  
- **Python** – Data cleaning, aggregations, analysis (Pandas, NumPy, matplotlib, seaborn)  
- **Power BI** – Dashboard visualization & reporting  
- **Dax** - Created custom columns in PowerBi using dax
---

## 🚀 Workflow
1. **SQL Layer** 
   - Create Tables and Load data into tables using sqk
   - Run queries from `sql/` to fetch vendor, delivery, cost, and quality data.  
   - Generate staging/summary tables.  

2. **Python Layer**  
   - Clean & preprocess data.  
   - Compute KPIs (delivery %, rejection %, cost per unit, etc.).  
   - Perform exploratory data analysis (EDA).  

3. **BI Layer**  
   - Load processed data into `BI_Dashboard/`.  
   - Create visuals: KPI cards, donut charts, bar graphs, vendor rankings.  
   - Add slicers & filters for time, vendor, and product.  

---

## 📊 Key Metrics (Python Analysis)

| Metric                  | Description                                         |
|-------------------------|-----------------------------------------------------|
| Gross Profit            | Total sales dollars minus total purchase dollars     |
| Sales Margin (%)        | Gross profit as a percentage of total sales dollars |
| Stock Turnover          | Ratio of sales quantity to purchase quantity        |
| Unit Cost               | Average cost per unit purchased                     |
| Unsold Inventory Value  | Value of inventory not yet sold                     |

*These metrics are calculated and visualized in the Python notebooks using pandas, numpy, and matplotlib/seaborn.*

## 📈 Use Cases

- Identify vendors with the highest and lowest sales performance to optimize procurement strategies.
- Detect products or brands that require promotional or pricing adjustments based on sales margin and sales volume.
- Analyze the impact of bulk purchasing on unit price to inform cost-saving decisions.
- Spot vendors with low inventory turnover or excess unsold stock to improve inventory management.
- Monitor gross profit and sales margin trends to assess overall business health.
- Rank vendors and products by contribution to total sales and purchases for strategic planning.
- Visualize outliers and distribution in key metrics to uncover anomalies or improvement areas.
---

## 🔮 Future Enhancements
- Add **predictive models** to forecast vendor performance  
- Automate ETL using Airflow / Prefect  
- Integrate alerts for underperforming vendors  
- Expand dashboard with **trend analysis & drilldowns**  

---

## 🗄️ Data Model & Loading

The project is built on a robust relational database schema designed to capture all aspects of vendor operations, inventory management, purchasing, sales, and invoicing. The schema, defined in `CREATE TABLES.sql`, includes tables for inventory snapshots at different time points, product master data, transactional purchase and sales records, and vendor invoices. Each table is structured to support granular analysis, with fields for store, brand, product details, quantities, prices, dates, and vendor information.

For full code can access it here:[  Sql](01.sql)   

**Table Creation:**
```sql
-- Inventory snapshots
CREATE TABLE begin_inventory (...);
CREATE TABLE end_inventory (...);

-- Product master data
CREATE TABLE purchase_price (...);

-- Purchase and sales transactions
CREATE TABLE purchases (...);
CREATE TABLE sales (...);

-- Vendor invoices
CREATE TABLE vendor_invoice (...);
```
Data is loaded efficiently using bulk import commands in `TABLE_DATA_LOAD.sql`, which populate the tables from standardized CSV files. This approach ensures consistency, scalability, and rapid onboarding of new data, making it easy to refresh or expand the dataset as business needs evolve.

**Data Loading:**
```sql
COPY begin_inventory FROM 'D:\vendor data\data\begin_inventory.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY end_inventory FROM 'D:\vendor data\data\end_inventory.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY purchase_prices FROM 'D:\vendor data\data\purchase_prices.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY purchases FROM 'D:\vendor data\data\purchases.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY sales FROM 'D:\vendor data\data\sales.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY vendor_invoice FROM 'D:\vendor data\data\vendor_invoice.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
```

The normalized schema enables comprehensive reporting and analytics, supporting calculations of key performance indicators such as gross profit, sales margin, inventory turnover, and cost efficiency. It also facilitates integration with Python-based data processing and Power BI dashboards, allowing for advanced visualizations and interactive exploration of vendor performance.

This data foundation empowers procurement and operations teams to monitor trends, identify outliers, and make informed decisions based on reliable, up-to-date information.


## 📊 Python EDA & Analysis

The Python notebooks perform exploratory data analysis and generate key metrics to evaluate vendor performance. Data is extracted from the database, cleaned, and transformed to support actionable insights.

Haven't add every eda code and analysis here.For full code can access it here:[ Python](01.sql)

**Workflow & Key Code:**

```python
# Connect to database and list tables
import pandas as pd
from sqlalchemy import create_engine, text
engine = create_engine("postgresql+psycopg2://postgres:bubble@localhost:5432/vendor_project")
tables = pd.read_sql("SELECT table_name FROM information_schema.tables WHERE table_schema='public';", engine)

# Load relevant tables for analysis
purchases = pd.read_sql("select * from purchases where purchases.Vendor_Number = 4466", engine)
sales = pd.read_sql("select * from sales where vendor_number = 4466", engine)
purchase_prices = pd.read_sql("select * from purchase_prices where vendor_number = 4466", engine)
vendor_invoice = pd.read_sql("select * from vendor_invoice where vendor_number = 4466", engine)

# Create vendor summary table for KPIs
vendor_summary = pd.read_sql("""
with vendor_data as (
    select vendor_number, sum(freight) as total_freight from vendor_invoice group by vendor_number
),
purchase_summary as (
    select p.vendor_number, p.vendor_name, p.brand, p.description, p.purchase_price, pp.price as actual_price, pp.volume,
           sum(p.dollars) as total_purchase_dollars, sum(p.quantity) as total_purchase_quantity
    from purchases p
    join purchase_prices pp on p.brand = pp.brand
    where p.purchase_price > 0
    group by p.vendor_number, p.vendor_name, p.brand, p.description, p.purchase_price, pp.price, pp.volume
),
sales_summary as (
    select vendor_number, brand, sum(sales_quantity) as total_sales_quantity, sum(sales_dollars) as total_sales_dollars,
           sum(sales_price) as total_sales_price, sum(excise_tax) as total_excise_tax
    from sales
    group by vendor_number, brand
)
select ps.vendor_name, ps.vendor_number, ps.brand, ps.description, ps.actual_price, ps.purchase_price, ps.volume,
       ps.total_purchase_quantity, ps.total_purchase_dollars, ss.total_sales_quantity, ss.total_sales_dollars,
       ss.total_sales_price, ss.total_excise_tax, va.total_freight
from purchase_summary ps
left join sales_summary ss on ps.vendor_number = ss.vendor_number and ps.brand = ss.brand
left join vendor_data va on ps.vendor_number = va.vendor_number
order by ps.total_purchase_dollars desc;
""", engine)

# Calculate key metrics
vendor_summary['gross_profit'] = vendor_summary['total_sales_dollars'] - vendor_summary['total_purchase_dollars']
vendor_summary['sales_margin'] = (vendor_summary['gross_profit'] / vendor_summary['total_sales_dollars']) * 100
vendor_summary['stock_turnover'] = vendor_summary['total_sales_quantity'] / vendor_summary['total_purchase_quantity']
vendor_summary['unit_cost'] = vendor_summary['total_purchase_dollars'] / vendor_summary['total_purchase_quantity']
vendor_summary['unsold_quantity_value'] = (vendor_summary['total_purchase_quantity'] - vendor_summary['total_sales_quantity']) * vendor_summary['purchase_price']

# Filter for positive performance
filtered = vendor_summary[(vendor_summary['gross_profit'] > 0) & (vendor_summary['sales_margin'] > 0) & (vendor_summary['total_sales_quantity'] > 0)]

# Export summary for dashboarding
filtered.to_csv('vendor_summary.csv', index=False)
```

**Key Data Observations:**
- The `vendor_invoice` and `purchase_price` tables together provide a complete view of purchases, including cost and freight.
- Purchase data includes brand, quantity, price, and total spend; sales data covers quantity sold, revenue, and sale dates.
- There are negative gross profits and sales margins for some vendors, indicating losses.
- Many products have zero sales quantity, highlighting unsold inventory.
- Outliers and skewed distributions are present in sales margin and unit cost, requiring careful filtering.
- Bulk purchasing generally reduces unit price, with large purchase groups showing lower cost variability.
- The summary table enables calculation of KPIs such as gross profit, sales margin, stock turnover, and unsold inventory value for each vendor and brand.

This analysis supports vendor evaluation, cost optimization, and inventory management, and provides a foundation for dashboarding and further business insights.

This workflow enables efficient extraction, transformation, and analysis of vendor data, supporting KPI calculation and dashboard creation.

## 📊 Python Analysis & Insights

This notebook analyzes vendor performance using the processed `vendor_summary` table. It generates summary statistics, visualizes key metrics, and identifies actionable business insights.

**Workflow & Key Code:**

```python
# Import libraries and connect to database
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine, text
engine = create_engine("postgresql+psycopg2://postgres:bubble@localhost:5432/vendor_project")

# Load vendor summary data
df = pd.read_sql('select * from vendor_summary', engine)

# Summary statistics and initial observations
df.describe().T

# Visualize distributions and outliers
num_cols = df.select_dtypes(include=["int64", "float64"]).columns
plt.figure(figsize=(15, 12))
for i, col in enumerate(num_cols):
    plt.subplot(4,4, i+1)
    sns.boxplot(df[col])
    plt.title(col)
plt.tight_layout()
plt.show()

# Filter for positive performance
df = pd.read_sql("select * from vendor_summary where gross_profit > 0 and sales_margin > 0 and total_sales_quantity > 0;", engine)

# Top vendors and products by sales
top_vendors = df.groupby('vendor_name')['total_sales_dollars'].sum().reset_index().sort_values(by='total_sales_dollars', ascending=False).head(10)
top_products = df.groupby('description')['total_sales_dollars'].sum().reset_index().sort_values(by='total_sales_dollars', ascending=False).head(10)

# Pareto chart for vendor contribution
performance = df.groupby('vendor_name').agg({
    'total_purchase_dollars': 'sum',
    'total_sales_dollars': 'sum',
    'gross_profit': 'sum'
}).reset_index()
performance['percent_contribution%'] = (performance['total_purchase_dollars']/performance['total_purchase_dollars'].sum())*100
performance['cumulative_contribution%'] = performance['percent_contribution%'].cumsum()

# Bulk purchasing impact on unit price
df['unit_cost'] = df['total_purchase_dollars'] / df['total_purchase_quantity']
df['qty_group'] = pd.qcut(df['total_purchase_quantity'], 3, labels=['Small','Medium','Large'])
df.groupby('qty_group', observed=False)['unit_cost'].mean()

# Inventory turnover and unsold stock
low_turnover = df[df['stock_turnover']<1].groupby('vendor_name')[['stock_turnover']].mean().sort_values('stock_turnover', ascending=True).head(10)
df['unsold_quantity_value'] = (df['total_purchase_quantity'] - df['total_sales_quantity'])*df['purchase_price']
unsold_capital = df.groupby('vendor_name')[['unsold_quantity_value']].sum().reset_index().sort_values('unsold_quantity_value', ascending=False)

# Export for dashboarding
df.to_csv('vendor_summary.csv', index=False)
```
---

**Key Data Observations:**
- Data distributions are skewed, with many outliers in sales margin and unit cost.
- Negative gross profit and sales margin values indicate some vendors are operating at a loss.
- Many products have zero sales quantity, highlighting unsold inventory and slow-moving stock.
- Bulk purchasing consistently reduces unit price, with large purchase groups showing lower cost variability.
- Top vendors and products are identified by total sales dollars, supporting strategic procurement decisions.
- Pareto analysis reveals that a small number of vendors contribute the majority of purchases.
- Inventory turnover analysis highlights vendors with excess stock and slow-moving products.
- Unsold inventory value is calculated per vendor, supporting capital optimization.

This analysis enables targeted vendor management, cost control, and inventory optimization, and provides a foundation for interactive dashboarding and further business insights.

## 📊 Vendor Performance Dashboard Overview

The Vendor Performance Dashboard provides a comprehensive view of vendor and brand performance, enabling data-driven decisions for procurement and operations teams.

**Key Features & Insights:**

- **Total Sales, Purchases, Gross Profit, and Unsold Capital:**  
  Instantly view overall business metrics, including total sales ($441.41M), total purchases ($307.34M), gross profit ($134.07M), and unsold capital ($2.71M).

- **Top Vendor Contribution:**  
  The top 10 vendors contribute 65.69% of total purchases, highlighting key supplier relationships.

- **Brand Analysis for Promotion/Pricing:**  
  Brands needing promotional or pricing adjustment are visually identified using sales margin and total sales scatter plots, helping target underperforming products.

- **Low Performing Vendors:**  
  Vendors with the lowest inventory turnover are highlighted, supporting inventory optimization and supplier management.

- **Top Vendors & Brands by Sales:**  
  Bar charts display the highest performing vendors and brands by total sales, enabling quick benchmarking and strategic planning.

**How to Use:**

- Use the dashboard to monitor overall financial health and vendor performance.
- Identify which vendors and brands drive the majority of sales and profit.
- Target brands for promotional or pricing strategies based on sales margin analysis.
- Address low-performing vendors to reduce excess inventory and improve turnover.
- Support procurement decisions with clear, actionable visualizations.

This dashboard empowers teams to optimize vendor selection, manage inventory efficiently, and maximize profitability through interactive, data-driven insights.

---

## 📝 What I Learned

Working on the Vendor Performance Project provided valuable insights into the end-to-end analytics workflow, from data extraction and transformation to advanced visualization. Key takeaways include:

- The importance of a well-structured data model for enabling robust analysis and reporting.
- How integrating SQL, Python, and Power BI streamlines the process of generating actionable business insights.
- The value of cleaning and preprocessing data to ensure accuracy in KPI calculations and dashboard metrics.
- Techniques for identifying outliers, low-performing vendors, and brands needing promotional or pricing adjustments.
- The impact of bulk purchasing on unit cost and inventory turnover, supporting strategic procurement decisions.
- How visual analytics can highlight trends, outliers, and key contributors, making complex data accessible for decision makers.
- The necessity of continuous data validation and filtering to maintain reliable, up-to-date dashboards.

This project reinforced the importance of combining technical skills with business understanding to deliver solutions that drive operational efficiency and informed decision-making.

---

## 🤝 Contribution
Feel free to fork this repo, submit PRs, or suggest improvements.  

---


