SELECT SUM((CASE WHEN `t0`.`x_measure__1` = 0 THEN NULL ELSE `t0`.`x_measure__0` / `t0`.`x_measure__1` END)) AS `sum_calculation_270497503514808329_ok`
FROM (
SELECT `store`.`s_store_id` AS `s_store_id`,
SUM(`store_sales`.`ss_net_profit`) AS `x_measure__0`,
SUM(`store_sales`.`ss_net_paid`) AS `x_measure__1`
FROM `${DB}`.`store_sales` `store_sales`
JOIN `${DB}`.`item` `item` ON (`store_sales`.`ss_item_sk` = `item`.`i_item_sk`)
JOIN `${DB}`.`customer` `customer` ON (`store_sales`.`ss_customer_sk` = `customer`.`c_customer_sk`)
JOIN `${DB}`.`customer_address` `customer_address` ON (`customer`.`c_current_addr_sk` = `customer_address`.`ca_address_sk`)
JOIN `${DB}`.`date_dim_date` `date_dim_date` ON (`store_sales`.`ss_sold_date_sk` = `date_dim_date`.`d_date_sk`)
JOIN `${DB}`.`store` `store` ON (`store_sales`.`ss_store_sk` = `store`.`s_store_sk`)
JOIN `${DB}`.`customer_demographics` `customer_demographics` ON (`customer`.`c_current_cdemo_sk` = `customer_demographics`.`cd_demo_sk`)
GROUP BY `store`.`s_store_id`
) `t0`
GROUP BY 1
HAVING (COUNT(1) > 0) ;

