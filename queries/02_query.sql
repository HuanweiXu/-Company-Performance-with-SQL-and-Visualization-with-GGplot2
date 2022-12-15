select * from 
(
select shipping_country, avg(days_between_order_shipping)::decimal(10,2) as average_days_between_order_shipping,
count(distinct order_id) as total_volume_orders from 
   (
      select ship_country as shipping_country, 
      shipped_date - order_date as days_between_order_shipping,
      order_id 
       from orders 
       where extract(year from order_date) = 1997
    ) a group by shipping_country 
) b 
where average_days_between_order_shipping>= 3 
and average_days_between_order_shipping <20
and total_volume_orders >5
order by average_days_between_order_shipping desc;