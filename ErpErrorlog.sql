SELECT
  eel.TableID AS 'ID',
  eel.CreationDate,
  eel.TableName,
  eel.LastUpdate,
  -- CONVERT(CHAR(8), CURRENT_TIMESTAMP - eel.LastUpdate, 108) AS TimeAgo,
  DATEDIFF(CURRENT_TIMESTAMP(), eel.LastUpdate) AS TimeAgo,
  eel.ErrorDescription,
  eel.Folio AS ExternalID,
  eel.SincroID,
  eel.ProcessName
FROM ErpErrorLog eel
  LEFT JOIN SyncLinkService sls ON sls.ProcessName=eel.ProcessName
WHERE 1=1
ORDER BY LastUpdate;
