DROP TABLE IF EXISTS nations_temp;
DROP TABLE IF EXISTS voyages_temp;
DROP TABLE IF EXISTS navires_temp;
DROP TABLE IF EXISTS ports_temp;
DROP TABLE IF EXISTS etapes_temp;
DROP TABLE IF EXISTS produits_temp;
DROP TABLE IF EXISTS quantite_temp;
DROP TABLE IF EXISTS perissable_temp;
DROP TABLE IF EXISTS sec_temp;
DROP TABLE IF EXISTS capturer_temp;
DROP TABLE IF EXISTS relations_diplomatiques_temp;

--DECLARE @user AS VARCHAR(30)='sophiecrane'

CREATE TEMPORARY TABLE nations_temp
   (
      nationalite VARCHAR(30),
      continent VARCHAR(30)
   );

COPY nations_temp(nationalite, continent)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Nations.csv'--'../CSV_Fichiers/Nations.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/nations.csv'
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
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Navire.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/navire.csv'
WITH (FORMAT CSV, DELIMITER ',')
--CSV HEADER
;

INSERT INTO navires(navire_type, taille_categorie, volume, nombre_passagers, initial_propietaire)
SELECT navire_type, taille_categorie, volume, nombre_passagers, initial_propietaire
FROM navires_temp
;

CREATE TEMPORARY TABLE ports_temp
   (
    nom VARCHAR(30),
    longitude DECIMAL,
    latitude DECIMAL,
    nationalite VARCHAR(30), 
    taille_categorie INTEGER 
   );

COPY ports_temp(nom, longitude, latitude, nationalite, taille_categorie)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Ports.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/ports.csv'
WITH (FORMAT CSV, DELIMITER ',')
--CSV HEADER
;

INSERT INTO ports_
SELECT nom, longitude, latitude, nationalite, taille_categorie
FROM ports_temp
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
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Voyages.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/voyages.csv'
DELIMITER ','
-- KEYWORD TO AVOID BULK INSERT
--CSV HEADER
;

INSERT INTO voyages
SELECT navireID,date_debut, date_fin, destination, type_voyage, classe_voyage
FROM voyages_temp
;

CREATE TEMPORARY TABLE etapes_temp
   (
    etape_numero INT,
    date_debut DATE, 
    navireID INT,
    port_nom VARCHAR(30)
   )
;
COPY etapes_temp(etape_numero, date_debut, navireID, port_nom)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Etapes_Transitoires.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Etapes_Transitoires.csv'
DELIMITER ','
;
INSERT INTO etapes_transitoires
SELECT etape_numero, date_debut, navireID, port_nom
FROM etapes_temp
;


CREATE TEMPORARY TABLE produits_temp
   (
      produitsID SERIAL PRIMARY KEY,
      nom VARCHAR(30),
      type_produit VARCHAR (30)
   )
;

COPY produits_temp(nom, type_produit)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Produits.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Produits.csv'
DELIMITER ','

;
INSERT INTO produits
SELECT produitsID, nom, type_produit
FROM produits_temp
;

CREATE TEMPORARY TABLE quantite_temp
   (
      etape_numero INT,
      date_debut DATE,
      navireID INT,
      produitsID INT,
      quantite INT
   )
;

COPY quantite_temp(etape_numero, date_debut, navireID, produitsID, quantite)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Quantite.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Quantite.csv'
WITH (FORMAT CSV, DELIMITER ',')
;

INSERT INTO quantite
SELECT etape_numero, date_debut, navireID, produitsID, quantite
FROM quantite_temp
;

CREATE TEMPORARY TABLE perissable_temp
   (
      produitsID INT PRIMARY KEY,
      date_conservation INTERVAL,
      volume INT
   )
;

COPY perissable_temp(produitsID, date_conservation, volume)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Perissable.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Perissable.csv'
WITH (FORMAT CSV, DELIMITER ',')
;

INSERT INTO perissable
SELECT produitsID, date_conservation, volume
FROM perissable_temp
;

CREATE TEMPORARY TABLE sec_temp
   (
      produitsID INT PRIMARY KEY,
      volume INT 
   )
;

COPY sec_temp(produitsID, volume)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Sec.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Sec.csv'
WITH (FORMAT CSV, DELIMITER ',')
;

INSERT INTO sec
SELECT produitsID, volume
FROM sec_temp
;

CREATE TEMPORARY TABLE capturer_temp
   (
      date_of_capture DATE,
      navireID INT,
      nationalite VARCHAR(30)
   )
;

COPY capturer_temp(date_of_capture, navireID, nationalite)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/Capturer.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/Capturer.csv'
DELIMITER ','
;

INSERT INTO Capturer
SELECT date_of_capture, navireID, nationalite
FROM capturer_temp
;

CREATE TEMPORARY TABLE relations_diplomatiques_temp
   (
      nation1 VARCHAR(30),
      nation2 VARCHAR(30),
      relation_diplomatique VARCHAR(30), 
      date_debut DATE
   )
;

COPY relations_diplomatiques_temp(nation1, nation2, relation_diplomatique, date_debut)
--FROM '/Users/sophiecrane/DB/BasesDeDonn-es/CSV_Fichiers/relations_diplomatiques.csv'
FROM '/Users/sashayeutseyeva/Documents/BD/BasesDeDonn-es/CSV_Fichiers/relations_diplomatiques.csv'
DELIMITER ','
;

INSERT INTO relations_diplomatiques
SELECT nation1, nation2, relation_diplomatique, date_debut
FROM relations_diplomatiques_temp
;


