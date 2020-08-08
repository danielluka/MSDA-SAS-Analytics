* define output destination *;
libname out '/folders/myfolders/data/';
* import and convert csv data *;
data orders_northwind_mod8;
	infile '/folders/myfolders/data/orders_northwind_mod8.csv' 
	dlm=',' 
	firstobs=2;
	input order_id customer_id $ customer_id_num employee_id territory_id product_id category_id unit_price quantity discount gross_sale discount_amt net_sale;
/* summary data files for bubbles */
/* product summary data*/
proc sql; 
  create table product as
  select product_id
  , sum(net_sale) as net_sale_sum
  , sum(quantity) as quantity_sum
  , mean(discount_amt) as mean_discount_amt
  from work.orders_northwind_mod8
  group by product_id;
quit;
/* employee summary data*/
proc sql; 
  create table employee as
  select employee_id
  , sum(net_sale) as net_sale_sum
  , sum(quantity) as quantity_sum
  , mean(discount_amt) as mean_discount_amt
  from work.orders_northwind_mod8
  group by employee_id;
quit;
/* territory summary data*/
proc sql; 
  create table territory as
  select territory_id
  , sum(net_sale) as net_sale_sum
  , sum(quantity) as quantity_sum
  , mean(discount_amt) as mean_discount_amt
  from work.orders_northwind_mod8
  group by territory_id;
quit;
/* comparison business question */
proc sgplot data=work.product noautolegend;
title "Bubble plot total net sale vs quantity by product";
bubble x=net_sale_sum y=quantity_sum size= mean_discount_amt/ group=product_id datalabel=product_id 
 transparency=0.4 datalabelattrs=(size=9 weight=bold) dataskin=crisp;
inset "Bubble size represents average discount amount";
run;
proc sgscatter  data = work.product ;
   plot net_sale_sum*quantity_sum 
   / datalabel = product_id group = product_id grid nolegend;
   title 'Net sales vs. quantity by product_id';
run; 
/* geography business question */
proc sgplot data=work.territory noautolegend;
title "Bubble plot total net sale vs quantity by territory";
bubble x=net_sale_sum y=quantity_sum size=mean_discount_amt/ group=territory_id datalabel=territory_id 
 transparency=0.4 datalabelattrs=(size=9 weight=bold) dataskin=crisp;
inset "Bubble size represents average discount amount";
run;
proc sgscatter  data = work.territory ;
   plot net_sale_sum*quantity_sum 
   / datalabel = territory_id group = territory_id grid nolegend;
   title 'Net sales vs. quantity by territory';
run; 
/* relational business question */
proc sgplot data=work.employee noautolegend;
title "Bubble plot total net sale vs quantity by employee";
bubble x=net_sale_sum y=quantity_sum size=mean_discount_amt/ group=employee_id datalabel=employee_id 
 transparency=0.4 datalabelattrs=(size=9 weight=bold) dataskin=crisp;
inset "Bubble size represents average discount amount";
run;
proc sgscatter  data = work.employee ;
   plot net_sale_sum*quantity_sum 
   / datalabel = employee_id group = employee_id grid nolegend;
   title 'Net sales vs. quantity by employee_id';
run; 
* Save sas7bdat dataset to destination *;
data out.orders_northwind_product;
	set work.product;
run;
* Save sas7bdat dataset to destination *;
data out.orders_northwind_territory;
	set work.territory;
run;
* Save sas7bdat dataset to destination *;
data out.orders_northwind_employee;
	set work.employee;
run;
