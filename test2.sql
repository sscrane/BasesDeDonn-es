
/*SELECT q.navireid, SUM(q.quantite), n.volume, ROUND(SUM(q.quantite)::DECIMAL / n.volume, 2) AS avg_occupied FROM quantite q
JOIN voyages AS v on q.date_debut = v.date_debut AND q.navireID = v.navireID
JOIN navires AS n on v.navireid = n.navireid
GROUP BY q.navireid, n.volume;*/

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