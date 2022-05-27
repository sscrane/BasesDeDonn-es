-- deux requêtes qui renverraient le même résultat si vos tables de contenaient pas de nulls, 
-- mais qui renvoient des résultats différents ici 
-- (vos données devront donc contenir quelques nulls), 
-- vous proposerez également de petites modifications de vos requêtes 
-- (dans l’esprit de ce qui a été présenté en cours)
--  afin qu’elles retournent le même résultat

SELECT DISTINCT q.produitsid, q.quantite, p.date_conservation FROM quantite q
JOIN perissable AS p ON q.produitsID = p.produitsID
WHERE p.date_conservation = (
    SELECT MAX(perissable.date_conservation) 
    FROM perissable);

