SELECT
        P.e_product_code_display        AS "Artikelnummer", 
        E.description                   AS "Omschrijving", 
        P2.e_product_code_display       AS "Alternatief", 
        E2.description                  AS "Omschrijving", 
        A.dd_prod_prio                  AS "Prio"
FROM
        stb_data.dd_prod_product_alternative AS A
LEFT JOIN
        stb_data.dd_prod_product AS P
ON
        P.dd_prod_product_id = A.dd_prod_product_id
LEFT JOIN
        stb_data.dd_prod_description AS E
ON
        P.dd_prod_product_id = E.dd_prod_product_id AND E.language_key = 'nl'
LEFT JOIN
        stb_data.dd_prod_product AS P2
ON
        P2.dd_prod_product_id = A.dd_prod_product_id_alternative
LEFT JOIN
        stb_data.dd_prod_description AS E2
ON
        P2.dd_prod_product_id = E2.dd_prod_product_id AND E2.language_key = 'nl'
WHERE    A.owner_id = 8
ORDER BY
        P.e_product_code_display ASC
