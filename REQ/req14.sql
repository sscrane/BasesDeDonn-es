-- – une requˆete r´ecursive (par exemple pour reconstituer le trajet effectu´e par un certain 
-- bateau sur un laps de temps recouvrant des voyages diff´erents).

-- route taken by ship 1 from 2020/01/01 to 2022/01/01

\echo 
\echo Le trajet emprunté par le navire 1 du 2020/01/01 au 2022/01/01
\echo 


-- voyage 1 destination

-- etape 1 voyage 2 starting port 

WITH RECURSIVE nav_route(port_depart, port_arrive,date_departure) AS
(
SELECT e.port_nom AS port_depart, v.destination AS port_arrive, v.date_debut AS date_departure FROM voyages AS v
NATURAL JOIN etapes_transitoires AS e
WHERE v.navireID = 1
AND e.etape_numero = 1
AND v.date_debut >= (SELECT MIN(v2.date_debut) FROM voyages AS v2 WHERE navireID = 1 AND v2.date_debut > '2019-12-31')

UNION ALL

SELECT v.destination AS port_depart, A.port_arrive AS port_arrive, v.date_debut AS date_departure
FROM voyages AS v NATURAL JOIN etapes_transitoires AS e, nav_route A
WHERE e.port_nom = A.port_depart
AND e.etape_numero = 1
AND v.navireID = 1
AND v.date_fin < '2022-01-01'
AND v.date_debut NOT IN (date_departure)

)
SELECT * FROM nav_route
LIMIT 10 ;