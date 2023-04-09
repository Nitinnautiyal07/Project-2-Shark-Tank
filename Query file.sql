select * from pitches;

## Total number of episodes

select count(distinct(episode)) as Total_episodes from pitches;

## Total number of pitches

Select count(distinct(brand)) as Total_pitches from pitches;

## Pitches that got funding

select brand from pitches 
      where Amount_Invested_lakhs > 0;
      
## Total male participants

select sum(male) as total_male_participants from pitches;

## Total female participants

select sum(female) as total_female_participants from pitches;

## Gender ration in participation

select Round(sum(female)/sum(male),2) as gender_ration from pitches;

## Total amount invested

select sum(amount_invested_lakhs) as total_amount_inv_lakhs from pitches;

##Total equity taken

select round(avg(equity_taken_pct),2) as Avg_equity_taken_by_Sharks from
(
select * from pitches where Equity_taken_pct > 0
)a
;

## Biggest deal taken

select max(Amount_Invested_lakhs) as Biggest_deal_amount from pitches;

## Highest equity taken by sharks

select max(equity_taken_pct) as highest_equity_taken_by_Sharks from pitches;

## Pitches that have atleast one women

with female_pitchers as
(
select brand ,
       case
       when female > 0  then 1
       else 0
       end as female_count from pitches
)

select sum(female_count) as pitches_with_female from female_pitchers;

## Pitches converted having atleast one women

with pitches_converted_having_female as
(
select brand , amount_invested_lakhs,
       case
       when female > 0 and Amount_Invested_lakhs >0 then 1
       else 0
       end as female_count from pitches
)

select sum(female_count) as pitches_converted_having_female from pitches_converted_having_female;

## Average team members in pitches

select Round(avg(Team_members),0) as Avg_team_members from pitches;

## Average amount invested per deal

with avg_amnt_inv as(
select count(brand) as pitches_converted_to_deal, sum(Amount_Invested_lakhs) as total_amount_inv from
(select brand,Amount_Invested_lakhs from pitches 
      where Amount_Invested_lakhs > 0
)c
)
select Round((sum(total_amount_inv)/pitches_converted_to_deal),2) as avg_amount_inv_per_pitch from avg_amnt_inv;

## Locations from where most of the pitchers came

select location,count(location) from pitches
group by location
order by count(location) desc;

## Sector from which most of the pitches were from

select sector,count(sector) from pitches
group by sector
order by count(sector) desc;

## Partner deals

select partners,count(partners) from pitches where partners != "NA"
group by partners
order by count(partners) desc;

# SHarks investment Matrix

select 'Ashneer' as Shark ,sum(Ashneer_Amount_Invested) as total_amount_Inv , 
Round(avg(Ashneer_Equity_Taken_pct),2) as avg_equity_taken from
( select * from pitches where Ashneer_Equity_Taken_pct !=0) m
Union
select 'Namita' as keyy ,sum(Namita_Amount_Invested) as total_amount_Inv_by_Namita , 
Round(avg(Namita_Equity_Taken_pct),2) as avg_equity_taken_Namita from
( select * from pitches where Namita_Equity_Taken_pct !=0) k
Union
select 'Anupam' as keyy ,sum(Anupam_Amount_Invested) as total_amount_Inv_by_Anupam , 
Round(avg(Anupam_Equity_Taken_pct),2) as avg_equity_taken_Anupam from
( select * from pitches where Anupam_Equity_Taken_pct !=0) p
Union
select 'Vineeta' as keyy ,sum(Vineeta_Amount_Invested) as total_amount_Inv_by_Vineeta , 
Round(avg(Ashneer_Equity_Taken_pct),2) as avg_equity_taken_Vineeta from
( select * from pitches where Vineeta_Equity_Taken_pct !=0) m
Union
select 'Aman' as keyy ,sum(Aman_Amount_Invested) as total_amount_Inv_by_Aman , 
Round(avg(Aman_Equity_Taken_pct),2) as avg_equity_taken_Ashneer from
( select * from pitches where Aman_Equity_Taken_pct !=0) z
Union
select 'Peyush' as keyy ,sum(Peyush_Amount_Invested) as total_amount_Inv_by_Peyush , 
Round(avg(Peyush_Equity_Taken_pct),2) as avg_equity_taken_Peyush from
( select * from pitches where Peyush_Equity_Taken_pct !=0) v
Union
select 'Ghazal' as keyy ,sum(Ghazal_Amount_Invested) as total_amount_Inv_by_Ghazal , 
Round(avg(Ghazal_Equity_Taken_pct),2) as avg_equity_taken_Ghazal from
( select * from pitches where Ghazal_Equity_Taken_pct !=0) j ;
 
 ## Startup with biggest deal from each domain
 
 select * from 
 (select brand, sector,Amount_Invested_lakhs, 
 rank()over(partition by sector order by amount_invested_lakhs desc ) rnk from pitches) p
 where rnk=1