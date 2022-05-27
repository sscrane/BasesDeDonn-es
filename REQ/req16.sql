-- SELECT all perissable products that last the longest

\echo 
\echo Selectionner les produits périssables qui durent le plus longtemps
\echo 

SELECT p.produitsid,p.nom, per.date_conservation 
FROM produits p 
JOIN perissable AS per ON p.produitsid = per.produitsid 
WHERE per.date_conservation = (SELECT MAX(date_conservation) FROM perissable);