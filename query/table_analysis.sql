CREATE TABLE performance_analytics.analysis_table AS 
SELECT DISTINCT (t.transaction_id), t.date, b.branch_id, b.branch_name, b.kota, b.provinsi, 
        b.rating AS rating_cabang, t.customer_name, p.product_id, p.product_name, p.price, t.discount_percentage,
        CASE 
          WHEN p.price <= 50000 THEN 0.1
          WHEN p.price <=100000 THEN 0.15
          WHEN p.price <=300000 THEN 0.2
          WHEN p.price <=500000 THEN 0.25
          ELSE 0.3
        END AS persentase_gross_laba, 
        p.price-(p.price*t.discount_percentage) AS nett_sales,
       ((p.price-(p.price*t.discount_percentage))-
       (p.price-(p.price*
       CASE 
          WHEN p.price <= 50000 THEN 0.1
          WHEN p.price <=100000 THEN 0.15
          WHEN p.price <=300000 THEN 0.2
          WHEN p.price <=500000 THEN 0.25
          ELSE 0.3
        END))) AS nett_profit,
       t.rating AS rating_transaksi 
FROM performance_analytics.final_transaction AS t
JOIN performance_analytics.kantor_cabang AS b ON t.branch_id=b.branch_id
JOIN performance_analytics.product AS p ON t.product_id=p.product_id;