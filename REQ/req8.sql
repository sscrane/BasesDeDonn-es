-- une requˆete impliquant le calcul de deux agr´egats (par exemple, les moyennes d’un ensemble de maximums)

-- an average of the max length voyages for each size of ship 

\echo Sélectionnez une moyenne de la longueur maximale des voyages pour chaque taille de navire. 

SELECT AVG(max_lengths) 
FROM (
    -- max voyages for each size of ship
    SELECT MAX(ABS(v.date_debut - v.date_fin)) AS max_lengths, n.taille_categorie
    FROM voyages AS v
    JOIN navires AS n ON v.navireID = n.navireID
    GROUP BY n.taille_categorie

) 

AS x;
