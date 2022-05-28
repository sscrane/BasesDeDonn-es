\echo
\echo REQUETE 1: Le pourcentage déspace de cargo dun navire spécific qui est utilisé pendant une etape
\echo

SELECT q.navireid, q.etape_numero, q.date_debut, SUM(q.quantite * p.volume),
ROUND(AVG(n.volume ), 2) AS volume, ROUND(SUM(q.quantite * p.volume)/AVG(n.volume ), 2) AS capacity_filled
FROM quantite q
   JOIN (
   SELECT p.produitsid, per.volume, p.nom FROM produits p
   JOIN perissable AS per on p.produitsid = per.produitsID
   UNION
   SELECT p.produitsid, s.volume, p.nom FROM produits p
   JOIN sec AS s on p.produitsid = s.produitsID
   )
   AS p ON q.produitsID = p.produitsID
JOIN navires AS n ON q.navireid = n.navireid
GROUP BY q.navireid, q.etape_numero, q.date_debut
ORDER BY q.navireid
;

\echo
\echo REQUETE 2: Déterminer le navire ayant le plus dancienneté (la plus longue durée entre le premier et le dernier voyage)
\echo
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

\echo
\echo REQUETE 3: Les ports qui reçoivent des navires de chaque catégorie de taille.
\echo
SELECT DISTINCT e.port_nom
FROM etapes_transitoires AS e
WHERE NOT EXISTS (
    SELECT DISTINCT n.taille_categorie FROM navires AS n
    WHERE n.taille_categorie NOT IN (
        -- select taille categories at this port
        SELECT DISTINCT n1.taille_categorie FROM 
        etapes_transitoires AS e2 
        JOIN navires AS n1 ON e2.navireID = n1.navireID
        AND e.port_nom = e2.port_nom
    )

)
;

\echo
\echo REQUETE 4: Durée moyenne du voyage
\echo
SELECT AVG (voyage_length) FROM (
    SELECT ABS(v.date_debut - v.date_fin) AS voyage_length
    FROM voyages AS v
    ) AS x
;

\echo
\echo REQUETE 5: Les produits dont le volume est supérieur au volume moyen.
\echo
SELECT p.nom, e.volume 
FROM produits p, perissable e 
WHERE p.produitsid = e.produitsid 
AND e.volume > (SELECT AVG(volume) FROM perissable); 


\echo
\echo REQUETE 6: Sélectionnez les produits pour lesquels la somme de cette quantité déplacée au cours de chaque étape du voyage 
\echo est supérieure que la quantité moyenne de chaque produit déplacé au cours de chaque étape
\echo
SELECT p.nom, SUM(q.quantite) FROM quantite q
JOIN produits AS p ON q.produitsid = p.produitsid
GROUP BY p.nom HAVING SUM(q.quantite) > (SELECT AVG(quantite) FROM quantite)
;

\echo
\echo REQUETE 7: Le volume moyen transporté par type de navire par pays
\echo
SELECT initial_propietaire, navire_type, ROUND(AVG(volume),2) AS average_volume FROM navires
GROUP BY initial_propietaire, navire_type
ORDER BY initial_propietaire, navire_type
;

\echo
\echo REQUETE 8: Sélectionnez une moyenne de la longueur maximale des voyages pour chaque taille de navire. 
\echo
SELECT AVG(max_lengths) 
FROM (
    -- max voyages for each size of ship
    SELECT MAX(ABS(v.date_debut - v.date_fin)) AS max_lengths, n.taille_categorie
    FROM voyages AS v
    JOIN navires AS n ON v.navireID = n.navireID
    GROUP BY n.taille_categorie

) 

AS x;


\echo
\echo REQUETE 9: Créer une liste des ports visités dans lordre chronologique
\echo
--Chronological port order, but all ports
SELECT DISTINCT p.nom, v.date_debut 
FROM ports_ p 
LEFT JOIN voyages v ON p.nom = v.destination 
ORDER BY v.date_debut ASC ;


\echo
\echo REQUETE 10: Ports qui ont été visités par un navire de chaque continent 
\echo
SELECT DISTINCT e.port_nom
FROM etapes_transitoires AS e
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
        WHERE e2.port_nom = e.port_nom
        AND c.date_of_capture = ( SELECT MAX(c5.date_of_capture) FROM capturer AS c5 WHERE c5.navireID = c.navireID AND c5.date_of_capture < e2.date_debut)   
    )
)
;

\echo 
\echo REQUETE 11: Ports qui ont été visités par un navire de chaque continent 
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

\echo 
\echo REQUETE 14: Le trajet emprunté par le navire 1 du 2020/01/01 au 2022/01/01
\echo 

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

\echo 
\echo  REQUETE 15: En 2020, combien de navire de chaque type ont été utilisé
\echo 
SELECT n.navire_type, COUNT(navire_type) FROM voyages v
JOIN navires AS n on v.navireid = n.navireid
WHERE date_debut > '2020-01-01' AND date_debut < '2020-12-31'
GROUP BY navire_type
;

\echo 
\echo REQUETE 16: Selectionner les produits périssables qui durent le plus longtemps
\echo 

SELECT p.produitsid,p.nom, per.date_conservation 
FROM produits p 
JOIN perissable AS per ON p.produitsid = per.produitsid 
WHERE per.date_conservation = (SELECT MAX(date_conservation) FROM perissable);


\echo 
\echo REQUETE 17: Différents navires partant et arrivant les mêmes jours
\echo 
SELECT * FROM voyages v1, voyages v2 
WHERE v1.navireid <> v2.navireid 
AND v1.date_debut = v2.date_debut 
AND v1.date_fin = v2.date_fin;

\echo 
\echo REQUETE 18: La nation qui a été en guerre avec le plus de nations
\echo

SELECT (nation_res) FROM (
    
SELECT r1.nation1 AS nation_res
FROM relations_diplomatiques AS r1
WHERE r1.relation_diplomatique = 'en guerre'

UNION ALL

SELECT r1.nation2 AS nation_res
FROM relations_diplomatiques AS r1
WHERE r1.relation_diplomatique = 'en guerre') AS x

GROUP BY nation_res
ORDER BY COUNT(nation_res) DESC
LIMIT 1
;

\echo
\echo REQUETE 19: La durée maximale dun voyage pour chaque pays dEurope 
\echo

SELECT MAX(ABS(v.date_debut-v.date_fin)), c.nationalite
FROM voyages AS v
JOIN capturer AS c ON v.navireID = c.navireID 
JOIN nations AS n ON c.nationalite = n.nationalite
WHERE c.date_of_capture = (
    SELECT MAX(c2.date_of_capture)
    FROM capturer AS c2
    WHERE c2.navireID = c.navireID
)
GROUP BY (c.nationalite, n.continent)
HAVING n.continent = 'Europe'
;

\echo
\echo REQUETE 20: La quantité de produits reçus par chaque pays
\echo
SELECT port.nationalite, p.nom, SUM(q.quantite)
FROM quantite q
JOIN voyages v ON q.date_debut = v.date_debut AND q.navireid = v.navireid
JOIN produits p ON q.produitsID = p.produitsID
JOIN navires n ON q.navireid = n.navireid
JOIN ports_ port ON v.destination = port.nom
WHERE q.etape_numero = 1
GROUP BY port.nationalite, p.nom
;
