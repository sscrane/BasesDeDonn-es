-- une ’auto jointure’ (jointure de deux copies d’une même table)

-- what is the longest serving ship?

-- join voyages together, see the interval for each ship between first date_debut and last date_fini and find the max

SELECT v1.navireID
FROM voyages AS v1
JOIN voyages AS v2 ON v1.navireID = v2.navireID
WHERE ABS((v1.date_debut - v2.date_fin)) = (
    -- longest time interval for a ship
    SELECT MAX(ABS(v3.date_debut - v4.date_fin)) 
    FROM voyages AS v3
    JOIN voyages AS v4 ON v3.navireID = v4.navireID
);
