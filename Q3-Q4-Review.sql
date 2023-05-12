WITH report AS (
	SELECT 
		s.purchase_date,
		CASE WHEN p.promo_name IS null THEN 'WITHOUT PROMO'
			ELSE p.promo_name
		END promo_code,
		COUNT(s.promo_id) AS total_transaction,
		SUM(s.quantity * m.price) AS total_sales,
		SUM(COALESCE(p.price_deduction, 0)) AS discount,
		SUM((s.quantity * m.price) - COALESCE(p.price_deduction, 0)) AS sales_after_promo
	FROM sales_table s
	LEFT JOIN marketplace_table m
		ON s.item_id = m.item_id
	LEFT JOIN promo_code p
		ON s.promo_id = p.promo_id
	WHERE purchase_date BETWEEN '2022-07-01' AND '2022-12-31'
	GROUP BY purchase_date, promo_code
	ORDER BY purchase_date
)

INSERT INTO q3_q4_review
SELECT 
	purchase_date,
	CASE WHEN promo_code = 'WITHOUT PROMO' THEN 'WITHOUT PROMO'
		ELSE 'PROMO'
	END promo_code,
	total_transaction,
	total_sales,
	discount,
	sales_after_promo
FROM report
	