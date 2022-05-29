# Bases De Données

Nom: Yeutseyeva 
Prénom: Sasha 
Numéro d'etudiant: 22121616 

Nom: Crane 
Prénom: Sophie 
Numéro d'etudiant: 22121592

Comment créer et alimenter la bases de données:
Premièrement, vous devez lancer \i creer_tables.sql. Il faut changer les liens dans copy_scripts.sql pour copier les fichiers avec les données avant que vous pouvez l'executér. Après que vous avez changé les liens, vous exécutez \i copy_scripts.sql

creer_tables.sql: Le fichier pour créer les tables. Il contient les tables suivent: personnes, perissable, sec, quantite, produits, capturer, etapes_transitoires, voyages, navires, ports_, nations, et relations_diplomatiques. Il contient aussi les fonctions pour vérifier que les données sont bons.

copy_scripts.sql: Avec ce fichier on alimente les tables avec les fichiers CSV. Il faut utiliser les tables temporaires pour copier les données avant qu'on peut les mettre dans les tables qu'on a fait plus tôt.

REQ: Dossier avec toutes les requêtes. 

toutes.sql: Fichier avec toutes les requêtes. 

Autres points: 
