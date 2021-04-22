#Convertir de CSV to SQL
create database order_product_db;
use order_product_db;

create table order_product(
order_id varchar(32), #valor repetido
product_id varchar(32),
quantity decimal(14,8),
quantity_found decimal(14,8),
buy_unit text(2)
); #Se crea el nombre de la tabla con sus atributos y tipos de datos

DESCRIBE order_product;
#DROP TABLE order_product; 

/*
#PAra correr mysql desde terminal
#mysql -u root -p
#You may check the local_infile is disabled or enable. So, you try this-
#SHOW GLOBAL VARIABLES LIKE 'local_infile';
#then enable with this-
#SET GLOBAL local_infile = 1;
#use order_product_db;

#exit
#mysql --local_infile=1 -u root -ppassword DB_name

#SHOW GLOBAL VARIABLES LIKE 'local_infile' => debe estar en ON


#SHOW VARIABLES LIKE "secure_file_priv"; #Mostrara la URL donde se alojaran los archivos para subirlos.
#Se deben dejar los archivos en esa URL, en mi caso C:\ProgramData\MySQL\MySQL Server 8.0\Uploads

*/

#https://platzi.com/tutoriales/1272-sql-mysql/6354-cargar-datos-por-archivos-csv-o-de-texto-desde-la-terminal-y-solucion-error-gt-error-1290-hy000/

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_product.csv' into table order_product
fields terminated by ','
lines terminated by '\n'
ignore 1 lines 
(order_id,product_id,quantity,quantity_found,buy_unit);

#https://www.journaldev.com/16774/sql-data-types
#http://www-db.deis.unibo.it/courses/TW/DOCS/w3schools/sql/sql_datatypes_general.asp.html


create table orders(
order_id varchar(32), #no debe estar vacia ya que es llave primaria
lat decimal(22,15),
lng decimal(22,15),
dow int(2), 
promised_time time,
actual_time time,
on_demand text, #Valor booleano
picker_id varchar(32),
driver_id varchar(32),
store_branch_id varchar(32),
total_minutes decimal(14,7),
primary key (order_id)
); #Se crea el nombre de la tabla con sus atributos y tipos de datos
#http://dbadixit.com/permitir-valores-nulos-sql-server-create-table-alter-table/

#DROP TABLE orders;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv' into table orders
fields terminated by ','
lines terminated by '\n'
ignore 1 lines 
(order_id,lat,lng,dow,promised_time,actual_time,on_demand,picker_id,driver_id,store_branch_id,@vtotal_minutes)
SET total_minutes = NULLIF(@vtotal_minutes,'');

#########################################################################
#Shoppers
create table shoppers(
shopper_id varchar(32),
seniority varchar(32),
found_rate decimal(10,4),
picking_speed decimal(7,4),
accepted_rate decimal(7,4),
rating decimal(7,4)
); #Se crea el nombre de la tabla con sus atributos y tipos de datos

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/shoppers.csv' into table shoppers
fields terminated by ','
lines terminated by '\n'
ignore 1 lines 
(shopper_id,seniority,@vfound_rate,picking_speed,@vaccepted_rate,@vrating)
SET 
rating = NULLIF(@vrating,''),
accepted_rate = NULLIF(@vaccepted_rate,''),
found_rate = NULLIF(@vfound_rate,'');

#########################################################################
#Storebranch
create table storebranch(
store_branch_id varchar(32),
store varchar(32),
lat decimal(22,15),
lng decimal(22,15)
); #Se crea el nombre de la tabla con sus atributos y tipos de datos

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/storebranch.csv' into table storebranch
fields terminated by ','
lines terminated by '\n'
ignore 1 lines 
(store_branch_id,store,lat,lng);
##################################################################################################
#Calculate the number of orders per day of the week, distinguishing if the orders are on_demand.
select dow,count(distinct order_id) from orders where on_demand= "true" group by dow order by dow;
#el peak de entregas se realizan entre los dias lunes y jueves. Siendo el martes el dia mas alto.

##################################################################################################
#Calculate the average quantity of distinct products that each order has, grouped by store
#Hacer join entre orders y order_product
#select order_id, buy_unit,avg(quantity) as promedio_quantity_request,avg(quantity_found) as promedio_quantity_found from order_product group by order_id, buy_unit;

#select order_id, buy_unit, avg(quantity) as promedio_quantity_request, avg(quantity_found) as promedio_quantity_found from order_product group by order_id, buy_unit;

/*
WITH Resumen AS (select order_id, buy_unit, avg(quantity) as promedio_quantity_request, avg(quantity_found) as promedio_quantity_found from order_product group by order_id, buy_unit)
SELECT orders.store_branch_id, orders.order_id, avg(Resumen.promedio_quantity_request)
FROM orders
INNER JOIN order_product ON order_product.order_id=orders.order_id
group by orders.order_id, orders.store_branch_id;
*/

/*
SELECT orders.store_branch_id, orders.order_id, count(order_product.product_id) as conteo_producto
FROM orders
INNER JOIN order_product ON order_product.order_id=orders.order_id
group by orders.order_id, orders.store_branch_id;
*/

/*
WITH resumen AS (select orders.store_branch_id, orders.order_id, count(order_product.product_id))
select store_branch_id, count(order_product.product_id) #conteo_producto
FROM orders
INNER JOIN order_product ON order_product.order_id=orders.order_id
group by orders.store_branch_id;
*/


