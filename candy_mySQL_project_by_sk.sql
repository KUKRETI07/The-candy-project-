										  ### SQL candy project 
create database mysql_pro;
use mysql_pro;


# all tables 
show tables;
select * from candy_factories;
select * from candy_products;
select * from  candy_sales;
select * from candy_targets;

select distinct region  from candy_sales;


                                     #### Updating some information in data
use mysql_pro;


set sql_safe_updates = 0;   # turning off safe mode of mySQL

UPDATE candy_sales
SET order_date = STR_TO_DATE('25-12-2024', '%d-%m-%Y');   # updating date fromate   

UPDATE candy_sales
SET ship_date = STR_TO_DATE('25-12-2024', '%d-%m-%Y'); 

show tables;
drop table candy_distributor_data_dictionary;           # droping some unwanted tables




								### Questions present on  maven website 
								
# Q1 What are the most efficient and least efficient  factory to customer shipping routes?    
select  distinct factory,ship_mode,round(sum(cost),1) as cost, (order_date - ship_date) as time 
 from candy_factories cross join candy_sales
group by factory,ship_mode,time 
order by cost,ship_mode desc ;

  #  on the "Same Day" "The Other Factory" with the cost of 2397.9
  #  on the "First Class" "The Other Factory" with the cost of 7273
  #  on the "Second Class" "The Other Factory" with the cost of 9410.9
  #  on the "Standard Class" "The Other Factory" with the cost of 28240.3
  
  
  # Q2 Which product lines have the best product margin?
  SET SESSION sql_mode = '';          # for this query only
  
select cp.product_name,  round((gross_profit / (sales*avg(cost))),2)*100 
as product_margin from candy_products as cp  
left join candy_sales  as cs on cp.division = cs.division 
group by cp.product_name
order by product_margin desc ;                       

# "Laffy Taffy" has highest product margin with "104" 
# "Lickable Wallpaper" has lowest product margin with "5" only                                  
                                  
                                  
                                  
                                  
                                  
                                  # analysing the data with some problems 
							
#Q1  which are the top 3 products that has higest sales and profit and what its  product cost ??
 select cp.product_name , sum(sales) as sales , gross_profit , city from candy_products as cp
 left join candy_sales as cs on cp.division = cs.division 
 group by cp.product_name,Gross_Profit ,city order by sales,Gross_Profit desc ;
 
### Laffy Taffy, SweeTARTS , Nerds are the top 3 products with sales with 1.5 each and gross profit is 0.7 with the citys of newyork , Jacksonville , Jackson

#Q2 what are the top 3 factory and in what region ?? and its  quantity and revenue
 
  select Factory , region ,units , division , round((sales*avg(cost)),2) as revenue from  candy_sales
  cross join  candy_factories
  group by Factory , region, units order by revenue,units desc ;
  
   ### The Other Factory in division in Pacific has highest revenue 4.03

#Q3 top and bottom  region that has hihest candy sell  with there sales and  from what factory

 select region , factory ,round(sum(sales),2) as candy_sales , sales   from candy_sales  
 cross join candy_factories 
 group by region , factory , sales order by candy_sales ;
 
 #in pacific The Other Factory is highest candy seller factory with total sales of "3153.6"  
 #in Gulf The Other Factory is lowest candy seller factory with total sales of only "1.5"  
 
 #Q4 each factory candy production , in what cities and its division 
 
 select city , division , factory ,units from candy_sales as cs 
cross  join  candy_factories 
group by city, division ,factory , units order by units desc ;



                                     # problem statements and its solutions 
				
#Q1 how can we hit our target profit?? 

select * from candy_targets;    # this is our target 

select distinct cs.division, round(sum(gross_profit),2) as current_sales  from candy_sales as  cs 
cross join candy_products as cp cross join candy_targets as ct 
group by division  ;                                 # this is our current sales
 
# we are already hits our sales and profit tagets with 
#Chocolate ="5805882.45", Other ="422246.25" ,Sugar="19236.6" in sales
#Chocolate ="3916352.25", Other ="4188705.25" ,Sugar="12812.85" in sales

  # And if we needed the more sales we have to focus on number of factories in each state of US 
  # and add some more divition in it ..for example strawberry,apple ,etc flavours .


#Q2 in which division we have high demand or low demand and its  products and in what city ?? 

select cs.division , cs.product_name , city , sum(units) as hight_and_low_demand_city from candy_sales as cs 
left join candy_products as cp on cp.division = cs.division 
group by cs.division ,  city , cs.product_name  order by hight_and_low_demand_city ;

# we have high demand in Chocolate division  "Wonka Bar -Scrumdiddlyumptious" is chocolate in  New York City  with "3895" units 
#we have low demand in Other in  "Lickable Wallpaper"  in  Franklin city   with "4" units only 

#Q3 what division and its top 3 products has highest revenue and from what city? and how many factory are in there ??

select cs.division , cp.product_name , city , count(cf.factory) as number_of_factory, (sales*avg(cost)) as revenue from candy_sales as cs
cross join candy_products as cp cross join candy_factories  as cf 
group by cs.division , cp.product_name,city order by revenue desc;

# in other division we have revenue with 5 factories and generating "24200" followed by Wonka Gum,Hair Toffee in La Crosse city 


#Q4 our top 3 countries and cities in terms of sales and how we can increse our profit in this counties and cities??

select  country , city , division, round(sum(sales),2) as sales , round(sum(gross_profit),2) as profit   from candy_sales
group by  country , city order by sales desc limit 3;

# we have New York City, Los Angeles, Philadelphia with sales of  "12514.9" , "10408.75" , "7415.52" 
# and profit  with "8240.51" , "6898.61" , "4813.82" in "Chocolate" division in United States


#Q5 in what division and product we are  less profitable or in loss?? and in what counties and cities ??

select country, division , product_name ,round(sum(sales),2) as sales from candy_sales 
group by  country, division , product_name order by sales limit 3;

# we are in less profitable in "sugar" division with productss of Fun Dip , Nerds , Laffy Taffy 
# with sales are "12" , "15" , "53.73" respectfully 








 