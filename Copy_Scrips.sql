COPY Nations(Nation_nom, Continent)
FROM '/Users/sophiecrane/BasesDonnees/Nations.csv'
DELIMITER ','
CSV HEADER;

COPY Ports_(Nom, Longitude, Latitude, Nationalite, Taille_categorie)
FROM '/Users/sophiecrane/BasesDonnees/Ports.csv'
DELIMITER ','
CSV HEADER;

COPY Navires(Navire_type, Taille_categorie, Volume, Nombre_passagers, Initial_propietaire)
FROM '/Users/sophiecrane/BasesDonnees/Navire.csv'
DELIMITER ','
CSV HEADER;
/*COPY Voyages(NavireID, Date_debut, Date_fin, Destination, Type_voyage, Classe_voyage)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Etapes_Transitoires(Etape_numero, Date_debut, NavireID)
FROM ''
DELIMITER ','
CSV HEADER;

COPY Quantite(Nom, Localisation, Nationalite, Nations)
FROM ''
DELIMITER ','
CSV HEADER;
*/
COPY Produits(Nom, TypeProduit)
FROM '/Users/sophiecrane/BasesDonnees/Produits.csv'
DELIMITER ','
CSV HEADER;

COPY Perissable(ProduitsID, Date_conservation, Volume)
FROM '/Users/sophiecrane/BasesDonnees/Perissable.csv'
DELIMITER ','
CSV HEADER;

COPY Sec(ProduitsID, Volume)
FROM '/Users/sophiecrane/BasesDonnees/Sec.csv'
DELIMITER ','
CSV HEADER;