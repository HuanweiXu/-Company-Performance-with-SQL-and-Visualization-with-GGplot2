select category_name,
supplier_region,
sum(unit_in_stock) as unit_in_stock,
sum(unit_on_order) as unit_on_order , 
sum(reorder_level) as reorder_level 
from (
       select c.category_name,
       s.country,
       p.unit_in_stock,
       p.unit_on_order,
       p.reorder_level,
        case 
	        when s.country in ('USA','Canada','Brazil') then 'America'
	        when s.country in ('UK','Spain','Sweden','Germany','Italy','Norway','France','Denmark','Netherlands','Finland') then 'Europe'
	        when s.country in ('Japan','Singapore') then 'Asia'
	        when s.country in ('Australia') then 'Oceania'
	        end as supplier_region	
	        from products p ,
	        suppliers s,
	        categories c 
	        where p.category_id =c.category_id and 
	        p.supplier_id =s.supplier_id
	    )fn
group by category_name,supplier_region
order by supplier_region,category_name,reorder_level;