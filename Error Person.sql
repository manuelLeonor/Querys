SELECT * FROM erperrorlog WHERE tablename = 'Customer';
-- Visualiza clientes que tienen problema
SELECT * FROM customer WHERE id IN (SELECT tableid FROM erperrorlog WHERE tablename = 'Customer');


-- Query para ingresar la informacion a person
/*
INSERT INTO `person` (	`UUID`, 
								`CreationDate`, 
								`CreationUserID`, 
								`LastUpdate`,   
								`LastUpdateUserID`, 
								`FirstName`, 
								`LastName`, 
								`Name`
							)
SELECT 						UPPER(UUID()) AS 'UUID',
								CURRENT_TIMESTAMP() AS 'Date', 
								CreationUserID AS 'User',
								CURRENT_TIMESTAMP() AS 'DateU', 
								CreationUserID AS 'UserU',
								SUBSTRING(NAME,1,LOCATE(" ", NAME) - 1) AS 'FirstName',
								SUBSTRING(NAME,LOCATE(" ", NAME) + 1) AS 'LastName',
								NAME AS 'Name'
FROM customer 
WHERE 						1 = 1 AND
								id IN (SELECT tableid FROM erperrorlog WHERE tablename = 'Customer');
*/
-- Visualiza los nuevos person 
SELECT * FROM person WHERE NAME IN (SELECT name FROM customer WHERE id IN (SELECT tableid FROM erperrorlog WHERE tablename = 'Customer'));
--
SELECT 	
			C.ID AS 'Customer.ID',
			C.Name AS 'Customer.Name',
			C.PersonID AS 'Customer.PersonID',
			C.PersonUUID AS 'Customer.PersonUUID',
			P.ID AS 'Person.ID',
			P.UUID AS 'Person.UUID',
			P.Name AS 'Person.Name',
			CONCAT("UPDATE Customer SET PersonID =",P.ID,", PersonUUID = '",P.UUID,"' WHERE ID =",C.ID,";") AS 'UPDATE'
FROM person P 
INNER JOIN  customer C ON P.Name = C.NAME
WHERE  P.NAME IN (SELECT name FROM customer WHERE id IN (SELECT tableid FROM erperrorlog WHERE tablename = 'Customer'));

