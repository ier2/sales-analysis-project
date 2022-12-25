--rfm analysis--
with dataset AS (
Select "Customer Name", "Order ID", "Order Date", "Sales"
from dbo.customerdata
where "customer segment" = 'corporate'
),

--select "Customer Name", "Order ID", "Order Date", "Sales",
--count("Order ID") over(partition by "Customer Name", "Order ID")
--from dataset

"Order Summary" AS (
select "Customer Name", "Order ID", "Order Date", 
sum("sales") as 'Total Sales'
from dataset
group by "Customer Name", "Order ID", "Order Date"
)

select
"Customer Name", 
--(select MAX("Order Date") from "Order Summary") as 'Max Order Date',
--(select MAX("Order Date") from "Order  Summary" where "Customer Name" = t1."Customer Name") as 'Max Customer Order Date'
DateDiff(day, (select MAX("Order Date") from "Order Summary" where "Customer Name" = "Customer Name"), (select MAX("Order Date") from "Order Summary")) as 'Recency (Days)',
count("Order ID") as 'Frequency',
sum("Total Sales") as 'Monetary',

NTILE(3) over (order by DateDiff(day, (select MAX("Order Date") from "Order Summary" where "Customer Name" = "Customer Name"), (select MAX("Order Date") from "Order Summary")) desc) as 'R', 
NTILE(3) over (order by count("Order ID") asc) 'F',
NTILE(3) over (order by sum("Total Sales") asc) 'M'


from "Order Summary"
group by "Customer Name"
ORDER BY 1, 3 DESC