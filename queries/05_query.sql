
create table  previous_unit_price as
(
 select product_id,
 unit_price as previous_unit_price, 
 rank from
   (select product_id,
    unit_price, 
    order_date ,
    row_number () over (partition by product_id order by order_date) rank  
    from
     (
       select D.product_id ,
       D.order_id ,
       D.unit_price , 
       O.order_date 
       from order_details D, orders O 
       where D.order_id =O.order_id) a
     )b where rank =1
   );

create table  current_price as
(
  select product_id,
  unit_price as current_price, 
  rank from
  (
    select product_id,
    unit_price, 
    order_date ,
    row_number () over (partition by product_id order by order_date desc) rank  
    from
     (
      select D.product_id ,
      D.order_id ,
      D.unit_price , 
      O.order_date 
      from order_details D, orders O 
      where D.order_id =O.order_id) a
    )b 
   where rank =1
 );


create  table cur_pre_price as(
select c.product_id,
c.current_price::decimal(10,2),
p.previous_unit_price::decimal(10,2), 
((c.current_price / p.previous_unit_price -1)*100)::decimal(10,4) as percentage_increase 
from current_price c,previous_unit_price p
where c.product_id=p.product_id);

select * from
(
 select p.product_name,
 a.current_price,
 a.previous_unit_price,
 a.percentage_increase 
 from cur_pre_price a, products p
 where a.product_id = p.product_id
)fn 
where percentage_increase < 10 or percentage_increase > 30 
order by percentage_increase;