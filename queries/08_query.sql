select *, 
case 
	when unit_price  = average_unit_price then 'Average'
	when unit_price  > average_unit_price then 'Over Average'
	when unit_price < average_unit_price then 'Below Average'
end average_unit_price_position,
case 
	when unit_price  = median_unit_price then 'median'
	when unit_price  > median_unit_price then 'Over median'
	when unit_price  < median_unit_price then 'Below median'
end average_unit_price_position
from (
      select c.category_name,
      p.product_name ,
      p.unit_price::decimal(10,2) ,
      s.average_unit_price::decimal(10,2),
      s.median_unit_price::decimal(10,2)
      from
         (select category_ID,
          avg(unit_price) as average_unit_price, 
          percentile_cont(0.5) within group(order by unit_price) as median_unit_price 
          from  products  
          where discontinued = 0
          group by category_ID
         )s,
         (
          select category_ID,
          product_name ,
          unit_price 
          from products
          where discontinued = 0
          )p , 
          categories c 
          where c.category_id =p.category_id and 
          s.category_ID = c.category_id
         )fn
 order by category_name,product_name;

