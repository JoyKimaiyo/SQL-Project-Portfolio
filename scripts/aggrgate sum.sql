SELECT category, sum(revenue) - sum(mark_spent) as overall_ROMI_campaign from marketing_analysis
group by category;