select store_branch_id, order_product.buy_unit,format(avg(order_product.quantity),2) as avg_quantity_request #conteo_producto
FROM orders
INNER JOIN order_product ON order_product.order_id=orders.order_id
group by orders.store_branch_id, order_product.buy_unit;


#SELECT orders.store_branch_id, avg(Resumen.promedio_quantity_request);




#Se deberia distinguir entre UN y KG, debido a que tienen distinta unidad de medida
#https://stackoverflow.com/questions/32941122/sql-join-two-tables-and-calculate-average
#https://stackoverflow.com/questions/38229899/sql-join-two-tables-with-avg

##################################################################################################

#Calculate the average found rate(*) of the orders grouped by the product format and day of the week.
#(*) Found Rate = ratio between the quantity product found vs the number of products ordered by the customer.

#Matriz con el resumen de las order_product. Con las columnas order_id, buy_unit, quantity found and quantity
#select order_id, buy_unit,sum(quantity) as suma_quantity_request,sum(quantity_found) as suma_quantity_found from order_product group by order_id, buy_unit;

WITH Resumen_order_product AS (select order_id, buy_unit,sum(quantity) as suma_quantity_request,sum(quantity_found) as suma_quantity_found from order_product group by order_id, buy_unit)
SELECT orders.dow, Resumen_order_product.buy_unit, format(avg(100*(Resumen_order_product.suma_quantity_found/Resumen_order_product.suma_quantity_request)),1) as avg_found_vs_request
FROM orders
Left JOIN Resumen_order_product ON orders.order_id=Resumen_order_product.order_id
group by dow, buy_unit
order by dow;

#Se despachan mas kg que unidades. En los extremos de la semana se despacha mas kg que el dia miercoles. 
#En el caso de las unidades el dia miercoles es el peak de despacho

#########################################################################
#Calculate the average error and mean squared error of our estimation model for each hour of the day.
#https://stackoverflow.com/questions/14987317/how-to-reuse-a-sub-query-in-sql

WITH Resumen_order_product AS (select order_id, buy_unit,sum(quantity) as suma_quantity_request,sum(quantity_found) as suma_quantity_found from order_product group by order_id, buy_unit)
SELECT orders.dow, hour(orders.actual_time) as hora, format(100*(Resumen_order_product.suma_quantity_found/Resumen_order_product.suma_quantity_request),1) as found_vs_request
FROM orders
Left JOIN Resumen_order_product ON orders.order_id=Resumen_order_product.order_id
group by dow,hora 
order by dow,hora;

/*
WITH Resumen_order_product AS (select order_id, buy_unit,sum(quantity) as suma_quantity_request,sum(quantity_found) as suma_quantity_found from order_product group by order_id, buy_unit)
SELECT orders.dow, hour(orders.actual_time) as hora, format(AVG(ABS(Resumen_order_product.suma_quantity_found - Resumen_order_product.suma_quantity_request)),2) as RMSE_found_request
FROM orders
Left JOIN Resumen_order_product ON orders.order_id=Resumen_order_product.order_id
group by dow,hora 
order by dow,hora;
*/

#Mean Square error y average error
WITH Resumen_order_product AS (select order_id, buy_unit,sum(quantity) as suma_quantity_request,sum(quantity_found) as suma_quantity_found from order_product group by order_id, buy_unit)
SELECT orders.dow, hour(orders.actual_time) as hora, format(AVG(power(Resumen_order_product.suma_quantity_found - Resumen_order_product.suma_quantity_request,2)),2) as MSE_found_request, format(AVG(Resumen_order_product.suma_quantity_found - Resumen_order_product.suma_quantity_request),2) as ME_found_request
FROM orders
Left JOIN Resumen_order_product ON orders.order_id=Resumen_order_product.order_id
group by dow,hora 
order by dow,hora;

/*
#Average error
WITH Resumen_order_product AS (select order_id, buy_unit,sum(quantity) as suma_quantity_request,sum(quantity_found) as suma_quantity_found from order_product group by order_id, buy_unit)
SELECT orders.dow, hour(orders.actual_time) as hora, format(AVG(Resumen_order_product.suma_quantity_found - Resumen_order_product.suma_quantity_request),2) as MSE_found_request
FROM orders
Left JOIN Resumen_order_product ON orders.order_id=Resumen_order_product.order_id
group by dow,hora 
order by dow,hora;
*/
#########################################################################
#Calculate the number of orders in which the picker_id and driver_id are different.
/*
select 
if(orders.picker_id = orders.driver_id,"igual","no igual") as driver_igual_picker
from orders;
*/

#https://learnsql.com/blog/case-when-with-sum/


select
case
	when orders.picker_id = orders.driver_id
		then "Picker = driver"
		else "Picker <> driver"
end as driver_igual_picker,
count(case
	when orders.picker_id = orders.driver_id
		then 1
		else 0
end) as driver_comparacion_picker
from orders
group by driver_igual_picker;




/*
select orders.order_id,orders.dow,
if(orders.picker_id = orders.driver_id,1,0)
as Ordenes_driver_igual_picker
from orders;

select orders.dow,sum(Ordenes_driver_igual_picker) as suma 
from orders
group by dow, Ordenes_driver_igual_picker;

#select orders.driver_id,orders.picker_id,
#case 
#when  orders.picker_id <> orders.driver_id then "distintos"
#when  orders.picker_id = orders.driver_id then "iguales" 
#end as comparacion
#from orders;
*/