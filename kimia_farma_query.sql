CREATE OR REPLACE TABLE `alpine-scholar-476014-n7.kimia_farma.kf_analisis` AS

WITH 
  ft AS (SELECT * FROM `alpine-scholar-476014-n7.kimia_farma.kf_final_transaction`),
  p AS (SELECT * FROM `alpine-scholar-476014-n7.kimia_farma.kf_product`),
  kc AS (SELECT * FROM `alpine-scholar-476014-n7.kimia_farma.kf_kantor_cabang`),
  i AS (SELECT * FROM `alpine-scholar-476014-n7.kimia_farma.kf_inventory`)

SELECT
  ft.transaction_id,
  ft.date,
  ft.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  p.product_id,
  p.product_name,
  p.price AS actual_price,
  ft.discount_percentage,

  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  ROUND(p.price * (1 - ft.discount_percentage), 2) AS nett_sales,

  ROUND(
    (p.price * (1 - ft.discount_percentage)) *
    CASE
      WHEN p.price <= 50000 THEN 0.10
      WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
      WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
      WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
      ELSE 0.30
    END,
    2
  ) AS nett_profit,

  ft.rating AS rating_transaksi

FROM ft
LEFT JOIN p 
  ON ft.product_id = p.product_id
LEFT JOIN kc 
  ON ft.branch_id = kc.branch_id
LEFT JOIN i 
  ON ft.branch_id = i.branch_id 
  AND ft.product_id = i.product_id;
