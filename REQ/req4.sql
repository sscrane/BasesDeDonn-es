--– une sous-requˆete dans le FROM ;

-- SELECT avg voyage time 

-- SELECT AVG(voyage_time) FROM (query that returns a column of all voyage times)
\echo Durée moyenne du voyage

SELECT AVG (voyage_length) FROM (
    SELECT ABS(v.date_debut - v.date_fin) AS voyage_length
    FROM voyages AS v
    ) AS x
;