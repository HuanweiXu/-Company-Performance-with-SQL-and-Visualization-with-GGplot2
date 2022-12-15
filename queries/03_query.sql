select * from 
  (
   select A.last_name || ' ' || A.first_name as employee_full_name,
   A.title as employee_title,
   extract(year from A.hire_date) - extract(year from A.birth_date) as employee_age,
   (current_date -A.hire_date)/365 as employee_tenure, 
   B.last_name || ' ' || B.first_name as manager_full_name,
   B.title as manager_title
   from employees A, employees B
   where A.reports_to = B.employee_id
   union 
   select  last_name || ' ' || first_name as employee_full_name,
   title as employee_title,
   extract(year from hire_date) - extract(year from birth_date) as employee_age,
   (current_date - hire_date)/365 as employee_tenure,
   null as manager_full_name,
   null as manager_title from employees C
   where reports_to is null
   ) D
order by employee_age ,employee_full_name;