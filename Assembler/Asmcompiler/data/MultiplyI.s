	ORG 100	 
	LDA NBR	
	STA CTR	
	CLA	
LOP,	ADD OPR	
	ISZ CTR	
	BUN LOP	
	OUT
	STA SUM	
	HLT	
OPR,	DEC 5
NBR,	DEC -4
CTR,	HEX 0
SUM,	HEX 0
PTR,
	END
