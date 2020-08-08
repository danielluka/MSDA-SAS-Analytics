* define output destination *;
libname out '/folders/myfolders/data/';
* Import and convert CSV data *;
data orders_northwind_mod8;
	infile '/folders/myfolders/data/orders_northwind_mod8.csv' 
	dlm=',' 
	firstobs=2;
	input order_id customer_id $ customer_id_num employee_id territory_id product_id category_id unit_price quantity discount gross_sale discount_amt net_sale;
/* DESCRIPTIVE STATISTICS */
/* summary statistics and correlation matrix for continuous variables */
proc corr data = work.orders_northwind_mod8;
/* exclude customer_id variable as it's unique and text */
var unit_price quantity discount gross_sale discount_amt net_sale;
run;
/* detailed distribution statistics */
proc univariate data=work.orders_northwind_mod8;
histogram order_id customer_id_num employee_id territory_id product_id category_id unit_price quantity discount gross_sale discount_amt net_sale / vaxislabel="Percent of Observations";
run;
/* PREDICTIVE STATISTICS */
/* regression for continuous */
proc reg data=work.orders_northwind_mod8 ;
	title "Linear Regression net sales vs discount amount";
	model net_sale = discount_amt;
	run;
proc reg data=work.orders_northwind_mod8 ;
	title "Linear Regression net sales vs unit price";
	model net_sale = unit_price;
	run;
proc reg data=work.orders_northwind_mod8;
	title "Linear Regression net sales vs discount amount and unit price";
	model net_sale = unit_price discount_amt;
	run;
proc reg data=work.orders_northwind_mod8 ;
	title "Linear Regression quantity vs discount amount";
	model quantity = discount_amt;
	run;
proc reg data=work.orders_northwind_mod8 ;
	title "Linear Regression quantity vs unit price";
	model quantity = unit_price;
	run;
proc reg data=work.orders_northwind_mod8;
	title "Linear Regression quantity vs discount amount and unit price";
	model quantity = unit_price discount_amt;
	run;
/* ANOVA for categorical */
proc anova data=work.orders_northwind_mod8 ;
	title "ANOVA net sales vs territory";
	class territory_id;
	model net_sale = territory_id;
	run;
proc anova data=work.orders_northwind_mod8 ;
	title "ANOVA quantity vs territory";
	class territory_id;
	model quantity = territory_id;
	run;
proc anova data=work.orders_northwind_mod8 ;
	title "ANOVA net sales vs employee";
	class employee_id;
	model net_sale = employee_id;
	run;
proc anova data=work.orders_northwind_mod8 ;
	title "ANOVA quantity vs employee";
	class employee_id;
	model quantity = employee_id;
	run;
proc anova data=work.orders_northwind_mod8 ;
	title "ANOVA net sales vs product";
	class product_id;
	model net_sale = product_id;
	run;
proc anova data=work.orders_northwind_mod8 ;
	title "ANOVA quantity vs product";
	class product_id;
	model quantity = product_id;
	run;
/* r squared analysis */
proc rsquare data=work.orders_northwind_mod8;
title "r squared quantity analysis";
	model quantity = territory_id employee_id product_id discount_amt discount unit_price;
run;
proc rsquare data=work.orders_northwind_mod8;
title "r squared net sales analysis";
	model net_sale = territory_id employee_id product_id discount_amt discount unit_price;
run;
* Save sas7bdat dataset to destination *;
data out.orders_northwind_mod8;
	set work.orders_northwind_mod8;
run;