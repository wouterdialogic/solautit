Select ROUND(CAST(pii.price_purchase_invoice AS NUMERIC),2) AS "InkoopFactuurPrijs"
from stb_data.dd_pur_invoice as pi
inner join stb_data.dd_pur_invoice_item as pii
on pi.dd_pur_invoice_id = pii.dd_pur_invoice_id
inner join stb_data.dd_prod_product as p
on p.dd_prod_product_id = pii.dd_prod_product_id
where pi.dd_pur_invoice_code LIKE '?'
and p.e_product_code_display LIKE '?'