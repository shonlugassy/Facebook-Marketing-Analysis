--1. check duplicates
select Customer_ID,COUNT(Approved_Conversion) from KAG_conversion_data group by Customer_ID having COUNT(Customer_ID) >2


--2. Converstaion Rate
with conversation_rate as (
select sum(Approved_Conversion) as[app C],SUM(Total_Conversion) as[total C] from KAG_conversion_data
)
select ([app C] / [total C]) * 100  as [Conversation Rate]from conversation_rate


--3. CLV
select k.Customer_ID,SUM(Ad_rev_per_customer) as [revenue of customer]
from KAG_conversion_data k inner join FB_AdCampaign_Data f 
on k.Customer_ID = f.Customer_ID
group by k.Customer_ID 
order by SUM(Ad_rev_per_customer) asc


--4. Retention
with [Retention] as ( 
select Ret_start,Ret_end,count(Customer_ID) as [c] from FB_AdCampaign_Data group by Ret_start,Ret_end
)
select  r.Ret_start,r.Ret_end,(r.[c] / COUNT(f.Customer_ID)) *100 as [retention rate]
from [Retention] r inner join FB_AdCampaign_Data f
on r.Ret_start = f.Ret_start
group by r.Ret_start,r.Ret_end,r.c


--5. ROI
select k.fb_campaign_id,(sum(f.Ad_rev_per_customer) - sum(k.campaign_cost)) /sum(k.campaign_cost) *100
from KAG_conversion_data k inner join FB_AdCampaign_Data f
on k.Customer_ID = f.Customer_ID
group by k.fb_campaign_id


--6. Revenue per Campaign
select xyz_campaign_id,sum(f.Ad_rev_per_customer) - sum(campaign_cost) as [revenue per campaign]
from KAG_conversion_data k inner join FB_AdCampaign_Data f 
on k.Customer_ID = f.Customer_ID
group by xyz_campaign_id
order by sum(f.Ad_rev_per_customer) - sum(campaign_cost) desc


--7.1. Which gender clicks more on the ad 
--  2. Buying
--  3. Revenue per gender
select gender,sum(Clicks)as [total clicks],SUM(Approved_Conversion)as[bought the product of the ad],sum(f.Ad_rev_per_customer) [revenue by gender]
from KAG_conversion_data k inner join FB_AdCampaign_Data f 
on k.Customer_ID = f.Customer_ID
group by gender 
order by sum(f.Ad_rev_per_customer) desc


--8. The company that spent the most amount of money to show their ad
select top 1 xyz_campaign_id,SUM(Spent) [campegins spent] from KAG_conversion_data group by xyz_campaign_id order by SUM(Spent)desc


--9. The company that spent the second amount of money to show their ad
with secondAm as (
select xyz_campaign_id,SUM(Spent) [campegins spent], ROW_NUMBER() over(order by SUM(Spent) desc) [r] from KAG_conversion_data group by xyz_campaign_id
)
select xyz_campaign_id, [campegins spent],[r] from secondAm where [r] =2


--10. Companys campaigns ad impressions and Amount paid of each ad campaign
select xyz_campaign_id,sum(Impressions) [company impression],SUM(Spent) [campegins spent] from KAG_conversion_data group by xyz_campaign_id order by sum(Impressions) desc


--11. Revenue per category code
select interest,SUM(f.Ad_rev_per_customer) as s
from KAG_conversion_data k inner join FB_AdCampaign_Data f
on k.Customer_ID = f.Customer_ID
group by interest


--12. The number of the people that buyed the product per category code
select interest,sum(Approved_Conversion)as [buyed] from KAG_conversion_data group by interest order by sum(Approved_Conversion) desc 


--13. Revenue by ages 
select k.age,sum(f.Ad_rev_per_customer) as [revenue by ages]
from KAG_conversion_data k inner join FB_AdCampaign_Data f
on k.Customer_ID = f.Customer_ID
where k.Customer_ID = 1000
group by k.age