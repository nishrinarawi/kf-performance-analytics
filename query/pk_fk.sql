ALTER TABLE performance_analytics.final_transaction ADD PRIMARY KEY (transaction_id) NOT ENFORCED;
ALTER TABLE performance_analytics.inventory ADD PRIMARY KEY (Inventory_ID) NOT ENFORCED;
ALTER TABLE performance_analytics.kantor_cabang ADD PRIMARY KEY (branch_id) NOT ENFORCED;
ALTER TABLE performance_analytics.product ADD PRIMARY KEY (product_id) NOT ENFORCED;

ALTER TABLE performance_analytics.final_transaction ADD FOREIGN KEY (branch_id) REFERENCES performance_analytics.kantor_cabang (branch_id) NOT ENFORCED;
ALTER TABLE performance_analytics.final_transaction ADD FOREIGN KEY (product_id) REFERENCES performance_analytics.product (product_id) NOT ENFORCED;
ALTER TABLE performance_analytics.inventory ADD FOREIGN KEY (branch_id) REFERENCES performance_analytics.kantor_cabang (branch_id) NOT ENFORCED;
ALTER TABLE performance_analytics.inventory ADD FOREIGN KEY (product_id) REFERENCES performance_analytics.product (product_id) NOT ENFORCED;

