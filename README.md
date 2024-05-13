# Virtual Internship Program: Big Data Analytics-Kimia Farma
Name: Nishrina Rawi
E-mail: nishrinarawi@gmail.com
LinkedIn: www.linkedin.com/in/nishrina-rawi

## Kimia Farma Performance Analytics 2020-2023

Kimia Farma Tbk (KAEF) is the first pharmaceutical industry company in Indonesia established by the Dutch East Indies Government in 1817. For this reason, Kimia Farma has been present for more than 100 years, in line with the development and development of the nation, especially the development of Indonesian Health. Currently, Kimia Farma and its business groups have a network of 10 Factories, 1,234 Pharmacy outlets (Apotek Kimia Farma), 419 Health Clinic outlets, 72 Clinical Laboratory outlets, 8 Optics and 3 Beauty Clinics.

### Objective
As a Big Data Analytics Intern at Kimia Farma, my tasks include a series of challenges that require a deep understanding of data and analytical skills. I have been asked to evaluate the business performance of Kimia Farma from 2020 to 2023. The analysis process begins with creating a database using Google BigQuery and then proceeds with creating a performance analytics dashboard using Looker Studio.

### Tools

## Dataset 
There are four tables used in this project, including: 
- **kf_final_transaction.csv**
-transaction_id: kode id transaksi,
-product_id : kode produk obat,
-branch_id: kode id cabang Kimia Farma,
-customer_name: nama customer yang melakukan transaksi,
-date: tanggal transaksi dilakukan,
-price: harga obat,
-discount_percentage: persentase diskon yang diberikan pada obat,
-rating: penilaian konsumen terhadap transaksi yang dilakukan.

- **kf_product.csv**

|Attribute|Description|
|----------|----------------|
|product_id|kode produk obat|
|product_name|nama produk obat|
|product_category|kategori produk obat|
|price|harga obat|
- **kf_inventory.csv**

|Attribute|Description|
|----------|----------------|
|inventory_ID|kode inventory produk obat|
|branch_id|kode id cabang Kimia Farma|
|product_id|kode id produk obat|
|product_name|nama produk obat|
|opname_stock|jumlah stok produk obat|
- **kf_kantor_cabang.csv**

|Attribute|Description|
|----------|----------------|
|branch_id|kode id cabang Kimia Farma|
|branch_category|kategori cabang Kimia Farma|
|branch_name|nama kantor cabang Kimia Farma|
|kota|kota cabang Kimia Farma|
|provinsi|provinsi cabang Kimia Farma|
|rating|penilaian konsumen terhadap cabang Kimia Farma|


### Create Database
1. Import data to Google Bigquery
2. Set Primary Key and Foreign Key  
After all datasets are imported into BigQuery, primary key and foreign key settings are configured to connect those tables to each other.

```sql
ALTER TABLE performance_analytics.final_transaction ADD PRIMARY KEY (transaction_id) NOT ENFORCED;
ALTER TABLE performance_analytics.inventory ADD PRIMARY KEY (Inventory_ID) NOT ENFORCED;
ALTER TABLE performance_analytics.kantor_cabang ADD PRIMARY KEY (branch_id) NOT ENFORCED;
ALTER TABLE performance_analytics.product ADD PRIMARY KEY (product_id) NOT ENFORCED;

ALTER TABLE performance_analytics.final_transaction ADD FOREIGN KEY (branch_id) REFERENCES performance_analytics.kantor_cabang (branch_id) NOT ENFORCED;
ALTER TABLE performance_analytics.final_transaction ADD FOREIGN KEY (product_id) REFERENCES performance_analytics.product (product_id) NOT ENFORCED;
ALTER TABLE performance_analytics.inventory ADD FOREIGN KEY (branch_id) REFERENCES performance_analytics.kantor_cabang (branch_id) NOT ENFORCED;
ALTER TABLE performance_analytics.inventory ADD FOREIGN KEY (product_id) REFERENCES performance_analytics.product (product_id) NOT ENFORCED;
```

3. Create new aggregate table  
Then from those four main tables, a new table named 'analysis_table' is created.
![new_table](https://github.com/nishrinarawi/kf-performance-analytics/blob/44f087fbf1f6efbc523258c14e396edcf03bed59/asset/new_table.png)  

```sql
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
```

### Create Performance Analytics Dashboard
Here is the performance analytics dashboard that I have created. This dashboard consists of 3 pages.

1. Overview
The first page contains information about the attributes of the tables and an overview of the tables.

![dashboard1](https://github.com/nishrinarawi/kf-performance-analytics/blob/b40e98f4b715b75a496a7f49a0ea781d7869f39f/asset/dashboard1.png)  
2. Summary
The second page contains a summary of performance analytics from Kimia Farma.
![dashboard2](https://github.com/nishrinarawi/kf-performance-analytics/blob/44f087fbf1f6efbc523258c14e396edcf03bed59/asset/dashboard2.png)  
3. Area

On this page, you can see the performance based on the area of each branch. This page also includes a geo chart to visualize performance through a map. The color on the map indicates the number of branches in that province. The darker or more orange the color, the more branches are present in that province. 
![dashboard3](https://github.com/nishrinarawi/kf-performance-analytics/blob/44f087fbf1f6efbc523258c14e396edcf03bed59/asset/dashboard3.png)

There are filters for province, city, and even branch. Additionally, there is a date filter. For example, if you click on the Aceh province area, all metrics will calculate specifically for the branches located in Aceh province, and the same applies to other filters.
