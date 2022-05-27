-- – une requˆete r´ecursive (par exemple pour reconstituer le trajet effectu´e par un certain 
-- bateau sur un laps de temps recouvrant des voyages diff´erents).

-- route taken by ship 1 from 2020/01/01 to 2022/01/01
\echo 
\echo le trajet emprunté par le navire 1 du 2020/01/01 au 2022/01/01
\echo 
WITH RECURSIVE nav_route(ville_départ, ville_arrivée) AS
(
SELECT * FROM voyages AS v
NATURAL JOIN etapes_transitoires AS e
WHERE v.navireID = 1
AND v.date_debut > '2020-01-01'
AND v.date_fin < '2022-01-01'

UNION ALL

SELECT V.ville_départ, A.ville_arrivée
FROM Vol V, nav_route A
WHERE V.ville_arrivée = A.ville_départ

)
SELECT * FROM nav_route
LIMIT 1000 ;