/*ALTER table marketing_analysis
add column day_type varchar (255);*/

/*UPDATE marketing_analysis
SET day_type = CASE 
    WHEN DAYOFWEEK(c_date) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
END;*/

SELECT day_type, sum(orders) from marketing_analysis
group by day_type;