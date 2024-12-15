/*ALTER TABLE marketing_analysis ADD COLUMN geo_locations VARCHAR(255);*/
SET SQL_SAFE_UPDATES = 0;

UPDATE marketing_analysis
SET 
    geo_locations = SUBSTRING_INDEX(campaign_name, '_', -1),
    campaign_name = SUBSTRING_INDEX(campaign_name, '_', 1);
