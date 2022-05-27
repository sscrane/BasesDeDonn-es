SELECT v.navireid, v.date_debut, e.port_nom AS etape0, v.destination, v.classe_voyage, n.initial_propietaire
FROM voyages AS v 
JOIN navires AS n on v.navireid = n.navireid
JOIN etapes_transitoires AS e ON v.navireID = e.navireID AND v.date_debut = e.date_debut AND e.etape_numero = 1
WHERE n.initial_propietaire IN (--get allies commerciaux   
        SELECT r1.nation2 
        FROM navires AS n 
        JOIN capturer AS c ON n.navireID = c.navireID
        JOIN relations_diplomatiques AS r1 ON r1.nation1 = c.nationalite
        WHERE v.navireID = n.navireID
        AND c.date_of_capture = (
            SELECT MAX(c5.date_of_capture) 
            FROM capturer AS c5 WHERE c5.navireID = c.navireID 
            AND c5.date_of_capture < v.date_debut)
        AND r1.relation_diplomatique = 'allies commerciaux' 
        AND r1.date_debut = (SELECT MAX(r5.date_debut) FROM relations_diplomatiques AS r5 WHERE r5.nation1 = r1.nation1 AND r5.nation2 = r1.nation2 AND r5.date_debut < v.date_debut)
        UNION
        SELECT r2.nation1 
        FROM navires AS n 
        JOIN capturer AS c ON n.navireID = c.navireID
        JOIN relations_diplomatiques AS r2 ON r2.nation2 = c.nationalite
        WHERE v.navireID = n.navireID
        AND c.date_of_capture = (
            SELECT MAX(c5.date_of_capture) 
            FROM capturer AS c5 WHERE c5.navireID = c.navireID 
            AND c5.date_of_capture < v.date_debut)
        AND r2.relation_diplomatique = 'allies commerciaux' 
        AND r2.date_debut = (SELECT MAX(r5.date_debut) FROM relations_diplomatiques AS r5 WHERE r5.nation1 = r2.nation1 AND r5.nation2 = r2.nation2 AND r5.date_debut < v.date_debut)
        )
