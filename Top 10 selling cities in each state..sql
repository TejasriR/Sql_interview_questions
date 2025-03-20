create database csvdb;
use csvdb;

select * from sourcecsv ;

select product_name, count(price) total_sales from sourcecsv group by product_name ;


SELECT 
    product_name,SUBSTRING_INDEX(SUBSTRING_INDEX(`Address (Door_No,Street_Name,City,State,Pin,Country)`, ',', 3), ',', -1) AS city, 
    COUNT(Product_Name) AS product_count
FROM sourcecsv
WHERE `Address (Door_No,Street_Name,City,State,Pin,Country)` is not null
GROUP BY city , product_name;

#Top 10 selling cities 
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(`Address (Door_No,Street_Name,City,State,Pin,Country)`, ',', 3), ',', -1) AS city,
    COUNT(product_name) AS product_count
FROM sourcecsv
WHERE  `Address (Door_No,Street_Name,City,State,Pin,Country)` is not null
GROUP BY city
ORDER BY product_count DESC
LIMIT 10;

# Top 10 selling cities in each state.
WITH city_sales AS (
    SELECT 
        SUBSTRING_INDEX(SUBSTRING_INDEX(`Address (Door_No,Street_Name,City,State,Pin,Country)`, ',', 3), ',', -1) AS city,
        SUBSTRING_INDEX(SUBSTRING_INDEX(`Address (Door_No,Street_Name,City,State,Pin,Country)`, ',', 4), ',', -1) AS state,
        COUNT(product_name) AS product_count
    FROM sourcecsv
    WHERE `Address (Door_No,Street_Name,City,State,Pin,Country)` IS NOT NULL
    GROUP BY  city ,state
     
),
ranked_cities AS (
    SELECT 
        city, 
        state, 
        product_count,
        RANK() OVER (PARTITION BY state ORDER BY product_count DESC) AS rank1
    FROM city_sales
)
SELECT city, state, product_count
FROM ranked_cities
WHERE rank1 <= 10
ORDER BY state, rank1;





