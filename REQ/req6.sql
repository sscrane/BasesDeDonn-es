-- deux agr´egats n´ecessitant GROUP BY et HAVING ;

-- SELECT max voyage By each country that is in europe 

-- GROUP BY (country) HAVING continent = "europe"

SELECT MAX(ABS(v.date_debut-v.date_fin)), c.nationalite
FROM voyages AS v
JOIN capturer AS c ON v.navireID = c.navireID 
JOIN nations AS n ON c.nationalite = n.nationalite
WHERE c.date_of_capture = (
    SELECT MAX(c2.date_of_capture)
    FROM capturer AS c2
    WHERE c2.navireID = c.navireID
)
GROUP BY (c.nationalite, n.continent)
HAVING n.continent = 'Europe'
;
