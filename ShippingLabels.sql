WITH shipping AS (
	SELECT 
		sh.shipping_date,
		se.seller_name, 
		b.buyer_name,
		b.address AS buyer_address,
		b.city AS buyer_city,
		b.zipcode AS buyer_zipcode,
		CONCAT(sh.shipping_id,'-',
			   to_char(sh.purchase_date, 'YYYYMMDD'),'-', 
			   to_char(sh.shipping_date, 'YYYYMMDD'),'-',
			   b.buyer_id,'-',
			   se.seller_id) AS kode_resi	
	FROM shipping_table sh
	LEFT JOIN seller_table se
		ON sh.seller_id = se.seller_id
	LEFT JOIN buyer_table b
		ON sh.buyer_id = b.buyer_id
	WHERE shipping_date BETWEEN '2022-12-01' AND '2022-12-31'
	ORDER BY shipping_date
)

INSERT INTO shipping_summary
SELECT * FROM shipping


