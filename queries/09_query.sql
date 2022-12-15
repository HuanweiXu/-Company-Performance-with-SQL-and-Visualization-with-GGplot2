
select e.last_name ||' '|| e.first_name as employee_full_name, 
e.title as employee_title , 
sum(unit_price*quantity)::decimal(10,2) as total_sale_amount_excluding_discount,
count(distinct o.order_id) as number_unique_orders ,
count(o.*) as number_orders,
round(cast (sum(unit_price*quantity)/count(distinct product_id) as numeric),2) as average_product_amount,
round(cast (sum(unit_price*quantity)/count(distinct d.order_id)as numeric),2) as average_order_amount,
sum(discount*quantity)::decimal(10,2) as total_discount_amount,
sum((unit_price - discount)*quantity)::decimal(10,2) as total_sale_amount_including_discount,
round(cast (sum(discount*quantity*100)/sum(unit_price*quantity) as numeric),2)  as total_discount_percentage
from orders o ,
order_details d , 
employees e 
where o.order_id = d.order_id and 
o.employee_id =e.employee_id 
group by e.last_name ||' '|| e.first_name,
e.title
order by sum((unit_price - discount)*quantity) desc;