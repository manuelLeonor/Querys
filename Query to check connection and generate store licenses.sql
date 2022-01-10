SET @ExpirationDate = '2022-12-30';

SELECT 	DATABASE() AS 'BASE DE DATOS',
			S.ID AS 'StoreID',
			S.Number AS 'StoreNumber',
			S.Name AS 'StoreName',
			WH.Name AS 'WarehouseName',
			CASE
				WHEN S.Sync = 'T' THEN 'SINCRONIZA'
				ELSE 'NO SINCRONIZA'
			END AS 'Sync',
			S.register,
			S.License,
			CASE 
				WHEN SC.Connected = 1 THEN 'Conectado'
				ELSE 'Sin Conexion'
			END AS 'Conexion',
			SC.LastConnection AS 'Ultima Conexion',

			SUBSTRING_INDEX(SUBSTRING_INDEX(S.ChangeRemoteServiceConnection, ':', 1), ':', -1) as PrimerDato, 
			SUBSTRING_INDEX(SUBSTRING_INDEX(S.ChangeRemoteServiceConnection, ':', 2), ':', -1) as SegundoDato,
			CONCAT('{"Database":"',DATABASE(),'","StoreNumber":"',S.Number,'","ExpirationDate":"',@ExpirationDate,'"}')
FROM store S 
LEFT JOIN storeconnection SC ON SC.StoreID = S.ID 
LEFT JOIN warehouse WH ON WH.ID = S.ID
GROUP BY S.ID



