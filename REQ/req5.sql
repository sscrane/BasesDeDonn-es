-- une sous-requˆete dans le WHERE ;

-- Product’s volume > avg( volume)

\echo Les produits dont le volume est supérieur au volume moyen.

SELECT p.nom, e.volume 
FROM produits p, perissable e 
WHERE p.produitsid = e.produitsid 
AND e.volume > (SELECT AVG(volume) FROM perissable); 
