SET @StartDate = '2021-10-19';
SET @EndDate = '2021-10-19';
SET @StoreID = 0;
SELECT
			S.Number AS 'storeNumber' ,
			S.Name AS 'storeName' ,
			SUM(D.Total) AS 'VTA ($)' ,
			SUM(D.Quantity) AS 'VTA (U)' ,
			(SUM(D.Total) - SUM(D.Tax1 + D.Tax2 + D.Tax3)) -SUM(D.Cost * D.Quantity) AS 'UT ($)' ,
			CASE
					WHEN ( SUM(D.Total) - SUM(D.Tax1 + D.Tax2 + D.Tax3) ) = 0 THEN 0
					ELSE(((SUM(D.Total) - SUM(D.Tax1 + D.Tax2 + D.Tax3)) - SUM(D.Cost * D.Quantity)) /(SUM(D.Total) - SUM(D.Tax1 + D.Tax2 + D.Tax3))) * 100
			END AS 'MRG (%)' ,
			CASE
					WHEN SDS.Receipts = 0 THEN 0
					ELSE SDS.ReceiptsTotal / SDS.Receipts
			END AS 'TK PRM ($)' ,
			CASE
					WHEN SDS.Receipts = 0 THEN 0
					ELSE SDS.ReceiptsQuantity / SDS.Receipts
			END AS 'TK PRM (U)',
			sdLastYear.Sold AS 'AÑO P ($)'
FROM SaleDocument SD
INNER JOIN (
					SELECT 	StoreID ,
								SUM(	CASE
											WHEN sdRE.DocumentTypeID <> 15 THEN 1
											ELSE 0
										END) AS Receipts ,
								SUM(	CASE
											WHEN sdRE.DocumentTypeID <> 15 THEN Dre2.Total
											ELSE 0
										END) AS ReceiptsTotal ,
								SUM(	CASE
											WHEN sdRE.DocumentTypeID = 15 THEN Dre2.Total
											ELSE 0
										END) AS ReturnsTotal ,
								SUM(	CASE
											WHEN sdRE.DocumentTypeID <> 15 THEN Dre2.Quantity
											ELSE 0
										END) AS ReceiptsQuantity
					FROM SaleDocument sdRE
					INNER JOIN (
										select 
													SaleDocumentID, 
													SUM(Quantity) Quantity, 
													SUM(Total) Total
										from SaleDocumentDetail
										WHERE 	(ItemKitID IS NULL OR ItemKitID = 0)
													AND (RecordStatusID = 1 OR RecordStatusID IS NULL)
										GROUP BY SaleDocumentID
									) Dre2 ON Dre2.SaleDocumentID = sdRE.ID
					WHERE 	1 = 1
								AND sdRE.Dte BETWEEN @StartDate AND @EndDate 
								AND sdRE.DocumentStatusID = 1 						
								AND (
										(@StoreID='0' AND COALESCE(sdRE.StoreID, 0) = COALESCE(sdRE.StoreID, 0)) OR
										(@StoreID<>'0' AND sdRE.StoreID IN (@StoreID))
		  							 )								
					GROUP BY
								sdRE.StoreID
				) SDS ON SDS.StoreID = SD.StoreID
INNER JOIN SaleDocumentDetail D ON SD.ID = D.SaleDocumentID AND D.ItemKitID IS NULL
LEFT JOIN (
					SELECT 	StoreID ,
								SUM(D2.Total) AS Sold
					FROM SaleDocument SD2
					INNER JOIN SaleDocumentDetail D2 ON D2.SaleDocumentID = SD2.ID
																AND D2.ItemKitID IS NULL
																AND SD2.Dte BETWEEN Date_add(@StartDate, INTERVAL  -1 YEAR) AND DATE_ADD(@EndDate, INTERVAL  -1 YEAR)
																AND SD2.DocumentStatusID = 1 
																AND (SD2.RecordStatusID = 1 OR SD2.RecordStatusID IS NULL)
																AND (
																		(@StoreID='0' AND COALESCE(SD2.StoreID, 0) = COALESCE(SD2.StoreID, 0)) OR
																		(@StoreID<>'0' AND SD2.StoreID IN (@StoreID))
		  							 								 )
					GROUP BY StoreID
				) sdLastYear ON sdLastYear.StoreID = SDS.StoreID
INNER JOIN Store S ON S.ID = SD.StoreID
WHERE 	1 = 1
			AND SD.Dte BETWEEN @StartDate AND @EndDate 
			AND SD.DocumentStatusID = 1
			AND (
					(@StoreID='0' AND COALESCE(SD.StoreID, 0) = COALESCE(SD.StoreID, 0)) OR
					(@StoreID<>'0' AND SD.StoreID IN (@StoreID))
		  		 )
GROUP BY
			S.Number,
			S.Name,
			SDS.Receipts ,
			SDS.ReceiptsTotal ,
			SDS.ReceiptsQuantity ,
			sdLastYear.Sold
			
