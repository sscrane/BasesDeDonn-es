-- suppression des tables précédentes
DROP TABLE IF EXISTS personnes;
DROP TABLE IF EXISTS perissable;
DROP TABLE IF EXISTS sec;
DROP TABLE IF EXISTS quantite;
DROP TABLE IF EXISTS produits;
DROP TABLE IF EXISTS capturer;
DROP TABLE IF EXISTS etapes_transitoires;
DROP TABLE IF EXISTS voyages;
DROP TABLE IF EXISTS navires;
DROP TABLE IF EXISTS ports_;
DROP TABLE IF EXISTS nations;

CREATE TABLE nations(
    nationalite VARCHAR(30) PRIMARY KEY,
    continent VARCHAR(30)
);

CREATE TABLE ports_(
    nom VARCHAR(30) PRIMARY KEY,
    longitude DECIMAL,
    latitude DECIMAL,
    nationalite VARCHAR(30), 
    taille_categorie INTEGER CHECK (taille_categorie BETWEEN 1 AND 5) NOT NULL,
    FOREIGN KEY (nationalite) REFERENCES nations(nationalite) 
);

CREATE TABLE navires(
    navireID SERIAL PRIMARY KEY,
    navire_type VARCHAR(30),
    taille_categorie INTEGER CHECK (taille_categorie BETWEEN 1 AND 5) NOT NULL, 
    volume INT NOT NULL CHECK (volume >= 0),
    nombre_passagers INT NOT NULL CHECK (nombre_passagers >= 0),
    initial_propietaire VARCHAR(30),
    FOREIGN KEY (initial_propietaire) REFERENCES nations(nationalite)
);

CREATE TABLE voyages(
    navireID INT,
    date_debut DATE,
    date_fin DATE,
    destination VARCHAR(30),
    type_voyage VARCHAR(30) CHECK (type_voyage IN ('Court', 'Moyen', 'Long')),
    classe_voyage VARCHAR(30) CHECK (classe_voyage IN ('Europe', 'Amérique', 'Asie', 'Intercontinental')),
    FOREIGN KEY (navireID) REFERENCES navires(navireID),
    FOREIGN KEY (destination) REFERENCES ports_(nom),
    PRIMARY KEY (date_debut, navireID),
    CHECK (date_debut < date_fin)
);

/*CREATE TABLE Etapes_Transitoires(
    Etape_numero INT,
    Date_debut DATE, 
    NavireID INT,
    Etape VARCHAR(30),
    PRIMARY KEY(Etape_numero, Date_debut, NavireID),
    FOREIGN KEY (NavireID) REFERENCES Navires(NavireID),
    FOREIGN KEY (Date_debut) REFERENCES Voyages(Date_debut),
    FOREIGN KEY (Etape) REFERENCES Ports_(Nom)
    --TODO: Weak connection
);*/

CREATE TABLE produits(
    produitsID SERIAL PRIMARY KEY,
    nom VARCHAR(30),
    type_produit VARCHAR (30) CHECK (type_produit IN ('Perissable', 'Sec', 'Personnes'))
);

CREATE TABLE quantite(
    etape_numero INT,
    date_debut DATE,
    navireID INT,
    produitsID INT,
    quantite INT,
    PRIMARY KEY (etape_numero, date_debut, navireID, produitsID),
    FOREIGN KEY(produitsID) REFERENCES produits(produitsID),
    FOREIGN KEY(navireID) REFERENCES navires(navireID)
);

CREATE TABLE perissable(
    produitsID INT PRIMARY KEY,
    date_conservation INTERVAL, --ex: SELECT date_conservation + DATE('2020-02-02') FROM Perissable;
    volume INT,
    FOREIGN KEY(produitsID) REFERENCES produits(produitsID)
);

CREATE TABLE sec(
    produitsID INT PRIMARY KEY,
    volume INT,
    FOREIGN KEY(produitsID) REFERENCES produits(produitsID)
);

CREATE TABLE personnes(
    produitsID INT PRIMARY KEY,
    FOREIGN KEY(produitsID) REFERENCES produits(produitsID)
);

CREATE TABLE capturer (
    date_of_capture DATE,
    navireID INT,
    nationalite VARCHAR(30),
    FOREIGN KEY(navireID) REFERENCES navires(navireID),
    FOREIGN KEY(nationalite) REFERENCES nations(nationalite)
);
