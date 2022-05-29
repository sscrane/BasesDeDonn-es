-- deux requˆetes ´equivalentes exprimant une condition de totalit´e, l’une avec des sous requˆetes corr´el´ees

-- ports that have been visited by a ship from each continent 

-- where it doesnt exist that there exists a continent that hasn't visited the port
\echo
\echo Ports qui ont été visités par un navire de chaque continent 
\echo
SELECT DISTINCT x.port_noms
FROM (
    SELECT e.port_nom AS port_noms
    FROM etapes_transitoires AS e

    UNION 

    SELECT v.destination AS port_noms
    FROM voyages AS v
        
) AS x 
WHERE NOT EXISTS (
    SELECT * FROM nations AS n
    WHERE n.continent NOT IN 
    (
        -- select continents of ships visiting this port
        SELECT nat.continent 
        FROM etapes_transitoires AS e2
        JOIN navires AS n2 ON e2.navireID = n2.navireID
        JOIN capturer AS c ON n2.navireID = c.navireID
        JOIN nations AS nat ON c.nationalite = nat.nationalite
        WHERE e2.port_nom = x.port_noms
        AND c.date_of_capture = ( SELECT MAX(c5.date_of_capture) FROM capturer AS c5 WHERE c5.navireID = c.navireID AND c5.date_of_capture < e2.date_debut)  

        UNION

        SELECT nat.continent 
        FROM voyages AS v2
        JOIN navires AS n2 ON v2.navireID = n2.navireID
        JOIN capturer AS c ON n2.navireID = c.navireID
        JOIN nations AS nat ON c.nationalite = nat.nationalite
        WHERE v2.destination  = x.port_noms
        AND c.date_of_capture = ( SELECT MAX(c5.date_of_capture) FROM capturer AS c5 WHERE c5.navireID = c.navireID AND c5.date_of_capture < v2.date_debut)

    )
)
;