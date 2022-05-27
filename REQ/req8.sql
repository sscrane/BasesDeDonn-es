-- une requˆete impliquant le calcul de deux agr´egats (par exemple, les moyennes d’un ensemble de maximums)

-- the average of (max volumes held on each ship at etape 0 per country)

SELECT AVG(max_volume) FROM (
    SELECT MAX()
    FROM etapes_transitoires AS e
    JOIN navires AS n ON e.navireID = n.navireID
    JOIN capturer AS c ON n.navireID = c.navireID

)
