		ORG 100
		LDA X	
		BSA OR	
		HEX 3AF6
		STA Y	
		HLT	
X,		HEX 7B95
Y,		HEX 0
OR,		HEX 0
		CMA
		STA TMP	
		LDA OR I	
		CMA	
		AND TMP	
		CMA	
		ISZ OR	
		BUN OR I	
TMP,	HEX 0
		END
