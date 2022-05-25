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
DROP FUNCTION IF EXISTS deux_semaines_entre_voyages;
DROP FUNCTION IF EXISTS produits_verification;
DROP FUNCTION IF EXISTS intercontinental_taille_5;
DROP FUNCTION IF EXISTS taille_port_navire;
DROP FUNCTION IF EXISTS non_en_guerre;

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

---------------------------------------------

create function alliance_commerciaux_check()
   returns INT 
   language plpgsql
  as
$$
begin

return (

-- check for each voyage, if the ship is in "commercial allies" then the destination or etape 0 is it's country and destination or etape 0 is other country
-- check for each country that is a commercial allie, that each of it's ships is only doing nation1--> nation2 voyages 


);

end;
$$;

ALTER TABLE voyages
ADD CONSTRAINT alliance_commerciaux_check
CHECK (alliance_commerciaux_check() = 0);

---------------------------------------------

-- Check that for ship of nation X arriving at/departing from nation Y, that the most recent relation between X and Y isn’t ‘en guerre’

create function non_en_guerre()
   returns INT 
   language plpgsql
  as
$$
begin

return (
   SELECT COUNT(*) FROM voyages AS v
   JOIN ports_ AS p ON v.destination = p.nom
   JOIN etapes_transitoires AS e ON v.navireID = e.navireID AND v.date_debut = e.date_debut AND e.etape_numero = 1
   JOIN ports_ AS p2 ON e.port_nom = p2.nom
   WHERE p.nationalite IN (
       -- list of countries that the voyage navire's country is "en guerre" with
        SELECT r1.nation2 
        FROM navires AS n 
        JOIN capturer AS c ON n.navireID = c.navireID
        JOIN relations_diplomatiques AS r1 ON r1.nation1 = c.nationalite
        WHERE v.navireID = n.navireID
        AND c.date_of_capture = (SELECT MAX(c5.date_of_capture) FROM capturer AS c5 WHERE c5.navireID = c.navireID AND c5.date_of_capture < v.date_debut)
        AND r1.relation_diplomatique = 'en guerre' 
        AND r1.date_debut = (SELECT MAX(r5.date_debut) FROM relations_diplomatiques AS r5 WHERE r5.nation1 = r1.nation1 AND r5.nation2 = r1.nation2 AND r5.date_debut < v.date_debut)

        UNION

        SELECT r2.nation1 FROM navires AS n 
        JOIN capturer AS c ON n.navireID = c.navireID
        JOIN relations_diplomatiques AS r2 ON r2.nation2 = c.nationalite
        WHERE v.navireID = n.navireID
        AND c.date_of_capture = (SELECT MAX(c5.date_of_capture) FROM capturer AS c5 WHERE c5.navireID = c.navireID AND c5.date_of_capture < v.date_debut)
        AND r2.relation_diplomatique = 'en guerre' 
        AND r2.date_debut = (SELECT MAX(r5.date_debut) FROM relations_diplomatiques AS r5 WHERE r5.nation1 = r2.nation1 AND r5.nation2 = r2.nation2 AND r5.date_debut < v.date_debut)

        )
    
    OR p2.nationalite IN (
        -- list of countries that the voyage navire's country is "en guerre" with
        SELECT r1.nation2 
        FROM navires AS n 
        JOIN capturer AS c ON n.navireID = c.navireID
        JOIN relations_diplomatiques AS r1 ON r1.nation1 = c.nationalite
        WHERE v.navireID = n.navireID
        AND c.date_of_capture = (SELECT MAX(c5.date_of_capture) FROM capturer AS c5 WHERE c5.navireID = c.navireID AND c5.date_of_capture < v.date_debut)
        AND r1.relation_diplomatique = 'en guerre' 
        AND r1.date_debut = (SELECT MAX(r5.date_debut) FROM relations_diplomatiques AS r5 WHERE r5.nation1 = r1.nation1 AND r5.nation2 = r1.nation2 AND r5.date_debut < v.date_debut)

        UNION

        SELECT r2.nation1 FROM navires AS n 
        JOIN capturer AS c ON n.navireID = c.navireID
        JOIN relations_diplomatiques AS r2 ON r2.nation2 = c.nationalite
        WHERE v.navireID = n.navireID
        AND c.date_of_capture = (SELECT MAX(c5.date_of_capture) FROM capturer AS c5 WHERE c5.navireID = c.navireID AND c5.date_of_capture < v.date_debut)
        AND r2.relation_diplomatique = 'en guerre' 
        AND r2.date_debut = (SELECT MAX(r5.date_debut) FROM relations_diplomatiques AS r5 WHERE r5.nation1 = r2.nation1 AND r5.nation2 = r2.nation2 AND r5.date_debut < v.date_debut)


    )
       
   
);

