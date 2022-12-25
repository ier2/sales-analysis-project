-- Inspecting Data -- 

SELECT * FROM dbo.customerdata;

-- Data Cleaning -- 

-- checking distinct values --
select distinct "Customer Segment" from dbo.customerdata -- (Small Business, Home Office, Corporate, Consumer)
select distinct "State" from dbo.customerdata -- (48/50 States)
select distinct "Order Priority" from dbo.customerdata -- (High, Not Specified, Low, Critical, Medium)
select distinct "Number of Records" from dbo.customerdata
select distinct "Product Category" from dbo.customerdata -- (Office Supplies, Furniture, Technology) 
select distinct "Product Sub-Category" from dbo.customerdata -- (17 sub-categories) 
select distinct "Ship Mode" from dbo.customerdata -- (Regular Air, Express Air, Delivery Truck)
select distinct "Customer Name" from dbo.customerdata -- (795 Customers)
select distinct year("Order Date") from dbo.customerdata -- (2012-2015)
select distinct month("Order Date") from dbo.customerdata where year("Order Date") = 2012 -- (checking to see if all months are accounted for in each year)

-- Data Analysis -- 　

-- Sales sorted by product category --
select "Product Category", sum("Sales") as "Revenue"
from dbo.customerdata
group by "Product Category"
order by 2 desc


-- Product Category Profit --
select "Product Category", sum("Profit") as "Profit"
from dbo.customerdata
group by "Product Category"
order by 2 desc

-- Sales sorted by product sub category --
select "Product Sub-Category", sum("Sales") as "Revenue"
from dbo.customerdata
group by "Product Sub-Category"
order by 2 desc

-- Product Sub-Category Profit -- 
select "Product Sub-Category", sum("Profit") as "Profit"
from dbo.customerdata
group by "Product Sub-Category"
order by 2 desc

-- Sales sorted by customer segment -- 
select "Customer Segment", sum("Sales") as "Revenue"
from dbo.customerdata
group by "Customer Segment"
order by 2 desc

-- Sales sorted by year --
select year("Order Date") AS Year, sum("Sales") AS "Yearly Sales"
from dbo.customerdata
group by year("Order Date")
order by 2 desc

-- Sales sorted by region -- 
select "Region", sum("Sales") as "Revenue"
from dbo.customerdata
group by "Region"
order by 2 desc

-- Sales sorted by state -- 
select "State", sum("Sales") as "Revenue"
from dbo.customerdata
group by "State"
order by 2 desc

-- Sales sorted by top 10 individual customers per year --
select "Customer Name", sum("Sales") as "Revenue"
from dbo.customerdata
where year("Order Date") = 2015 -- change year to see others --
group by "Customer Name"
order by 2 desc
offset 0 rows fetch first 10 rows only;

-- Sales sorted by month -- 
select month("Order Date") as month, sum(Sales) as "Monthly Sales"
from dbo.customerdata
group by month("Order Date")
order by 2 desc

-- Which customer segment has the largest order quantites -- 
select "Customer Segment" as "Customer Segment", sum("Order Quantity") as "Sum of Order Quantity", sum(Sales) as "Revenue"
from dbo.customerdata
group by "Customer Segment"

-- Which product sub-category has corporate purchased the most? --
select "Customer Segment" as "Customer Segment", "Product Sub-Category", sum("Order Quantity") as "Sum of Order Quantity"
from dbo.customerdata
where "Customer Segment" like 'corporate' 
group by "Customer Segment", "Product Sub-Category"
order by 3 desc

-- Which product sub-category has been purchased the most? --
select "Product Sub-Category", sum("Order Quantity") as "Sum of Order Quantity"
from dbo.customerdata
group by "Product Sub-Category"
order by 2 desc


-- December is the highest month for sales, which product sub-category sold the most in that month? -- 
select month("Order Date") as month, "Product Sub-Category", "Product Category", sum(Sales) as "Monthly Sales"
from dbo.customerdata
where month("Order Date") = 12 
group by month("Order Date"), "Product Sub-Category", "Product Category"
order by 4 desc

-- Sorted revenue by age groups (40-49, 50-59, 60-69, etc.) --
SELECT 
    case when cast("Customer Age" as int) between 40 and 49 then '40-49' 
        when cast("Customer Age" as int) between 50 and 59 then '50-59'
        when cast("Customer Age" as int) between 60 and 69 then '60-69'
		when cast("Customer Age" as int) between 70 and 79 then '70-79'
        when cast("Customer Age" as int) between 80 and 89 then '80-89'
        when cast("Customer Age" as int) between 90 and 99 then '90-99'
            end as "Age Group"
    ,sum(Sales) AS "Revenue"
FROM dbo.customerdata
GROUP BY 
    case when cast("Customer Age" as int) between 40 and 49 then '40-49' 
        when cast("Customer Age" as int) between 50 and 59 then '50-59'
        when cast("Customer Age" as int) between 60 and 69 then '60-69'
		when cast("Customer Age" as int) between 70 and 79 then '70-79'
        when cast("Customer Age" as int) between 80 and 89 then '80-89'
        when cast("Customer Age" as int) between 90 and 99 then '90-99'
            end
order by 2 desc

-- Average days taken to ship based on ship mode-- 
select "Ship Mode",
avg(DATEDIFF(day, "Order Date", "Ship Date")) as "Days Taken to Ship"
from dbo.customerdata
group by "Ship Mode"