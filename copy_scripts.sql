COPY nations(nationalite, continent)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Nations.csv'--'../CSV_Fichiers/Nations.csv'
DELIMITER ','
--CSV HEADER
;

COPY ports_(nom, longitude, latitude, nationalite, taille_categorie)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Ports.csv'
DELIMITER ','
--CSV HEADER
;

COPY navires(navire_type, taille_categorie, volume, nombre_passagers, initial_propietaire)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Navire.csv'
DELIMITER ','
--CSV HEADER
;

COPY voyages( date_debut, date_fin, destination, type_voyage, classe_voyage,navireID)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Voyages.csv'
DELIMITER ','
-- KEYWORD TO AVOID BULK INSERT
--CSV HEADER
;


COPY etapes_transitoires(etape_numero, date_debut, navireID, port_nom)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Etapes_Transitoires.csv'
DELIMITER ','
--CSV HEADER
;


COPY produits(nom, type_produit)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Produits.csv'
DELIMITER ','
--CSV HEADER
;

COPY quantite(etape_numero, date_debut, navireID, produitsID, quantite)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Quantite.csv'
DELIMITER ','
--CSV HEADER
;

COPY perissable(produitsID, date_conservation, volume)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Perissable.csv'
DELIMITER ','
--CSV HEADER
;

COPY sec(produitsID, volume)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Sec.csv'
DELIMITER ','
--CSV HEADER
;

COPY capturer(date_of_capture, navireID, nationalite)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Capturer.csv'
DELIMITER ','
--CSV HEADER
;




