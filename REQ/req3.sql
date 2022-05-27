-- une sous-requête corrélée ;

-- choose a port that have ships of each size come to it 
\echo Les ports qui reçoivent des navires de chaque catégorie de taille.

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