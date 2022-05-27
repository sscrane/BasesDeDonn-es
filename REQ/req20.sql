-- List of total amount of products by country -- La quantité de produits reçus par chaque pays
\echo
\echo La quantité de produits reçus par chaque pays
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
