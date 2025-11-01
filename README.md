# 💊 Kimia Farma Performance Analytics (2020–2023)

### 🚀 Overview
This project was developed as part of the **Big Data Analytics Intern program** at **Kimia Farma**, one of Indonesia’s oldest and leading pharmaceutical companies.  
The goal of this project is to analyze Kimia Farma’s **business performance from 2020 to 2023** using **Google BigQuery** and visualize the insights through an **interactive dashboard in Looker Studio**.

🔗 **View the full interactive dashboard here:**  
👉 [Kimia Farma Performance Dashboard on Looker Studio](https://lookerstudio.google.com/reporting/6e7827d6-5b4e-4e5e-b87b-3ba3b3e4afc4)

---

## 📂 Datasets Description

The analysis is based on four main datasets sourced from Kimia Farma’s internal data:

### 1. 🧾 `kf_final_transaction.csv`
Contains customer transaction details.  

| Column | Description |
|---------|-------------|
| `transaction_id` | Unique transaction ID |
| `product_id` | Product ID code |
| `branch_id` | Branch ID code |
| `customer_name` | Name of the customer |
| `date` | Date of transaction |
| `price` | Product price |
| `discount_percentage` | Discount applied to the product |
| `rating` | Customer rating for the transaction |

---

### 2. 💊 `kf_product.csv`
Contains product information and pricing.  

| Column | Description |
|---------|-------------|
| `product_id` | Product code |
| `product_name` | Product name |
| `product_category` | Product category |
| `price` | Product price |

---

### 3. 🏢 `kf_kantor_cabang.csv`
Contains information about Kimia Farma branch offices.  

| Column | Description |
|---------|-------------|
| `branch_id` | Branch ID code |
| `branch_category` | Branch category |
| `kota` | City where the branch is located |
| `branch_name` | Branch name |
| `provinsi` | Province |
| `rating` | Customer rating for the branch |

---

### 4. 📦 `kf_inventory.csv`
Contains product stock and availability information.  

| Column | Description |
|---------|-------------|
| `inventory_id` | Product inventory code |
| `branch_id` | Branch ID code |
| `product_id` | Product ID code |
| `product_name` | Product name |
| `opname_stock` | Total stock available |

---

## 🧠 Data Analytics Process

All datasets were combined and analyzed using **Google BigQuery**.  
The following SQL script was used to create a unified analytical table called `kf_analisis`.

### 🧩 Key Analysis Logic:
- **Join** all datasets using `product_id` and `branch_id`
- **Calculate Net Sales:** `price * (1 - discount_percentage)`
- **Assign Gross Profit Margin:** Based on product price range
- **Calculate Net Profit:** `net_sales * gross_profit_percentage`
- **Include Branch and Transaction Ratings** for performance evaluation

---

### 📘 SQL Code
```sql
CREATE OR REPLACE TABLE `alpine-scholar-476014-n7.kimia_farma.kf_analisis` AS
WITH 
  ft AS (SELECT * FROM `kimia_farma.kf_final_transaction`),
  p AS (SELECT * FROM `kimia_farma.kf_product`),
  kc AS (SELECT * FROM `kimia_farma.kf_kantor_cabang`),
  i AS (SELECT * FROM `kimia_farma.kf_inventory`)
SELECT
  ft.transaction_id, ft.date, kc.branch_name, kc.kota, kc.provinsi,
  p.product_name, p.price AS actual_price, ft.discount_percentage,
  ROUND(p.price * (1 - ft.discount_percentage), 2) AS nett_sales,
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price <= 100000 THEN 0.15
    WHEN p.price <= 300000 THEN 0.20
    WHEN p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS gross_profit_percentage,
  ROUND((p.price * (1 - ft.discount_percentage)) *
        CASE
          WHEN p.price <= 50000 THEN 0.10
          WHEN p.price <= 100000 THEN 0.15
          WHEN p.price <= 300000 THEN 0.20
          WHEN p.price <= 500000 THEN 0.25
          ELSE 0.30
        END, 2) AS nett_profit,
  ft.rating AS rating_transaksi,
  kc.rating AS rating_cabang
FROM ft
LEFT JOIN p ON ft.product_id = p.product_id
LEFT JOIN kc ON ft.branch_id = kc.branch_id
LEFT JOIN i ON ft.branch_id = i.branch_id AND ft.product_id = i.product_id;
```

## 📊 Dashboard Insights

The **Kimia Farma Performance Analytics Dashboard (2020–2023)** presents interactive insights through several visualizations.

### ✨ Dashboard Features
- **Scorecards:** Display total products, profit, revenue, transactions, branches, and customers.  
- **Time Series Chart:** Shows yearly trends in *Net Profit*.  
- **Bar Chart:** Highlights provinces with the highest *Net Profit* and transaction volume.  
- **Table:** Lists top-rated branches with low transactions and best-selling products.  
- **Bubble Map:** Displays *Net Profit* distribution across all provinces.  

---

### 🧭 Filter Options
The dashboard includes several filters to make exploration easier:
- Province  
- Year  
- Product Name  
- Branch  

---

### 🎯 Key Findings
- Provinces with high branch ratings do not always generate the highest transactions.  
- Discount strategies significantly influence *Net Profit* across product categories.  
- Certain products consistently contribute to revenue growth.  
- Strong business performance is concentrated in major provinces such as **Jakarta**, **West Java**, and **East Java**.  

---

### 📎 Resources
- **Tools Used:** Google BigQuery, Looker Studio  
- **Language:** SQL  
- **Visualization Platform:** Looker Studio  
- **Dataset Source:** Internal Kimia Farma Data (Rakamin Simulation Project)  

---

## 📊 Live Dashboard  
🔗 **Explore the full interactive dashboard here:**  
[Kimia Farma Looker Studio Dashboard](https://lookerstudio.google.com/reporting/6e7827d6-5b4e-4e5e-b87b-3ba3b3e4afc4)

---

## 👨‍💻 Author
**Bima Dharma Yahya**  
*Big Data Analytics Intern — Rakamin x Kimia Farma*  
📍 Passionate about Data Analytics, Visualization, and Insight Generation  
🔗 [Portfolio Linktree](https://linktr.ee/bimadharma)
