-- une sous-requête corrélée ;

-- choose a port that have ships of each size come to it 

\echo
\echo Les ports qui reçoivent des navires de chaque catégorie de taille.
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
    SELECT DISTINCT n.taille_categorie FROM navires AS n
    WHERE n.taille_categorie NOT IN (
        -- select taille categories at this port
        SELECT DISTINCT n1.taille_categorie FROM 
        etapes_transitoires AS e2 
        JOIN navires AS n1 ON e2.navireID = n1.navireID
        AND x.port_noms = e2.port_nom

        UNION 

        SELECT DISTINCT n1.taille_categorie 
        FROM voyages AS v2
        JOIN navires AS n1 ON v2.navireID = n1.navireID
        AND x.port_noms = v2.destination
    )

)
;