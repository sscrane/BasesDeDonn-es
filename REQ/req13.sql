-- deux requêtes qui renverraient le même résultat si vos tables de contenaient pas de nulls, 
-- mais qui renvoient des résultats différents ici 
-- (vos données devront donc contenir quelques nulls), 
-- vous proposerez également de petites modifications de vos requêtes 
-- (dans l’esprit de ce qui a été présenté en cours)
--  afin qu’elles retournent le même résultat

\echo
\echo Sélectionnez lidentifiant du produit, sa quantité et sa date de conservation qui a la plus longue date de conservation.
\echo

SELECT DISTINCT q.produitsid, q.quantite, p.date_conservation FROM quantite q
JOIN perissable AS p ON q.produitsID = p.produitsID
WHERE p.date_conservation >= ALL (
    SELECT perissable.date_conservation 
    FROM perissable);

--On peut ajouter "IS NOT NULL"...

\echo
\echo Avec quelque modifications: Sélectionnez lidentifiant du produit, sa quantité et sa date de conservation qui a la plus longue date de conservation.
\echo

SELECT DISTINCT q.produitsid, q.quantite, p.date_conservation FROM quantite q
JOIN perissable AS p ON q.produitsID = p.produitsID
WHERE p.date_conservation >= ALL (
    SELECT perissable.date_conservation 
    FROM perissable
    WHERE perissable.date_conservation IS NOT NULL);