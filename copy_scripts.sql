DROP TABLE IF EXISTS nations_temp;
DROP TABLE IF EXISTS voyages_temp;
DROP TABLE IF EXISTS navires_temp;

CREATE TEMPORARY TABLE nations_temp
   (
      nationalite VARCHAR(30),
    continent VARCHAR(30)
   );

COPY nations_temp(nationalite, continent)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Nations.csv'--'../CSV_Fichiers/Nations.csv'
DELIMITER ','
--CSV HEADER
;

INSERT INTO nations
SELECT nationalite, continent
FROM nations_temp
;

CREATE TEMPORARY TABLE navires_temp
   (
    navire_type VARCHAR(30),
    taille_categorie INT, 
    volume INT ,
    nombre_passagers INT ,
    initial_propietaire VARCHAR(30)
   );

COPY navires_temp(navire_type, taille_categorie, volume, nombre_passagers, initial_propietaire)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Navire.csv'
DELIMITER ','
--CSV HEADER
;

INSERT INTO navires(navire_type, taille_categorie, volume, nombre_passagers, initial_propietaire)
SELECT navire_type, taille_categorie, volume, nombre_passagers, initial_propietaire
FROM navires_temp
;

COPY ports_(nom, longitude, latitude, nationalite, taille_categorie)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Ports.csv'
DELIMITER ','
--CSV HEADER
;

CREATE TEMPORARY TABLE voyages_temp
   (
    navireID INT,
    date_debut DATE,
    date_fin DATE,
    destination VARCHAR(30),
    type_voyage VARCHAR(30),
    classe_voyage VARCHAR(30)
   )
;

COPY voyages_temp( date_debut, date_fin, destination, type_voyage, classe_voyage,navireID)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Voyages.csv'
DELIMITER ','
-- KEYWORD TO AVOID BULK INSERT
--CSV HEADER
;

INSERT INTO voyages
SELECT navireID,date_debut, date_fin, destination, type_voyage, classe_voyage
FROM voyages_temp
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

COPY relations_diplomatiques(nation1, nation2, relation_diplomatique,date_debut)
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/relations_diplomatiques.csv'
DELIMITER ','
--CSV HEADER
;



