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
DROP TABLE IF EXISTS relations_diplomatiques;
DROP FUNCTION IF EXISTS pleine_cale_ou_max_passagers;

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

CREATE TABLE etapes_transitoires(
    etape_numero INT,
    date_debut DATE, 
    navireID INT,
    port_nom VARCHAR(30),
    PRIMARY KEY(etape_numero, date_debut, navireID),
    FOREIGN KEY (navireID, date_debut) 
        REFERENCES voyages (navireID, date_debut),
    FOREIGN KEY (port_nom) REFERENCES ports_(nom)
);

/*

create function pleine_cale_ou_max_passagers()
   returns INT 
   language plpgsql
  as
$$
begin

    SELECT COUNT(*)
    FROM etapes_transitoires AS e
    NATURAL JOIN navires AS n
    JOIN quantite AS q ON e.etape_numero = q.etape_numero AND e.navireID = q.navireID AND e.date_debut = q.date_debut
    WHERE e.etape_numero = 0
    AND ( 
        -- calculate total volume of cargo
        SELECT SUM(*) FROM (
            -- list of quantite * volume of product
            SELECT q3.quantite * p2.volume
            FROM quantite AS q3 
            JOIN produits AS p2 ON q3.produitsID = p2.produitsID
            WHERE q3.navireID = e.navireID
            AND q3.date_debut = e.date_debut
            AND q3.etape_numero = e.etape_numero
            AND p2.type_produit <> 'Personnes'
        ) AS x) = n.volume
    OR ( -- count de passagers 
        SELECT COUNT(*) 
        FROM etapes_transitoires AS e2
        JOIN quantite AS q2 ON e2.etape_numero = q2.etape_numero AND e2.navireID = q2.navireID AND e2.date_debut = q2.date_debut
        JOIN produits AS p ON q2.produitsID = p.produitsID
        WHERE e2.etape_numero = e.etape_numero
        AND e2.date_debut = e.date_debut
        AND e2.navireID = e.navireID
        AND p.type_produit = 'Personnes' ) = n.nombre_passagers
    ;
-- check for each etape 0, that either the cargo is full or there is a max num of passengers 
end;
$$;

ALTER TABLE etapes_transitoires
ADD CONSTRAINT pleine_cale_ou_max_passagers
check (pleine_cale_ou_max_passagers() = 1);

*/

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
    volume INT CHECK (volume>0),
    FOREIGN KEY(produitsID) REFERENCES produits(produitsID)
);

CREATE TABLE sec(
    produitsID INT PRIMARY KEY,
    volume INT CHECK (volume>0),
    FOREIGN KEY(produitsID) REFERENCES produits(produitsID)
);

/*CREATE TABLE personnes(
    produitsID INT PRIMARY KEY,
    FOREIGN KEY(produitsID) REFERENCES produits(produitsID)
);*/

CREATE TABLE capturer (
    date_of_capture DATE,
    navireID INT,
    nationalite VARCHAR(30),
    FOREIGN KEY(navireID) REFERENCES navires(navireID),
    FOREIGN KEY(nationalite) REFERENCES nations(nationalite),
    PRIMARY KEY(navireID, date_of_capture)
);

CREATE TABLE relations_diplomatiques (
    nation1 VARCHAR(30),
    nation2 VARCHAR(30),
    relation_diplomatique VARCHAR(30) 
        CHECK (relation_diplomatique IN ('allies commerciaux', 'allies', 'neutres', 'en guerre')),
    date_debut DATE,
    PRIMARY KEY(nation1,nation2,date_debut)
);
