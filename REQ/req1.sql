-- une requête qui porte sur au moins trois tables ;

-- Amount of cargo filled by a certain ship on on a certain etape -
-- Le pourcentage d’espace de cargo d'un navire spécific qui est utilisé pendant une voyage

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
