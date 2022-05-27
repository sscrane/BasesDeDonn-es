-- une jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN) ;
\echo
\echo Créer une liste des ports visités dans lordre chronologique
\echo
--Chronological port order, but all ports
SELECT DISTINCT p.nom, v.date_debut 
FROM ports_ p 
LEFT JOIN voyages v ON p.nom = v.destination 
ORDER BY v.date_debut ASC ;
