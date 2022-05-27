-- deux agr´egats n´ecessitant GROUP BY et HAVING ;

-- Select products where the sum of that quantity moved over every voyage step is greater 
-- than the average amount of each product moved during each step

\echo Sélectionnez les produits pour lesquels la somme de cette quantité déplacée au cours de chaque étape du voyage 
\echo est supérieure que la quantité moyenne de chaque produit déplacé au cours de chaque étape

SELECT p.nom, SUM(q.quantite) FROM quantite q
JOIN produits AS p ON q.produitsid = p.produitsid
GROUP BY p.nom HAVING SUM(q.quantite) > (SELECT AVG(quantite) FROM quantite)
;


