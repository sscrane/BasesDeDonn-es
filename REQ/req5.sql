-- une sous-requˆete dans le WHERE ;

-- Product’s volume > avg( volume)
SELECT p.nom, e.volume 
FROM produits p, perissable e 
WHERE p.produitsid = e.produitsid 
AND e.volume > (SELECT AVG(volume) FROM perissable); 
