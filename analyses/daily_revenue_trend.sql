
SELECT
    created AS payment_date,
    SUM(amount) AS daily_revenue
FROM
    {{ source('stripe', 'payment')}}
WHERE
    status = 'success'
GROUP BY created
ORDER BY created