USE magist123;
#It is not clear that Magist is a good partner for these high-end tech products.
SELECT * FROM product_category_name_translation;
SELECT DISTINCT product_category_name, product_id
FROM products
WHERE product_category_name IN (
    'audio',
    'consoles_games',
    'dvds_blu_ray',
    'eletrodomesticos',
    'eletrodomesticos_2',
    'eletronicos',
    'eletroportateis',
    'informatica_acessorios',
    'pc_gamer',
    'pcs',
    'tablets_impressao_imagem',
    'telefonia',
    'telefonia_fixa'
) ;

SELECT COUNT(DISTINCT product_id) AS 'No_of_Tech_Products', product_category_name_english AS 'Product_category'
FROM products 
LEFT JOIN product_category_name_translation USING
(product_category_name)
	WHERE product_category_name_english IN (
      'audio',
    'consoles_games',
    'dvds_blu_ray',
    'electronics',
    'computers_accessories',
    'pc_gamer',
    'computers',
    'tablets_printing_image'
) GROUP BY product_category_name_english;

SELECT COUNT(product_id) FROM products;

SELECT COUNT(product_id)
FROM products 
LEFT JOIN product_category_name_translation USING
(product_category_name)
	WHERE product_category_name_english IN (
      'audio',
    'consoles_games',
    'dvds_blu_ray',
    'electronics',
    'computers_accessories',
    'pc_gamer',
    'computers',
    'tablets_printing_image');
    
SELECT 32951/2621;

------ How many products of these tech categories have been sold 
-- (within the time window of the database snapshot)? 
SELECT COUNT(product_id) AS 'Tech_items_sold'
FROM order_items
LEFT JOIN products
     USING (product_id)
LEFT JOIN product_category_name_translation
     USING (product_category_name)
WHERE product_category_name_english IN ('audio',
    'consoles_games',
    'dvds_blu_ray',
    'electronics',
    'computers_accessories',
    'pc_gamer',
    'computers',
    'tablets_printing_image');
    
    ----- What percentage does that represent from the overall number of products sold?
SELECT COUNT(DISTINCT product_id)
FROM order_items;
SELECT 12454/32951 AS '%_of_Tech_items_sold';

---- -- What’s the average price of the products being sold?
SELECT ROUND(AVG(price),2) AS ' Avg_price_(€)_of_the_products'
FROM order_items;

--- -- Are expensive tech products popular? *
-- * TIP: Look at the function CASE WHEN to accomplish this task.

SELECT CASE
WHEN price > 500 THEN 'Expensive'
WHEN price > 100 THEN 'Mid-level'
ELSE 'Cheap'
END AS Price_range, COUNT(product_id) AS 'No_of_Products'
FROM order_items 
LEFT JOIN products
	USING (product_id)
LEFT JOIN product_category_name_translation
	USING (product_category_name)
WHERE product_category_name_english IN ('audio',
    'consoles_games',
    'dvds_blu_ray',
    'electronics',
    'computers_accessories',
    'pc_gamer',
    'computers',
    'tablets_printing_image')
GROUP BY price_range;

--- In relation to the sellers:
--- How many months of data are included in the magist database?
SELECT MIN(order_purchase_timestamp), MAX(order_purchase_timestamp) FROM orders;

--- What’s the average time between the order being placed and the product being delivered?
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_approved_at)) AS 'Avg_delivery_time' FROM orders;

-- How many orders are delivered on time vs orders delivered with a delay?

SELECT CASE
WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0 THEN "delayed"
ELSE "on-time"
END AS 'delivery_status', count(order_id) AS 'No_of_orders'
from orders
where order_status = "delivered"
group by delivery_status;
