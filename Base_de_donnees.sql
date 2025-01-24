-- Création de la base de données
CREATE DATABASE CabinetComptable;
GO
USE CabinetComptable;
GO

-- Table des clients (sans index sur les colonnes souvent recherchées)
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    Nom VARCHAR(255),
    Email VARCHAR(255),
    Adresse VARCHAR(500),
    Telephone VARCHAR(20),
    DateInscription DATETIME
);

-- Table des factures (sans index approprié et types de données sous-optimaux)
CREATE TABLE Factures (
    FactureID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT,
    Montant DECIMAL(18,6),
    DateFacture DATETIME,
    Statut VARCHAR(50),
    Description VARCHAR(1000),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);

-- Ajout de données volumineuses pour provoquer la fragmentation
SET NOCOUNT ON;
DECLARE @i INT = 1;
WHILE @i <= 100000
BEGIN
    INSERT INTO Clients (Nom, Email, Adresse, Telephone, DateInscription)
    VALUES (
        CONCAT('Client', @i),
        CONCAT('client', @i, '@example.com'),
        'Adresse Test ' + CAST(@i AS VARCHAR),
        CONCAT('06000000', @i % 100),
        DATEADD(DAY, -@i % 365, GETDATE())
    );
    
    INSERT INTO Factures (ClientID, Montant, DateFacture, Statut, Description)
    VALUES (
        @i % 1000 + 1,  -- Répartition des factures sur les 1000 premiers clients
        RAND() * 1000,
        DATEADD(DAY, -@i % 730, GETDATE()),
        CASE WHEN @i % 3 = 0 THEN 'Payée' ELSE 'En attente' END,
        'Facture détaillée ' + CAST(@i AS VARCHAR)
    );
    
    SET @i = @i + 1;
END;
GO
