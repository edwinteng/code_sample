# A sample SQL script
# access to the database test
use test;

# show the tables in the database test
show tables;

# we have table ndx
# we want to see the number of records here
select count(*) from ndx;

# Then we want to create a database Business
create database Business;

use Business

# create a table called customer
create table CUSTOMER (Phone char(12),FirstName char(30), LastName
char(30), Email char(30));

# create another table called invoice
create table INVOICE (Number Integer, DateIn Date, DateOut Date,
TotalAmt Decimal(9,4), Phone char(12));

# create a table invoice_item
create table INVOICE_ITEM(Number Integer, Item Char(30), Quantity
Integer , UnitPrice Decimal(9,4));

# see what are inside in these tables
describe CUSTOMER;

describe INVOICE;

describe INVOICE_ITEM;

#insert records
insert into CUSTOMER (Phone,FirstName,LastName,Email) Values
(7341234567,'asad','hasan','asad@umich.edu');
insert into CUSTOMER (Phone,FirstName,LastName,Email) Values
(7345671234,
'Elmer','Lee','elmer@umich.edu');
insert into invoice (Number,DateIn,DateOut,TotalAmt,Phone)
Values(1,'2009
-09-01','2009-09-01',10,7345671234);
insert into invoice (Number,DateIn,DateOut,TotalAmt,Phone)
Values(2,'2009
-09-02','2009-09-02',20,7341234567);
insert into invoice_item (Number,Item,Quantity,UnitPrice) Values(1,'book'
,1,100);
insert into invoice_item (Number,Item,Quantity,UnitPrice) Values(2,'game'
,2,500);

# see records in different tables
select * from CUSTOMER;

select * from INVOICE;

select * from INVOICE_ITEM;

# SHow the invoice with DateIn after 2009-09-01
select * from INVOICE where DateIn > '2009-09-01';

# show all the unique items from invoice
select distinct item from INVOICE_ITEM;

#show the item which DateOut is before today
select distinct item from INVOICE_ITEM where Number in (select Number
from INVOICE where DateOut < now());


