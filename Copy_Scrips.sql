COPY Nations(Nationalite, Continent)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Nations.csv'--'../CSV_Fichiers/Nations.csv'
DELIMITER ','
CSV HEADER;

COPY Ports_(Nom, Longitude, Latitude, Nationalite, Taille_categorie)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Ports.csv'
DELIMITER ','
CSV HEADER;

COPY Navires(Navire_type, Taille_categorie, Volume, Nombre_passagers, Initial_propietaire)
FROM '//Users/sophiecrane/BasesDonnees/CSV_Fichiers/Navire.csv'
DELIMITER ','
CSV HEADER;

COPY Voyages(NavireID, Date_debut, Date_fin, Destination, Type_voyage, Classe_voyage)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Voyages.csv'
DELIMITER ','
CSV HEADER;

/*COPY Etapes_Transitoires(Etape_numero, Date_debut, NavireID, Etape)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Etapes_Transitoires.csv'
DELIMITER ','
CSV HEADER;*/

COPY Produits(Nom, TypeProduit)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Produits.csv'
DELIMITER ','
CSV HEADER;

COPY Quantite(Etape_numero, Date_debut, NavireID, ProduitsID, Quantite)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Quantite.csv'
DELIMITER ','
CSV HEADER;

COPY Perissable(ProduitsID, Date_conservation, Volume)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Perissable.csv'
DELIMITER ','
CSV HEADER;

COPY Sec(ProduitsID, Volume)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Sec.csv'
DELIMITER ','
CSV HEADER;

COPY Capturer(Date_of_capture, NavireID, Nationalite)
FROM '/Users/sophiecrane/BasesDonnees/CSV_Fichiers/Capturer.csv'
DELIMITER ','
CSV HEADER;