end;
$$;

ALTER TABLE voyages
ADD CONSTRAINT non_en_guerre
CHECK (non_en_guerre() = 0);

---------------------------------------------

create function taille_port_navire()
   returns INT 
   language plpgsql
  as
$$
begin

return (
    SELECT COUNT(*)
    FROM voyages AS v
    WHERE EXISTS (
        -- destination is smaller than ship size 
        SELECT * FROM voyages AS v2
        NATURAL JOIN navires AS n
        JOIN ports_ AS p ON v2.destination = p.nom
        WHERE v2.navireID = v.navireID AND v2.date_debut = v.date_debut
        AND p.taille_categorie < n.taille_categorie
    ) OR EXISTS (
        -- etape 1 port is smaller than ship size
        SELECT * FROM etapes_transitoires AS e
        NATURAL JOIN navires AS n
        JOIN ports_ AS p ON e.port_nom = p.nom
        WHERE e.etape_numero = 1
        AND e.date_debut = v.date_debut AND e.navireID = v.navireID
        AND p.taille_categorie < n.taille_categorie

    )
);

end;
$$;

ALTER TABLE voyages
ADD CONSTRAINT taille_port_navire
CHECK (taille_port_navire() = 0);

---------------------------------------------

create function intercontinental_taille_5()
   returns INT 
   language plpgsql
  as
$$
begin

return (
    SELECT COUNT(*)
    FROM voyages AS v
    WHERE v.classe_voyage = 'Intercontinental'
    AND EXISTS (
        SELECT * FROM voyages AS v2 
        NATURAL JOIN navires AS n
        WHERE v2.navireID = v.navireID AND v2.date_debut = v.date_debut
        AND n.taille_categorie <5
    )
);

end;
$$;

ALTER TABLE voyages
ADD CONSTRAINT intercontinental_taille_5
CHECK (intercontinental_taille_5() = 0);

---------------------------------------------

create function produits_verification()
   returns INT 
   language plpgsql
  as
$$
begin

return (
    -- select number of voyages that are not short and contain cargo that is perissable
    SELECT COUNT(*)
    FROM voyages AS v
    WHERE v.type_voyage <> 'Court'
    AND EXISTS (
        SELECT * FROM voyages AS v2 
        NATURAL JOIN etapes_transitoires AS e
        NATURAL JOIN quantite AS q
        JOIN produits AS p ON q.produitsID = p.produitsID
        WHERE p.type_produit = 'Perissable'
        AND v2.navireID = v.navireID AND v2.date_debut = v.date_debut
    )
);

end;
$$;

ALTER TABLE voyages
ADD CONSTRAINT produits_verification
CHECK (produits_verification() = 0);

---------------------------------------------

create function deux_semaines_entre_voyages()
   returns INT 
   language plpgsql
  as
$$
begin

return (
    SELECT COUNT(*) 
    FROM voyages AS v 
    WHERE EXISTS (
        SELECT * FROM voyages AS v2
        JOIN voyages AS v3 ON v2.navireID = v3.navireID
        WHERE v.navireID = v2.navireID
        AND v2.date_fin + INTERVAL '2 week' > v3.date_debut
        AND v2.date_debut <> v3.date_debut
        AND v2.date_debut < v3.date_debut
    )
);

end;
$$;

ALTER TABLE voyages
ADD CONSTRAINT deux_semaines_entre_voyages
CHECK (deux_semaines_entre_voyages() = 0);

CREATE TABLE etapes_transitoires(
    etape_numero INT,
    date_debut DATE, 
    navireID INT,
    port_nom VARCHAR(30), -- THIS IS THE PORT THE SHIP STARTS AT
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
            SELECT q3.quantite * per.volume * sec.volume
            FROM quantite AS q3 
            JOIN produits AS p2 ON q3.produitsID = p2.produitsID
            JOIN perissable AS per ON p2.produitsID = per.produitsID
            JOIN sec AS sec ON p2.produitsID = sec.produitsID
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
    FOREIGN KEY (etape_numero, date_debut, navireID) 
        REFERENCES etapes_transitoires (etape_numero, date_debut, navireID),
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
