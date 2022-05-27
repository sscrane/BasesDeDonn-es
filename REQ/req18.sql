-- which nation has been at war with the most nations? 

\echo 
\echo la nation qui a été en guerre avec le plus de nations
\echo

SELECT (nation_res) FROM (
    
SELECT r1.nation1 AS nation_res
FROM relations_diplomatiques AS r1
WHERE r1.relation_diplomatique = 'en guerre'

UNION ALL

SELECT r1.nation2 AS nation_res
FROM relations_diplomatiques AS r1
WHERE r1.relation_diplomatique = 'en guerre') AS x

GROUP BY nation_res
ORDER BY COUNT(nation_res) DESC
LIMIT 1
;

