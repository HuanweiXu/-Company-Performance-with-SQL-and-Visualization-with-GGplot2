select product_name, unit_price::decimal(10,2) as product_unit_price 
from products 
where unit_price between 10 and 50 and 
discontinued = 0 
order by product_name;
