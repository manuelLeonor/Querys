SELECT 	CF.ID,S.Number,
			S.Name,
			CD.Serial,
			CD.Folio,
			DT.Name,
			EXTRACTVALUE(CF.XML, '//cfdi:Comprobante/cfdi:Emisor/@Rfc') AS 'Emisor',
			EXTRACTVALUE(CF.XML,'//cfdi:Comprobante/cfdi:Emisor/@Nombre') AS 'Razon Social',
						EXTRACTVALUE(CF.XML,'//cfdi:Comprobante/@SubTotal') AS 'SubTotal',
			EXTRACTVALUE(CF.XML,'//cfdi:Comprobante/@Total') AS 'Total',
			CD.Total
			FROM cfdidocument CD 
INNER JOIN store S ON CD.StoreID = S.ID
INNER JOIN cfdifile CF ON CD.CFDiFileID = CF.ID
INNER JOIN documenttype DT ON DT.ID = CD.DocumentTypeID
WHERE S.ID = 5 AND CD.CustomerID = 1 AND CD.DocumentTypeID = 30 
ORDER BY CD.CreationDate DESC


