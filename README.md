We are going to use the digital marketing data from Kaggle https://www.kaggle.com/datasets/sinderpreet/analyze-the-marketing-spending for our project to determine how much was spent, how much was earned, how customers behaved (who clicked on the ad banner, who signed up, who paid). In addition to calculating marketing metrics that would help us evaluate if the campaign did a good job or not and also identify some parameters of the campaign that would be important for analysis. For this project, we are using MySQL.

We are going to answer the following;

1- Overall ROMI (Return on marketing investment)
2- ROMI by campaigns
3- Performance of the campaign depending on the date — on which date did the company spend the most money on advertising, when did the company get the biggest revenue when conversion rates were high and low?

4-What were the average order values by the campaign?
5- When buyers are more active? What is the average revenue on weekdays and weekends?
6- Which types of campaigns work best — social, banner, influencer, or search?
7- Which geo locations are better for targeting — tier 1 or tier 2 cities?

Data Importation

First, let’s create a database to import our downloaded data.

Create database marketing_spending;
The second task will be to import our data to the tables. Click the database, then tables, and then click table data import. Browse your file path ensure it is in CSV format then follow the prompts.

To understand our data let’s select all from the marketing analysis table.

Use marketing_spending;
SELECT * FROM marketing_analysis;

Columns Description

Date- date of spending of the marketing budget
Campaign name -description of the campaign
Category-type of marketing source
Campaign id -unique identifier
Impressions -number of times the ad has been shown
Mark. spent- money spent on this campaign on this day
Clicks -how many people clicked on a banner (=visited website)
Leads -how many people signed up and left their credentials
Orders -how many people paid for the product
Revenue -how much money was earned

Data Cleaning

In the Campaign name category, we can see that two types of information are grouped into one and we have to determine the geo-locations that are better for targeting — tier 1 or tier 2 cities. We need to separate Facebook_tier1 from Facebook and tier1. We can do this by first altering our table and adding a new column,

ALTER TABLE marketing_analysis ADD COLUMN geo_locations VARCHAR(255);
Next, we update our column. Using the string function substring_index which returns the substring as specified we can separate the two words using the delimiter underscore—the negative returns from the right and the positive from the left.

UPDATE market_analysis
SET geo_locations = SUBSTRING_INDEX(campaign_name, '_', -1),
    campaign_name = SUBSTRING_INDEX(campaign_name, '_', 1);

Next, there is an issue with the spelling of some Facebook words such as ‘facebOOK’. We can use string function .lower to ensure all values in the column are in lowercase

update marketing_analysis
set campaign_name=lower(campaign_name);

And finally, MySQL expects date values to be in the YYYY-MM-DD format for proper date and time operations. Our date format is in mm-dd-yyyy.

UPDATE marketing_analysis
SET c_date = STR_TO_DATE(c_date, '%m/%d/%Y');
Digital Marketing Metric Analysis

Let’s begin answering our questions.

Overall ROMI (Return on marketing investment)

To calculate overall ROMI we will sum up all the revenue and subtract the sum of the market spent

SELECT sum(revenue) - sum(mark_spent) as overall_ROMI from marketing_analysis;
Which equals to # overall_ROMI
‘12298486.180000003’

ROMI by campaigns

To calculate the total ROMI by category (campaigns) we can use group by and add a category column to the select clause above

SELECT category, sum(revenue) - sum(mark_spent) as overall_ROMI_campaign from marketing_analysis
group by category;
Which returns;


Performance of the campaign depending on the date

on which date did the company spend the most money on advertising

To determine this we can select the date and market spent order by revenue in descending order and then limit it to 1

SELECT c_date, mark_spent from marketing_analysis
order by mark_spent desc
limit 1;

when the company got the biggest revenue and when conversion rates were high and low?

For the company to get high conversion from their campaign we can gauge that revenue to determine which date had the highest revenue we select the date and revenue and then order by revenue in descending order(largest to smallest)

SELECT c_date, revenue from marketing_analysis 
order by revenue desc
limit 1;

On the other hand, to determine the lowest we can use the same query but instead of desc we use asc

SELECT c_date, revenue from marketing_analysis 
order by revenue desc
limit 1;
What were the average order values by the campaign?

To determine average orders by campaign we can select category and orders average then group by category

SELECT category, avg(orders) as average_per_category from marketing_analysis
group by category;

When buyers are more active (Weekdays or Weekends)

To determine weekends from weekdays we can use dayofweek function. The DAYOFWEEK() function returns the weekday index for a given date (a number from 1 to 7). 1=Sunday, 2=Monday, 3=Tuesday, 4=Wednesday, 5=Thursday, 6=Friday, 7=Saturday. But first, we need to alter our table and add column day_type to store our values, update our table using the case function to determine when the date is in 1, 7 (weekend) else weekday

ALTER table marketing_analysis
add column day_type varchar (255);

UPDATE marketing_analysis
SET day_type = CASE 
    WHEN DAYOFWEEK(c_date) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
END;
Finally, we determine when buyers are more active on weekends or weekdays by selecting day_type, orders and then group by day_type.

SELECT day_type, sum(orders) from marketing_analysis
groupby day_type;

From the above, we can conclude that weekdays have more active buyers than weekend

Which types of campaigns work best

To gauge the effectiveness of a campaign, we can use ROMI per category, and we can see that influencers work best.


Which geo locations are better for targeting tier 1 or tier 2 cities?

To determine the geo-locations that are better for targeting we can use overall ROMI per geo_location. To do that we need to alter the table and add a new column ROMI that stores the integer revenue values minus mark_spent. Then update the table with values and finally select geo_locations, sum ROMI as total_ROMI, group_by geo_locations then order by total_ROMI in descending order;

Alter table marketing_analysis
add column ROMI int;

Update marketing_analysis
set ROMI= revenue - mark_spent;

SELECT geo_locations, sum(ROMI) as total_ROMI from marketing_analysis
group by geo_locations
order by total_ROMI desc;

From the above image, it will be better to target tier 1 cities as their return on investment is higher than tier 2.

Check my portfolio website at https://joykimaiyo.github.io/

Follow me on LinkedIn https://www.linkedin.com/in/joy-kimaiyo-185684225/
