-- Index sur le nom des clients pour accélérer les recherches
CREATE INDEX idx_nom ON Clients(Nom);

-- Index sur l'email des clients pour éviter les scans complets
CREATE INDEX idx_email ON Clients(Email);

-- Index sur la date de facture pour accélérer les recherches par période
CREATE INDEX idx_datefacture ON Factures(DateFacture);

-- Index sur le statut pour améliorer les filtres sur factures payées ou en attente
CREATE INDEX idx_statut ON Factures(Statut);


-- Vérification du taux de fragmentation
SELECT 
    OBJECT_NAME(ps.object_id) AS TableName, 
    i.name AS IndexName, 
    avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
INNER JOIN sys.indexes AS i 
    ON ps.object_id = i.object_id AND ps.index_id = i.index_id
WHERE avg_fragmentation_in_percent > 10;


-- Réorganisation des index si la fragmentation est modérée (10 à 30%)
ALTER INDEX ALL ON Clients REORGANIZE;
ALTER INDEX ALL ON Factures REORGANIZE;

-- Reconstruction des index si la fragmentation est élevée (>30%)
ALTER INDEX ALL ON Clients REBUILD;
ALTER INDEX ALL ON Factures REBUILD;




UPDATE STATISTICS Clients;
UPDATE STATISTICS Factures;

