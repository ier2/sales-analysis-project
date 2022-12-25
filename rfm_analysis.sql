DROP TABLE IF EXISTS #rfm;
with rfm as
(Select 
		"Customer Name",
		Sum("Sales") 'Monetary',
		count("Order ID") 'Frequency',
		DATEDIFF(DD, MAX("Order Date"), (Select MAX("Order Date") from dbo.customerdata)) 'Recency'
	FROM dbo.customerdata
	where "customer segment" = 'corporate'
	Group by "Customer Name"),
rfm_calc as
(select r.*,
		NTILE(4) OVER (order by Recency desc) R,
		NTILE(4) OVER (order by Frequency) F,
		NTILE(4) OVER (order by Monetary) M
	from rfm r)

select c.*, R+F+M as rfm_sum,
cast(R as varchar)+cast(F as varchar)+cast(M as varchar)rfm_string
into #rfm
from rfm_calc c

Select "Customer Name", Recency, Frequency, Monetary, R, F, M, 
	case 
		when rfm_string in (111, 112, 113, 114, 121, 122, 123, 131, 132, 141, 142, 211) then 'Lost'  --lost customers
		when rfm_string in (133, 134, 143, 144, 124) then 'Cant Lose Them' -- Big spenders who haven’t purchased lately, but should look to reconnect with
		when rfm_string in (212, 213, 214, 221, 222, 223, 224, 231, 232, 233, 234, 241, 242, 243, 244) then 'At Risk' -- Purchased somewhat recently, but beginning to slip away
		when rfm_string in (411, 412, 413, 414, 421, 422) then 'New Customers'
		when rfm_string in (311, 312, 313, 314, 321, 322, 323, 331, 332, 333, 341, 342, 431, 441) then 'Active' -- Customers who buy often & recently, but either in lower quantities/price points
		when rfm_string in (343, 423, 424, 334, 432, 433, 442, 324) then 'Potential Loyalist' -- Customers who arent quite top tier, but close to being so
		when rfm_string in (443, 444, 434, 344) then 'Loyalist' -- Top Tier Customers
	end 'Customer Segments'
from #rfm	
order by 1, 3 desc