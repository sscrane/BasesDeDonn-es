-- something random 
-- Get average volume per ship type per country 
-- Le volume moyen transporté par type de navire par pays
\echo
\echo Le volume moyen transporté par type de navire par pays
\echo
SELECT initial_propietaire, navire_type, ROUND(AVG(volume),2) AS average_volume FROM navires
GROUP BY initial_propietaire, navire_type
ORDER BY initial_propietaire, navire_type
;
