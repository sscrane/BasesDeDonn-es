-- une ’auto jointure’ (jointure de deux copies d’une même table)

-- which ship has the longest time between voyages (hard)/ what is the longest serving ship?(easy)

-- hard: join two voyages together, see the max interval between two consecutive date fini/date debut
-- easy: join voyages together, see the interval for each ship between first date_debut and last date_fini and find the max

SELECT v1.navireID
FROM voyages AS v1
JOIN voyages AS v2 ON v1.navireID = v2.navireID
WHERE ABS((v1.date_debut - v2.date_fin)) = (
    -- longest time interval for a ship
    SELECT MAX(ABS(v3.date_debut - v4.date_fin)) 
    FROM voyages AS v3
    JOIN voyages AS v4 ON v3.navireID = v4.navireID
);
