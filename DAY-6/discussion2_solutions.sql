-- Creating new database
create database discussions2;

--using the newly created database
use discussions2;


-- Creating productlines table
create table productlines(productLine int not null auto_increment,textDescription varchar(255), htmlDescription varchar(255), image varbinary(1000), constraint PK_productlines primary key (productLine));

-- Creating offices table
create table offices(officeCode int not null auto_increment primary key, city varchar(30) not null, phone int not null unique, addressLine1 varchar(100) not null, addressLine2 varchar(100) default null, state varchar(30) not null, country varchar(30) not null, postalCode int not null,territory varchar(20) not null);

-- Creating employees table
create table employees(employeeNumber int not null auto_increment, lastName varchar(50), fisrtName varchar(50) not null, extension varchar(50), email varchar(75) not null, officeCode int, reportsTo int, jobTitle varchar(50), primary key(employeeNumber), foreign key(officeCode) references offices(officeCode), foreign key(reportsTo) references employees(employeeNumber));

-- Creating customers table
create table customers(customerNumber int not null auto_increment, customerName varchar(60) not null, contactLastName varchar(30), contactFirstName varchar(30), phone int not null unique, addressLine1 varchar(100) not null, addressLine2 varchar(100), city varchar(20), state varchar(20), postalCode int not null, country varchar(30), salesRepEmployeeNumber int, creditLimit decimal(12,2), constraint PK_customers primary key (customerNumber), constraint FK_employees_customers foreign key(salesRepEmployeeNumber) references employees(employeeNumber));

-- Creating payments table
create table payments(customerNumber int not null, checkNumber int not null unique, paymentDate datetime not null, amount decimal(12,2) not null, constraint PK_payments primary key (checkNumber), constraint FK_customers_payments foreign key(customerNumber) references customers(customerNumber));

-- Creating products table
create table products(productCode int not null auto_increment, productName varchar(75) not null, productLine int not null, productScale varchar(30), productVendor varchar(50) not null, productDescription varchar(100), quantityInStock int not null, buyPrice decimal(12,2) not null, MSRP decimal(12,2) not null, constraint PK_products primary key(productCode), constraint FK_productlines_products foreign key(productLine) references productlines(productLine));

-- Creating orders table
create table orders(orderNumber int not null, orderDate datetime not null, requiredDate datetime, shippedDate datetime not null, status varchar(50), comments varchar(75), customerNumber int not null, primary key(orderNumber), foreign key(customerNumber) references customers(customerNumber));
    
-- Creating orderdetails table
create table orderDetails(orderNumber int not null, productCode int not null, quantityOrdered int not null, priceEach decimal(12,2) not null, orderLineNumber int, constraint FK_orderdetails_orders foreign key(orderNumber) references orders(orderNumber), constraint FK_orderdetails_products foreign key(productCode) references products(productCode));