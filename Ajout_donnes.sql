SET NOCOUNT ON;

DECLARE @i INT = 1;
DECLARE @Nom NVARCHAR(255);
DECLARE @Email NVARCHAR(255);
DECLARE @Adresse NVARCHAR(500);
DECLARE @Telephone NVARCHAR(20);
DECLARE @DateInscription DATETIME;
DECLARE @Montant DECIMAL(18,6);
DECLARE @DateFacture DATETIME;
DECLARE @Statut NVARCHAR(50);
DECLARE @Description NVARCHAR(1000);

WHILE @i <= 100000  -- Ajout de 100,000 clients et factures pour simuler la charge
BEGIN
    -- Données clients
    SET @Nom = 'Client' + CAST(@i AS NVARCHAR);
    SET @Email = 'client' + CAST(@i AS NVARCHAR) + '@example.com';
    SET @Adresse = 'Adresse ' + CAST(@i AS NVARCHAR);
    SET @Telephone = '06' + RIGHT('000000' + CAST(@i AS NVARCHAR), 6);
    SET @DateInscription = DATEADD(DAY, -(@i % 365), GETDATE());

    INSERT INTO Clients (Nom, Email, Adresse, Telephone, DateInscription)
    VALUES (@Nom, @Email, @Adresse, @Telephone, @DateInscription);

    -- Données factures
    SET @Montant = ROUND(RAND() * 5000, 2);
    SET @DateFacture = DATEADD(DAY, -(@i % 730), GETDATE());
    SET @Statut = CASE WHEN @i % 3 = 0 THEN 'Payée' ELSE 'En attente' END;
    SET @Description = 'Facture de prestation ' + CAST(@i AS NVARCHAR);

    INSERT INTO Factures (ClientID, Montant, DateFacture, Statut, Description)
    VALUES ((@i % 1000) + 1, @Montant, @DateFacture, @Statut, @Description);

    SET @i = @i + 1;
END;
GO
