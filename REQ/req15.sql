-- in 2020, how many of each type of ship 

-- En 2020, combien de navire de chaque type ont été utilisé
\echo 
\echo  En 2020, combien de navire de chaque type ont été utilisé
\echo 
SELECT n.navire_type, COUNT(navire_type) FROM voyages v
JOIN navires AS n on v.navireid = n.navireid
WHERE date_debut > '2020-01-01' AND date_debut < '2020-12-31'
GROUP BY navire_type
;
