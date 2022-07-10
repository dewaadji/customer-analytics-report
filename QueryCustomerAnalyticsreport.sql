/* 
	CUSTOMER ANALYTICS REPORT
*/

-- Cek Table
select * from orders_1 limit 5;
select * from orders_2 limit 5;
select * from customer limit 5;


-- ANALISIS PERTUMBUHAN PENJUALAN	
-- Total Penjualan dan Revenue Q1 & Q2
select sum(quantity) total_penjualan,
	sum(quantity*priceeach) revenue
from orders_1
where status = 'Shipped';

select sum(quantity) total_penjualan,
	sum(quantity*priceeach) revenue
from orders_2
where status = 'Shipped';

-- Persentase Keseluruhan
select quarter, 
	sum(quantity) total_penjualan,
	sum(quantity*priceeach) revenue
from(
	select *, '1' quarter
	from orders_1
	where status = 'Shipped'
	union
	select *, '2' quarter
	from orders_2
	where status = 'Shipped'
) as tabel_a
group by quarter;


-- CUSTOMER ANALYTICS
-- Pertambahan Jumlah Customer
select quarter, count(distinct(customerID)) total_customers
from (
  select customerID,
  	createDate,
  	quarter(createDate) quarter
  from customer
  where createDate between '2004-01-01' and '2004-06-30'
) as tabel_b
group by quarter;

-- Jumlah Customer Aktif Transaksi Setelah Transaksi Pertamanya
select quarter, count(distinct(customerID)) total_customers
from(
  select customerID,
  	createDate,
  	quarter(createDate) quarter
  from customer
  where createDate between '2004-01-01' and '2004-06-30'
) as tabel_b
where customerID in (select distinct(customerID) from orders_1
					union
					select distinct(customerID) from orders_2)
group by quarter;

-- Category Produk Yang Paling Banyak Dibeli di Q1 & Q2
select left(productCode,3) categoryID, count(distinct orderNumber) total_order, sum(quantity) totalPenjualan
from
(select productCode, orderNumber, quantity, status, left(productCode,3) categoryID
from orders_2
where status = 'Shipped') tabel_c
group by left(productCode,3)
order by count(distinct orderNumber) desc;

-- Customer Aktif Setelah Pembelian Pertamanya
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
#output = 25
select '1' quarter, (count(distinct customerID)*100)/25 as Q2 from orders_1
where customerID in (select distinct customerID from orders_2);