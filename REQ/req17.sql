--- Different ships leaving and arriving on the same days
\echo 
\echo Différents navires partant et arrivant les mêmes jours
\echo 
SELECT v1.navireID,v2.navireID,v1.date_debut,v1.date_fin 
FROM voyages v1, voyages v2 
WHERE v1.navireid <> v2.navireid 
AND v1.date_debut = v2.date_debut 
AND v1.date_fin = v2.date_fin;
