/****************************************************************************************/
--  Fecha......: 2021-07-30
--  Autor......: P.T.B.I Juan Manuel Leonor Sanchez     
--  Motor......: Maria DB
--  Descripción: Actualizar Reportes  Masivos
--  Notas......:

/****************************************************************************************/
UPDATE report R
LEFT JOIN 	(
					SELECT 
								ReportTypeID,
								StoreID,
								Template,
								workstation,
								Description
					FROM report 
					WHERE 
								1=1
								AND StoreID = 21
								AND WorkStation = 'A'
								AND ReportTypeID = 29
				) R2 ON R2.ReportTypeID = R.ReportTypeID
SET R.Template = R2.Template, R.Description = r2.Description, R.LastUpdateUserID = -1, R.LastUpdate = CURRENT_TIMESTAMP
WHERE
		1 = 1
		AND R.ReportTypeID = 29
