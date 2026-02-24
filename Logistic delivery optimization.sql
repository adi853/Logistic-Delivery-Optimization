--Creating Dashboard --
Create Database Logistic_delivery_optimization;
Use Logistic_delivery_optimization;
-- Directly import from folder --
SELECT 
    *
FROM
    DATA;

-- 1.AGENT NAME WISE RATING --
SELECT 
    `Agent Name`,ROUND(AVG(`Rating`), 2) AS average_rating,
    ROUND(AVG(`Rating`), 2) AS average_rating,
    (CASE
        WHEN ROUND(AVG(`Rating`), 2) > 3 THEN 'Very good rating'
        WHEN ROUND(AVG(`Rating`), 2) > 2 THEN 'Good Rating'
        ELSE 'Bad Rating'
    END) AS rating_status
FROM
    data
GROUP BY `Agent Name`
ORDER BY average_rating;

-- 2.AGENT NAME AND ORDER TYPE RATING --
SELECT 
    `Agent Name`,
    `Order Type`,
    ROUND(AVG(`Rating`), 2) AS average_rating,
    (CASE
        WHEN ROUND(AVG(`Rating`), 2) > 3 THEN 'Very good rating'
        WHEN ROUND(AVG(`Rating`), 2) > 2 THEN 'Good Rating'
        ELSE 'Bad Rating'
    END) AS rating_status
FROM
    data
GROUP BY `Agent Name` , `Order Type`
ORDER BY rating_status;

-- 3.INFORMATION OF AGENT NAME ACCORDING TO CITY --
SELECT 
    `Agent Name`,
    `Location`,
    `Order Accuracy`,
    ROUND(AVG(`Delivery Time (min)`), 2) AS average_delivery_time_min,
    (CASE
        WHEN ROUND(AVG(`Delivery Time (min)`), 2)<34 THEN 'Fast delivery'
        ELSE 'very slow delivery'
    END) AS delivery_status
FROM
    data
GROUP BY `Agent Name` , `Location` , `Order Accuracy`
ORDER BY average_delivery_time_min ASC;

-- 4.OUT OF STOCK RATE & CONDITION STATUS --
SELECT 
    `Location`,
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN `Product Availability` = 'Out of Stock' THEN 1
        ELSE 0
    END) AS out_of_stock_status,
    ROUND((SUM(CASE
                WHEN `Product Availability` = 'Out of Stock' THEN 1
                ELSE 0
            END) / COUNT(*)) * 100,
            2) AS out_of_stock_rate,
    (CASE
        WHEN
            ROUND((SUM(CASE
                        WHEN `Product Availability` = 'Out of Stock' THEN 1
                        ELSE 0
                    END) / COUNT(*)) * 100,
                    2) < 47
        THEN
            'very good condition'
        WHEN
            ROUND((SUM(CASE
                        WHEN `Product Availability` = 'Out of Stock' THEN 1
                        ELSE 0
                    END) / COUNT(*)) * 100,
                    2) < 50
        THEN
            ' Medium condition '
        ELSE ' very bad condition'
    END) AS condition_status
FROM
    data
GROUP BY location
ORDER BY out_of_stock_rate ASC;

-- 5.PEROFRMANCE AND RANKING INFORMATION --
SELECT 
dense_rank() over(order by avg(`Rating`)desc
) as performance_rank,
    `Agent Name`,
    COUNT(*) AS total_orders,
    ROUND(AVG(`Delivery Time (min)`), 2) AS average_delivery_time,
    ROUND(AVG(`Rating`), 2) AS average_rating,
    (CASE
        WHEN `Order Accuracy` = 'Incorrect' THEN 'Bad'
        ELSE 'Good'
    END) AS Order_accuracy_performance,
    (CASE
        WHEN ROUND(AVG(`Delivery Time (min)`), 2) < 45 THEN 'Good'
        ELSE 'Bad'
    END) AS delivery_performance,
    (CASE
        WHEN ROUND(AVG(`Rating`), 2) > 3 THEN 'Good'
        ELSE 'bad'
    END) AS rating_performance,
    (CASE
        WHEN
            ROUND((SUM(CASE
                        WHEN `Product Availability` = 'Out of Stock' THEN 1
                        ELSE 0
                    END) / COUNT(*)) * 100,
                    2) < 47
        THEN
            'good'
        ELSE 'bad'
    END) AS performance_of_out_of_stock
FROM
    data
GROUP BY `Agent Name` , `Order Accuracy`
ORDER BY `Agent Name` ASC;
