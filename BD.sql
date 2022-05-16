-- suppression des tables précédentes
DROP TABLE IF EXISTS Personnes;
DROP TABLE IF EXISTS Perissable;
DROP TABLE IF EXISTS Sec;
DROP TABLE IF EXISTS Quantite;
DROP TABLE IF EXISTS Produits;
DROP TABLE IF EXISTS Etapes_Transitoires;
DROP TABLE IF EXISTS Voyages;
DROP TABLE IF EXISTS Navires;
DROP TABLE IF EXISTS Ports_;
DROP TABLE IF EXISTS Nations;

CREATE TABLE Nations (
    Nation_nom VARCHAR(30) PRIMARY KEY,
    Continent VARCHAR(30)
);

CREATE TABLE Ports_(
Nom VARCHAR(30) PRIMARY KEY,
Longitude INT,
Latitude INT,
Nationalite VARCHAR(30), 
Taille_categorie INTEGER CHECK (Taille_categorie BETWEEN 1 AND 5) NOT NULL,
FOREIGN KEY (Nom) REFERENCES Nations(Nation_nom) 
);

CREATE TABLE Navires(
    NavireID SERIAL PRIMARY KEY,
    Navire_type VARCHAR(30),
    Taille_categorie INTEGER CHECK (Taille_categorie BETWEEN 1 AND 5) NOT NULL, 
    Volume INT NOT NULL,
    Nombre_passagers INT NOT NULL,
    Initial_propietaire VARCHAR(30),
    FOREIGN KEY (Initial_propietaire) REFERENCES NATIONS(Nation_nom)
);

CREATE TABLE Voyages(
    NavireID INT,
    Date_debut DATE,
    Date_fin DATE,
    Destination VARCHAR(30),
    Type_voyage VARCHAR(30) CHECK (Type_voyage IN ('Court', 'Moyen', 'Long')),
    Classe_voyage VARCHAR(30) CHECK (Classe_voyage IN ('Europe', 'Amérique', 'Asie', 'Intercontinental')),
    FOREIGN KEY (NavireID) REFERENCES Navires(NavireID),
    FOREIGN KEY (Destination) REFERENCES Ports_(Nom),
    PRIMARY KEY (Date_debut, NavireID),
    CHECK (Date_debut < Date_fin)
);

CREATE TABLE Etapes_Transitoires(
    Etape_numero INT PRIMARY KEY,
    Date_debut DATE, 
    NavireID INT,
    FOREIGN KEY (NavireID, Date_debut) REFERENCES Navires(NavireID)
    (--Date_debut) REFERENCES Voyages(Date_debut) --TODO: Weak connection
);

CREATE TABLE Produits(
    ProduitsID SERIAL PRIMARY KEY,
    TypeProduit VARCHAR (30) CHECK (TypeProduit IN ('Perissable', 'Sec', 'Personnes')),
    Nom VARCHAR(30)
);

CREATE TABLE Quantite(
    Etape_numero SERIAL PRIMARY KEY,
    Date_debut DATE,
    NavireID INT,
    ProduitsID INT,
    FOREIGN KEY(ProduitsID) REFERENCES Produits(ProduitsID),
    FOREIGN KEY(NavireID) REFERENCES Navires(NavireID)
);

CREATE TABLE Perissable(
    ProduitsID INT PRIMARY KEY,
    Date_conservation DATE,
    Volume INT,
    FOREIGN KEY(ProduitsID) REFERENCES Produits(ProduitsID)
);

CREATE TABLE Sec(
    ProduitsID INT PRIMARY KEY,
    Volume INT,
    FOREIGN KEY(ProduitsID) REFERENCES Produits(ProduitsID)
);

CREATE TABLE Personnes(
    ProduitsID INT PRIMARY KEY,
    FOREIGN KEY(ProduitsID) REFERENCES Produits(ProduitsID)
);