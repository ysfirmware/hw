		ORG 100	 
		LDA ADS	
		STA PTR	
		LDA NBR	
		STA CTR	
		CLA	
LOP, 		ADD PTR I	
		ISZ PTR	
		ISZ CTR	
		BUN LOP	
		STA SUM	
		HLT	
ADS,	HEX 150
PTR,	HEX 0
NBR,	DEC -10
CTR,	HEX 0
SUM,	HEX 0

		ORG 150	
		DEC 75	
		DEC 65	
		DEC 23		
		DEC 78
		DEC -13
		DEC 9
		DEC 14
		DEC -48
		DEC 24
		DEC 23
END
