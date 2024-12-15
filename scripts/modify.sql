/*ALTER TABLE marketing_analysis
MODIFY COLUMN ROMI INT;*/

/*Update marketing_analysis
set ROMI= revenue - mark_spent;*/

SELECT geo_locations, sum(ROMI) as total_ROMI from marketing_analysis
group by geo_locations
order by total_ROMI desc;


