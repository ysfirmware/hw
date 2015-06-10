		ORG 100
		LDA AL
		ADD BL
		STA CL
		CLA	
		CIL		
		ADD AH
		ADD BH
		STA CH
		HLT
AL,		DEC 45
AH,		DEC 97
BL,		DEC 25
BH,		DEC 99
CL,
CH,
		END
