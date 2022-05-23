-- suppression des tables précédentes
DROP TABLE IF EXISTS Personnes;
DROP TABLE IF EXISTS Perissable;
DROP TABLE IF EXISTS Sec;
DROP TABLE IF EXISTS Quantite;
DROP TABLE IF EXISTS Produits;
DROP TABLE IF EXISTS Capturer;
DROP TABLE IF EXISTS Etapes_Transitoires;
DROP TABLE IF EXISTS Voyages;
DROP TABLE IF EXISTS Navires;
DROP TABLE IF EXISTS Ports_;
DROP TABLE IF EXISTS Nations;

CREATE TABLE Nations(
    Nationalite VARCHAR(30) PRIMARY KEY,
    Continent VARCHAR(30)
);

CREATE TABLE Ports_(
Nom VARCHAR(30) PRIMARY KEY,
Longitude DECIMAL,
Latitude DECIMAL,
Nationalite VARCHAR(30), 
Taille_categorie INTEGER CHECK (Taille_categorie BETWEEN 1 AND 5) NOT NULL,
FOREIGN KEY (Nationalite) REFERENCES Nations(Nationalite) 
);

CREATE TABLE Navires(
    NavireID SERIAL PRIMARY KEY,
    Navire_type VARCHAR(30),
    Taille_categorie INTEGER CHECK (Taille_categorie BETWEEN 1 AND 5) NOT NULL, 
    Volume INT NOT NULL CHECK (Volume >= 0),
    Nombre_passagers INT NOT NULL CHECK (Nombre_passagers >= 0),
    Initial_propietaire VARCHAR(30),
    FOREIGN KEY (Initial_propietaire) REFERENCES NATIONS(Nationalite)
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

CREATE TABLE Produits(
    ProduitsID SERIAL PRIMARY KEY,
    Nom VARCHAR(30),
    TypeProduit VARCHAR (30) CHECK (TypeProduit IN ('Perissable', 'Sec', 'Personnes'))
);

CREATE TABLE Quantite(
    Etape_numero INT,
    Date_debut DATE,
    NavireID INT,
    ProduitsID INT,
    Quantite INT,
    PRIMARY KEY (Etape_numero, Date_debut, NavireID, ProduitsID),
    FOREIGN KEY(ProduitsID) REFERENCES Produits(ProduitsID),
    FOREIGN KEY(NavireID) REFERENCES Navires(NavireID)
);

CREATE TABLE Perissable(
    ProduitsID INT PRIMARY KEY,
    Date_conservation INTERVAL, --ex: SELECT date_conservation + DATE('2020-02-02') FROM Perissable;
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

CREATE TABLE Capturer (
    Date_of_capture DATE,
    NavireID INT,
    Nationalite VARCHAR(30),
    FOREIGN KEY(NavireID) REFERENCES Navires(NavireID),
    FOREIGN KEY(Nationalite) REFERENCES Nations(Nationalite)
);
