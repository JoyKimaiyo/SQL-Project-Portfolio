SELECT category, avg(orders) as average_per_category from marketing_analysis
group by category;