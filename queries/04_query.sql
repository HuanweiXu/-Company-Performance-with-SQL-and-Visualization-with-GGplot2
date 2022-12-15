select * from 
(
   select year_month,count(*) as total_number_orders,
   sum(freight)::decimal(10,0) as total_freight from
    (
      select extract(year from order_date) ||'-' || extract(month from order_date) ||'-'|| '01' as year_month,
      * from 
        (
         select order_date,freight from orders where extract(year from order_date) between 1996 and 1997
         )o1 
     )o2
       group by year_month
) o3
where total_number_orders > 20 and total_freight >2500
order by total_freight desc;