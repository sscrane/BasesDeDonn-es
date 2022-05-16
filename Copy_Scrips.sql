
COPY Navires(Navire_type, Taille_categorie, Volume, Nombre_passager, Initial_propietaire)
FROM '/Users/sophiecrane/BasesDonnees/Données - Navire.csv'
DELIMITER ','
CSV HEADER;
/*
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
CSV HEADER;*/