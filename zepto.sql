Drop table if exist zepto;
CREATE table zepto(
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,20),
    availableQuantity INTEGER,
    disCountedSellingPrice NUMERIC (8,2),
    weightInGrams INTEGER,
    outOffStock  BOOLEAN,
    quantity INTEGER 
);

--data exploration

--count of rows
SELECT COUNT(*) zepto;

--sample data
 select * from zepto limit 10;
 
 --null valuse
select * from zepto
where name is null
or 
category is null
or
 mrp is null
or
discountpercent is null
or 
availablequantity is null 
or
discountedsellingprice is null 
or
weightingrams is null 
or
outoffstock is null 
or 
quantity is null;

 --different product categories 
 select distinct category 
from zepto 
order by category;

--product in stock vs out of stock 
select outOffStock, count(sku_id) 
from zepto group by outOffStock; 

--product names presents multiple times 
select name, count (sku_id) as "Number of SKUs" 
from zepto 
group by name having count(sku_id)> 1 
order by count(sku_id) desc; 

--data cleaning --product with price = 0 
select * from zepto 
where mrp=0 or disCountedSellingPrice =0; 
delete from zepto where mrp=0; 

--convert paise to rupees 
update zepto set mrp = mrp/100.0,
 disCountedSellingPrice = disCountedSellingPrice/100.0; 
select mrp , disCountedSellingPrice from zepto;

 --find the top 10 base-value products based on the discount percentage 
select distinct name,mrp, discountPercent 
from zepto 
order by discountPercent desc limit 10; 

--what are the products with high mrp but out of stock 
select distinct name, mrp 
from zepto 
where outoffstock = True and mrp > 300; 

--calculate estimate revenue of each category 
select category, 
sum(discountedsellingPrice * availableQuantity) as total_revenue
 from zepto group by category order by total_revenue; 
 
--find all product where mrp is grater than 500 and discount is less than 10%. 
select distinct name , mrp, discountPercent 
from zepto 
where mrp > 500 and discountPercent < 10 order by mrp , discountPercent ; 

--identify the top 5 categories offering the highest average discount percentage. 
select category, 
round(avg(discountPercent),2) as avg_discount 
from zepto 
group by category 
order by avg_discount desc limit 5; 

--find the price per gram for products above 100g and sort by best value. 
select distinct name , weightingrams,discountedSellingPrice, 
round(discountedSellingPrice/ weightingrams,2) as price_per_gram 
from zepto where weightingrams >= 100 
order by price_per_gram; 

-- group the products into categories like low, medium,bulk. 
select distinct name , weightingrams, 
case when weightingrams < 1000 then 'Low'
 when weightingrams < 5000 then 'Medium' 
 else 'Bulk' end as weight_category 
from zepto; 

-- what is the total inventory weight per category 
select category, 
sum(weightingrams * availablequantity) as total_weight 
from zepto group by category order by total_weight;
