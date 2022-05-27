-- deux requˆetes ´equivalentes exprimant une condition de totalit´e, l’une avec de l’agr´egation

-- ports that have been visited by a ship from each continent 

-- the count of ships from continents that have visited the port is the count of continents
\echo 
\echo Ports qui ont été visités par un navire de chaque continent 
\echo 
SELECT DISTINCT e.port_nom
FROM etapes_transitoires AS e
NATURAL JOIN navires AS n
JOIN capturer AS c ON n.navireID = c.navireID
JOIN nations AS nat ON c.nationalite = nat.nationalite
WHERE c.date_of_capture = ( SELECT MAX(c5.date_of_capture) FROM capturer AS c5 WHERE c5.navireID = c.navireID AND c5.date_of_capture < e.date_debut)   
GROUP BY e.port_nom
HAVING COUNT(DISTINCT nat.continent) =(
    SELECT COUNT(DISTINCT continent) FROM nations
)
;
