		ORG 100	
		LDA X
		BSA SH4	
		STA X
		LDA Y
		BSA SH4
		STA Y	
		HLT	
X,		HEX 1234
Y,		HEX 4321

SH4,	HEX 0		
		CIL	
		CIL
		CIL
		CIL
	AND MSK
	BUN SH4 I
MSK,	HEX FFF0
		END
