select c.category_name, 
case 
	when p.unit_price < 10 then '1. Below $10'
	when p.unit_price between 10 and 20 then '2. $10 - $20'
	when p.unit_price > 20 and p.unit_price <= 50 then '3. $20 - $50'
	when p.unit_price  > 50 then '4. Over $50'
end as price_range,
sum((o.unit_price - o.discount)*o.quantity)::decimal(10,2) as total_amount,
count(distinct order_id) as total_number_orders 
from order_details o,
products p, 
categories c 
where o.product_id = p.product_id 
and p.category_id = c.category_id 
group by c.category_name,price_range
order by category_name, price_range;
