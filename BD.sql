-- suppression des tables précédentes

DROP TABLE IF EXISTS Navires;
DROP TABLE IF EXISTS Voyages;
DROP TABLE IF EXISTS Etapes_Transitoires;
DROP TABLE IF EXISTS Ports_;
DROP TABLE IF EXISTS Quantite;
DROP TABLE IF EXISTS Produits;
DROP TABLE IF EXISTS Perissable;
DROP TABLE IF EXISTS Sec;
DROP TABLE IF EXISTS Personnes;
DROP TABLE IF EXISTS Nations;
DROP TABLE IF EXISTS RelationsDiplomatic;
DROP TABLE IF EXISTS Capturer;


COPY Navires(Navire_type, Taille_categorie, Volume, Nombre_passager, Initial_propietaire)
FROM '[path]'
DELIMITER ','
CSV HEADER;

COPY Voyages(NavireID, Date_debut, Date_fin, Destination, Type_voyage, Classe_voyage)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Etapes_Transitoires(Etape_numero, Date_debut, NavireID)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Ports_(Nom, Localisation, Nationalite, Nations)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Quantite(Nom, Localisation, Nationalite, Nations)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Produits(TypeProduit, Nom)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Perissable(Date_conservation, Volume)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Sec(Volume)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Nations(Nation_nom, Continent)
FROM ''
DELIMITER ','
CSV HEADER;