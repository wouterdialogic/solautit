select ROUND(CAST(spi.price_cash_sale AS NUMERIC),2) AS "Speciale prijs"
from stb_data.dd_cust_customer as c
inner join stb_data.dd_cust_spec_price as sp
on c.dd_cust_customer_id = sp.dd_cust_customer_id
inner join stb_data.dd_cust_spec_price_item as spi
on sp.dd_cust_spec_price_id = spi.dd_cust_spec_price_id
inner join stb_data.dd_prod_price as pp
on spi.dd_prod_product_id = pp.dd_prod_product_id
inner join stb_data.dd_prod_product as p
on spi.dd_prod_product_id = p.dd_prod_product_id
inner join stb_data.dd_prod_description as e
on p.dd_prod_product_id = e.dd_prod_product_id
where c.e_customer_code_display LIKE '?%'
and p.e_product_code_display LIKE '?%'
and spi.item_status = '?'
and E.language_key = '?'
