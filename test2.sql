SELECT v.navireid FROM voyages AS v 
JOIN navires AS n on v.navireid = n.navireid
JOIN etapes_transitoires AS e ON v.navireID = e.navireID AND v.date_debut = e.date_debut AND e.etape_numero = 1
JOIN ports_ AS p1 ON e.port_nom = p1.nom
JOIN ports_ AS p2 ON v.destination = p2.nom
WHERE p1.nom IN(
    SELECT nation1, nation2 FROM relations_diplomatiques AS r1 WHERE r1.relation_diplomatique = 'allies commerciaux'
    UNION 
    SELECT nation2, nation1 FROM relations_diplomatiques AS r2 WHERE r2.relation_diplomatique = 'allies commerciaux'
)

-- check for each voyage, if the ship is in "commercial allies" 
-- then the destination or etape 0 is it's country 
-- and destination or etape 0 is other country
