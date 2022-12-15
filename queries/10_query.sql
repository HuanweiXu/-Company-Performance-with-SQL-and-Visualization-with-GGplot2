

select c.category_name,
e.last_name ||' '|| e.first_name as employee_full_name,
t3.total_sale_amount::decimal(10,2) ,
round(t3.total_sale_amount/t1.em_total,5) as percent_of_employee_sales,
round(t3.total_sale_amount/t2.ca_total,5) as percent_of_category_sales
from
    (
     select o.employee_id ,
     sum((d.unit_price-d.discount)*d.quantity)::decimal(10,2) as em_total
     from order_details d,
     orders o
     where o.order_id =d.order_id
     group by o.employee_id
     )t1,
    (
     select p.category_id, 
     sum((d.unit_price-d.discount)*d.quantity)::decimal(10,2) as ca_total
     from products p,
     order_details d
     where d.product_id =p.product_id 
     group by p.category_id
     )t2,
    (
     select p.category_id, 
     e.employee_id ,
     sum((d.unit_price - d.discount)*d.quantity)::decimal(10,2) as total_sale_amount
     from employees e, 
     order_details d,
     products p ,
     orders o
     where  o.order_id = d.order_id and 
     o.employee_id =e.employee_id  and
     p.product_id =d.product_id 
     group by p.category_id ,
     e.employee_id
     order by p.category_id
     )t3,
employees e,
categories c
where  t1.employee_id = t3.employee_id  and 
t2.category_id=t3.category_id and 
c.category_id = t3.category_id and 
e.employee_id = t3.employee_id
order by category_name asc, total_sale_amount desc;
