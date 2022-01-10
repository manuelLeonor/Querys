SELECT 	DATABASE(),
			sls.LinkServiceUniqueID,
		  	sls.ProcessName,
			SLS.LastMessage,
			sls.LastError,
			CASE
    			WHEN sls.TotalIterations=0 THEN ''
    			ELSE CONCAT( 
      			'% [',
      			INSERT(
		        REPEAT(' ', 10),
		        1,
		        10 * sls.CurrentIteration / sls.TotalIterations,
		        REPEAT(
		          '=',
		          10 * sls.CurrentIteration / sls.TotalIterations
		        )
			      ),
			      '] ',
			      sls.CurrentIteration,
			      '/',
			      sls.TotalIterations,
			      ' ',
			      sls.CurrentIteration - sls.TotalIterations
		   	)
			END AS Progress,
			SLS.LastCheck,
  			SLS.LastStart,
  			SLS.LastEnd,
		  	SLS.FieldsMapping,
		  	SLS.StatementTemplate
FROM synclinkservice SLS
