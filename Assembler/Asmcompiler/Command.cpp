// Command.cpp: implementation of the CCommand class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "AsmCompiler.h"
#include "Command.h"
#include "conio.h"
#include <math.h>

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

#define CONTENT_BEGIN		"CONTENT BEGIN\r\n"
//#define END					"END;\r\n"
#define ORG					"ORG"
#define OUTPUT_FILE			"OutPut.mif"
#define TAB					"        "
#define INDIRECT			" I"
#define SPACE               " " 
#define MIR_NUMBER			7
#define NON_MIR_NUMBER		18
#define PSEUDO_NUMBER		4
#define	WIDTH				"WIDTH=16;\r\n"
#define	DEPTH				"DEPTH=4096;\r\n\r\n"

#define	ADDRESS_RADIX		"ADDRESS_RADIX=HEX;\r\n"
#define	DATA_RADIX			"DATA_RADIX=HEX;\r\n\r\n"
#define SYMBOL_ERROR               -1


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


// Pseudo-instruction table
COMMAND_SET PsedoInstrTB[] =
{
	{"ORG", &CCommand::fntAsmORG},
	{"END", &CCommand::fntAsmEND},
	{"DEC", &CCommand::fntAsmDEC},
	{"HEX", &CCommand::fntAsmHEX}
};
// MRI instruction table
COMMAND_SET cmdMriTB[] = 
{
	{"ADD", &CCommand::fntAsmADD},
	{"AND", &CCommand::fntAsmAND},
	{"LDA", &CCommand::fntAsmLDA},
	{"STA", &CCommand::fntAsmSTA},
	{"BUN", &CCommand::fntAsmBUN},
	{"BSA", &CCommand::fntAsmBSA},
	{"ISZ", &CCommand::fntAsmISZ}

};

// None MRI instruction table
COMMAND_SET cmdNonMriTB[] = 
{
	{"CLA", &CCommand::fntAsmCLA},
	{"CLE", &CCommand::fntAsmCLE},
	{"CMA", &CCommand::fntAsmCMA},
	{"CME", &CCommand::fntAsmCME},
	{"CIR", &CCommand::fntAsmCIR},
	{"CIL", &CCommand::fntAsmCIL},
	{"INC", &CCommand::fntAsmINC},
	{"SPA", &CCommand::fntAsmSPA},
	{"SNA", &CCommand::fntAsmSNA},
	{"SZA", &CCommand::fntAsmSZA},
	{"SZE", &CCommand::fntAsmSZE},
	{"HLT", &CCommand::fntAsmHLT},
	{"INP", &CCommand::fntAsmINP},
	{"OUT", &CCommand::fntAsmOUT},
	{"SKI", &CCommand::fntAsmSKI},
	{"SKO", &CCommand::fntAsmSKO},
	{"ION", &CCommand::fntAsmION},
	{"IOF", &CCommand::fntAsmIOF}
};

CCommand::CCommand()
{

}

CCommand::~CCommand()
{

}

BOOL CCommand::fntAsmORG(CString strLineCode)
{

	CString strValue;
	CString strOrg;

	strOrg = strLineCode.Left(3);
	
	strValue = strLineCode.Right(strLineCode.GetLength() - 3);
	strValue.TrimLeft();
	
	int nSpace;
	int intbase = 10;
	char *string;

	nSpace = strValue.Find(" ");
	if(nSpace > 0)
		strValue = strValue.Left(nSpace);

	// Update location counter
	m_dwLC = HexToDword(strtoul(strValue, &string, intbase));
	m_dwLC--;
	m_dwOrg++;
	return TRUE;

}

BOOL CCommand::fntAsmEND(CString strLineCode)
{
	if((m_dwLC - m_lgLineOuput) >= 2)
		OutPutBlank(m_lgLineOuput+1, m_dwLC - 1);
	return TRUE;
}


/*
** Process Dec instruction
*/
BOOL CCommand::fntAsmDEC(CString strLineCode)
{

	char	buffer[256];
	char	szDec[256];
	//char	szTemp[5];
	LONG	lgDec;
	int     intPost;
	CString strValue;

	memset(buffer, 0x00, sizeof(buffer));
	memset(szDec, 0x00, sizeof(szDec));
	//memset(szTemp, 0x00, sizeof(szTemp));

	intPost = strLineCode.Find("DEC");
	if(intPost <0 )
		return FALSE;

	strValue = strLineCode.Right(strLineCode.GetLength() - intPost - 3);
	strValue.TrimLeft();

	intPost = strValue.Find(" ");
	if(intPost > 0)
		strValue = strValue.Left(intPost);

	lgDec = atof(strValue);

	sprintf(szDec,"%x",lgDec);
	if(strlen(szDec) < 4)
	{
		sprintf(buffer,"%04s", szDec);
	}
	else{
		strcpy(buffer, szDec + strlen(szDec) - 4);
	}

	//Out put binary code to mif file
	//sprintf(buffer,"%s%04d%s%s%s\r\n",TAB,m_dwLC,":",TAB,szTemp);
	OutPut(buffer);

	return TRUE;
}

BOOL CCommand::fntAsmHEX(CString strLineCode)
{
	CString strTemp = strLineCode;
	char szBinaryCode[256];
	int nPost;

	nPost = strTemp.Find("HEX");
	if(nPost < 0) return FALSE;

	strTemp = strTemp.Right(strTemp.GetLength() - nPost - 3);
	strTemp.TrimLeft();
	nPost = strTemp.Find(" ");

	if(nPost >= 0)
		strTemp = strTemp.Left(nPost);

	memset(szBinaryCode, 0, sizeof(szBinaryCode));
	sprintf(szBinaryCode,"%04s",strTemp);

	OutPut(szBinaryCode);

	return TRUE;
}

/*
** This function is used to process ADD instruction
*/
BOOL CCommand::fntAsmADD(CString strLineCode)
{
	char	szBuffer[256];
	char	szBinaryCode[256];
	long	lgSymbolAddr;
	DWORD   dwCode;

	memset(szBuffer, 0, sizeof(szBuffer));
	memset(szBinaryCode  , 0, sizeof(szBinaryCode));

	// search symbol address in symbol table
	lgSymbolAddr = SearchSymbol(strLineCode,"ADD");
	if(lgSymbolAddr == SYMBOL_ERROR)
		return FALSE;
	
	if(DirectMRI(strLineCode))
	{
		// Get direct MRI address
		dwCode = 0x1;
	}else
	{
		// Get Indirect MRI address
		dwCode = 0x9;
	}

	// Get binary code of ADD instruction
	sprintf(szBinaryCode,"%x%03x",dwCode,lgSymbolAddr);
	OutPut(szBinaryCode);

	return TRUE;
}
/*
** This function is used to process AND instruction
*/
BOOL CCommand::fntAsmAND(CString strLineCode)
{
	char	szBuffer[256];
	char	szBinaryCode[256];
	long	lgSymbolAddr;
	DWORD   dwCode;

	memset(szBuffer, 0, sizeof(szBuffer));
	memset(szBinaryCode  , 0, sizeof(szBinaryCode));

	// search symbol address in symbol table
	lgSymbolAddr = SearchSymbol(strLineCode, "AND");
	if(lgSymbolAddr == SYMBOL_ERROR)
		return FALSE;
	
	if(DirectMRI(strLineCode))
	{
		// Get direct MRI address
		dwCode = 0x0;
	}else
	{
		// Get Indirect MRI address
		dwCode = 0x8;
	}

	// Get binary code of ADD instruction
	sprintf(szBinaryCode,"%x%03x",dwCode,lgSymbolAddr);
	OutPut(szBinaryCode);

	return TRUE;
}

/*
** This function is used to process AND instruction
*/
BOOL CCommand::fntAsmLDA(CString strLineCode)
{
	char	szBuffer[256];
	char	szBinaryCode[256];
	long	lgSymbolAddr;
	DWORD   dwCode;

	memset(szBuffer, 0, sizeof(szBuffer));
	memset(szBinaryCode  , 0, sizeof(szBinaryCode));

	// search symbol address in symbol table
	lgSymbolAddr = SearchSymbol(strLineCode, "LDA");
	if(lgSymbolAddr == SYMBOL_ERROR)
		return FALSE;
	
	if(DirectMRI(strLineCode))
	{
		// Get direct MRI address
		dwCode = 0x2;
	}else
	{
		// Get Indirect MRI address
		dwCode = 0xA;
	}

	// Get binary code of ADD instruction
	sprintf(szBinaryCode,"%x%03x",dwCode,lgSymbolAddr);
	OutPut(szBinaryCode);

	return TRUE;
}

/*
** This function is used to process AND instruction
*/
BOOL CCommand::fntAsmSTA(CString strLineCode)
{
	char	szBuffer[256];
	char	szBinaryCode[256];
	long	lgSymbolAddr;
	DWORD   dwCode;

	memset(szBuffer, 0, sizeof(szBuffer));
	memset(szBinaryCode  , 0, sizeof(szBinaryCode));

	// search symbol address in symbol table
	lgSymbolAddr = SearchSymbol(strLineCode, "STA");
	if(lgSymbolAddr == SYMBOL_ERROR)
		return FALSE;
	
	if(DirectMRI(strLineCode))
	{
		// Get direct MRI address
		dwCode = 0x3;
	}else
	{
		// Get Indirect MRI address
		dwCode = 0xB;
	}

	// Get binary code of ADD instruction
	sprintf(szBinaryCode,"%x%03x",dwCode,lgSymbolAddr);
	OutPut(szBinaryCode);

	return TRUE;
}

/*
** This function is used to process AND instruction
*/
BOOL CCommand::fntAsmBUN(CString strLineCode)
{
	char	szBuffer[256];
	char	szBinaryCode[256];
	long	lgSymbolAddr;
	DWORD   dwCode;

	memset(szBuffer, 0, sizeof(szBuffer));
	memset(szBinaryCode  , 0, sizeof(szBinaryCode));

	// search symbol address in symbol table
	lgSymbolAddr = SearchSymbol(strLineCode, "BUN");
	if(lgSymbolAddr == SYMBOL_ERROR)
		return FALSE;
	
	if(DirectMRI(strLineCode))
	{
		// Get direct MRI address
		dwCode = 0x4;
	}else
	{
		// Get Indirect MRI address
		dwCode = 0xC;
	}

	// Get binary code of ADD instruction
	sprintf(szBinaryCode,"%x%03x",dwCode,lgSymbolAddr);
	OutPut(szBinaryCode);

	return TRUE;
}

/*
** This function is used to process AND instruction
*/
BOOL CCommand::fntAsmBSA(CString strLineCode)
{
	char	szBuffer[256];
	char	szBinaryCode[256];
	long	lgSymbolAddr;
	DWORD   dwCode;

	memset(szBuffer, 0, sizeof(szBuffer));
	memset(szBinaryCode  , 0, sizeof(szBinaryCode));

	// search symbol address in symbol table
	lgSymbolAddr = SearchSymbol(strLineCode, "BSA");
	if(lgSymbolAddr == SYMBOL_ERROR)
		return FALSE;
	
	if(DirectMRI(strLineCode))
	{
		// Get direct MRI address
		dwCode = 0x5;
	}else
	{
		// Get Indirect MRI address
		dwCode = 0xD;
	}

	// Get binary code of ADD instruction
	sprintf(szBinaryCode,"%x%03x",dwCode,lgSymbolAddr);
	OutPut(szBinaryCode);

	return TRUE;
}

/*
** This function is used to process AND instruction
*/
BOOL CCommand::fntAsmISZ(CString strLineCode)
{
	char	szBuffer[256];
	char	szBinaryCode[256];
	long	lgSymbolAddr;
	DWORD   dwCode;

	memset(szBuffer, 0, sizeof(szBuffer));
	memset(szBinaryCode  , 0, sizeof(szBinaryCode));

	// search symbol address in symbol table
	lgSymbolAddr = SearchSymbol(strLineCode, "ISZ");
	if(lgSymbolAddr == SYMBOL_ERROR)
		return FALSE;
	
	if(DirectMRI(strLineCode))
	{
		// Get direct MRI address
		dwCode = 0x6;
	}else
	{
		// Get Indirect MRI address
		dwCode = 0xE;
	}

	// Get binary code of ADD instruction
	sprintf(szBinaryCode,"%x%03x",dwCode,lgSymbolAddr);
	OutPut(szBinaryCode);

	return TRUE;
}

BOOL CCommand::fntGenerateBnCode(CString strFileName)
{
	BOOL bResult;
	if(strFileName.GetLength() <= 0)
		return FALSE;
	
	m_strInPutFile = strFileName;

	m_strOutPutFile = CreateTempFile();
	
	CreateOuputFile(m_strOutPutFile);


	// Fist Pass
	m_ptrFirstSymbol = NULL; 
	m_ptrLastSymbol = NULL;
	fntFirsftPass(strFileName);

	// Second pass
	bResult = fntSecondPass(strFileName);

	End();

	// Free memory of Symbol symbol tabel
	if(m_ptrFirstSymbol != NULL)
			FreeSymbolTable(m_ptrFirstSymbol);

	return bResult;
}

BOOL CCommand::CreateOuputFile(CString strOutPutFileName)
{
	FILE* pFile;

	
	pFile = fopen(strOutPutFileName,"wb");
	if(pFile == NULL)
		return FALSE;

	fwrite(WIDTH,		  1, strlen(WIDTH),			pFile);
	fwrite(DEPTH,		  1, strlen(DEPTH),			pFile);
	fwrite(ADDRESS_RADIX, 1, strlen(ADDRESS_RADIX), pFile);
	fwrite(DATA_RADIX,    1, strlen(DATA_RADIX),	pFile);
	fwrite(CONTENT_BEGIN, 1, strlen(CONTENT_BEGIN), pFile);
	fclose(pFile);
	pFile = NULL;
	return TRUE;
}

void CCommand::fntFirsftPass(CString strFileName)
{
	char szLineCode[256];
	FILE* pFile;

	pFile = fopen(strFileName, "rb");

	if(pFile == NULL)
		return;

	m_dwLC = 0;
	m_dwOrg = 0;

	while(!feof(pFile))
	{
		// Scans line of code
		fgets(szLineCode, 256, pFile);

		if(!IsLineCode(szLineCode))
			continue;

		// Check if is lable, add address symbol to address symbols table
		if(!CheckSymbol(szLineCode))
		{
			// Check if content ORG instruction, set value of location counter LC
			if(!CheckORG(szLineCode))
			{
				if(CheckEnd(szLineCode))
				{
					// Go to second pass
					fclose(pFile);
					return;
				}
			}
		}
		m_dwLC++;
		
	}
	fclose(pFile);	
}

BOOL CCommand::CheckSymbol(CString strLineCode)
{
	CString strTemp;
	int nPost;

	strTemp = strLineCode;
	nPost = strTemp.Find("/");
	// Remove comment field
	if(nPost > 0)
		strTemp = strTemp.Left(nPost);

	strTemp.TrimLeft();

	int i = 0;
	while(i < strTemp.GetLength())
	{
		if(strTemp.GetAt(i) == ',')
		{
			strTemp = strTemp.Left(i);
			strTemp.TrimRight();
			if(m_ptrFirstSymbol == NULL)
			{
				// Create Symbol symol table
				PSYMBOL pSymbol;
				pSymbol = (SYMBOL*)malloc(sizeof(SYMBOL));
				pSymbol->dwLc = m_dwLC;
				//pSymbol->dwOrg = m_dwOrg;
				strcpy(pSymbol->strSymBol, strTemp);
				pSymbol->ptsNext = NULL;
				m_ptrFirstSymbol = pSymbol;
				m_ptrLastSymbol = pSymbol;
			}
			else{
				// Add new Symbol symbol to symbol Symbol
				PSYMBOL pSymbol;
				pSymbol = (SYMBOL*)malloc(sizeof(SYMBOL));
				pSymbol->dwLc = m_dwLC;
				//pSymbol->dwOrg = m_dwOrg;
				strcpy(pSymbol->strSymBol, strTemp);
				pSymbol->ptsNext = NULL;
				m_ptrLastSymbol->ptsNext = pSymbol;
				m_ptrLastSymbol = pSymbol;
			}
			return TRUE;
		}
		i++;
	}


	return FALSE;
}
/*
**	Free memory of Symbol table 
**
*/
void CCommand::FreeSymbolTable(PSYMBOL ptrFistSymbol)
{
	PSYMBOL ptsIntermediate;
	PSYMBOL ptrIndex;

	ptrIndex = ptrFistSymbol;

    while(ptrIndex != NULL)
    {
        ptsIntermediate = ptrIndex->ptsNext;
        free(ptrIndex);
        ptrIndex = ptsIntermediate;
    }
    ptsIntermediate = NULL;
	ptrIndex = NULL;

}

/*
**	Line code content ORG instruction
**
*/
BOOL CCommand::CheckORG(CString strLineCode)
{
	CString strValue;
	CString strOrg;
	int		nPost;
	
	strOrg = strLineCode;
	strOrg.TrimLeft();
	
	nPost = strOrg.Find("/");
	// Remove comment field
	if(nPost > 0)
		strOrg = strOrg.Left(nPost);
	// Check 
	if(strOrg.Find(ORG) >= 0)
	{
		strValue = strOrg.Right(strOrg.GetLength() - 3);
		strValue.TrimLeft();
		
		int nSpace;
		int intbase = 10;
		char *string;

		nSpace = strValue.Find(" ");
		if(nSpace >= 0)
			strValue = strValue.Left(nSpace);

		// Update location counter
		m_dwLC = HexToDword(strtoul(strValue, &string, intbase));
		m_dwLC--;
		m_dwOrg++;
		return TRUE;
	}
	return FALSE;
}

/*
**	Line code content END instruction
**
*/
BOOL CCommand::CheckEnd(CString strLineCode)
{
	CString strEnd;
	
	strEnd = strLineCode;
	strEnd.TrimLeft();
	
	strEnd = strEnd.Left(3);
	if(strEnd == END)
	{
		return TRUE;
	}
	return FALSE;
}

/*
** Processing of second pass
*/
BOOL CCommand::fntSecondPass(CString strFineName)
{
	FILE* pFile;
	char buffer[256];
	m_dwLC = 0;
	m_dwOrg = 0;
	m_dwErrorLine = 0;
	m_lgLineOuput = -1;

	pFile = fopen(strFineName, "rb");
	if(pFile == NULL)
		return FALSE;

	while(!feof(pFile))
	{
		// Scand line of code
		fgets(buffer, 256, pFile);

		m_dwErrorLine++;
		if(!IsLineCode(buffer))
			continue;
		// Process the line of code processing
		if(!ParserLineCode(buffer))
		{
			fclose(pFile);
			pFile = NULL;
			return FALSE;
		}
		m_dwLC++;
	}


	fclose(pFile);
	pFile = NULL;

	return TRUE;

}

/*
** Analyse line code and out put binary code to mif file
*/
BOOL CCommand::ParserLineCode(CString strBuffer)
{

	CString strLineCode;
	CString strInstruction;
	int intIndex = 0;
	PCOMMAND_SET pCommand;

	strLineCode = strBuffer;
	strLineCode.TrimLeft();

	int nPost;
	nPost = strLineCode.Find("/");
	// Remover comment field
	if(nPost > 0)
		strLineCode = strLineCode.Left(nPost);

	// Remover cari_line character
	nPost = strLineCode.Find("\r");
	if(nPost > 0)
		strLineCode = strLineCode.Left(nPost);
	
	strLineCode.TrimRight();

	//strInstruction = strLineCode.Left(3);
	if(strLineCode.Find(END) >= 0)
	{	
		if((m_dwLC - m_lgLineOuput) >= 2)
		OutPutBlank(m_lgLineOuput+1, m_dwLC - 1);
		return TRUE;
	}

	// Check Pseudo-instruction
	while(intIndex < 4)
	{
		pCommand = &PsedoInstrTB[intIndex];
		if(strLineCode.Find(pCommand->szCommandName) >= 0)
		{
			if(!CheckError(strLineCode, pCommand->szCommandName))
				return FALSE;
			return(this->*(pCommand->pExecute))(strLineCode);
			//return TRUE;
		}
		intIndex++;
	}

	intIndex = 0;
	// Check MRI instruction
	while(intIndex < MIR_NUMBER)
	{
		pCommand = &cmdMriTB[intIndex];
		if(strLineCode.Find(pCommand->szCommandName) >= 0)
		{
			if(!CheckError(strLineCode, pCommand->szCommandName))
				return FALSE;
			return (this->*(pCommand->pExecute))(strLineCode);
			//return TRUE;
		}
		intIndex++;
	}

	// Check NON-MRI instruction
	intIndex = 0;
	while(intIndex < NON_MIR_NUMBER)
	{
		pCommand = &cmdNonMriTB[intIndex];
		if(strLineCode.Find(pCommand->szCommandName) >= 0)
		{
			if(!CheckError(strLineCode, pCommand->szCommandName))
				return FALSE;
			return (this->*(pCommand->pExecute))(strLineCode);
			//return TRUE;
		}
		intIndex++;
	}

	if(CheckLabel(strLineCode))
		return TRUE;

	return FALSE;
}
/*
** This function is used to output a buffer to mif file
*/
BOOL CCommand::OutPut(char *szBuffer)
{
	FILE* pFile;
	char buffer[256];

	memset(buffer, 0, sizeof(buffer));

	if((m_dwLC - m_lgLineOuput) >= 2)
		OutPutBlank(m_lgLineOuput+1, m_dwLC - 1);
	
	pFile = fopen(m_strOutPutFile,"ab");
	if(pFile == NULL)
		return FALSE;

	sprintf(buffer,"%s%04x%s%s%s%s\r\n",TAB,m_dwLC," :",TAB,szBuffer, ";");

	_strupr(buffer);

	fwrite(buffer,1,strlen(buffer),pFile);
	fclose(pFile);
	pFile = NULL;
	m_lgLineOuput = m_dwLC;

	return TRUE;

}

long CCommand::SearchSymbol(CString strLineCode, CString strCommand)
{
	CString		strSymbol;
	PSYMBOL		ptrSymbol;
	int			nPost;

	// Get symbol
	nPost = strLineCode.Find(strCommand);
	if(nPost >= 0)
		strSymbol = strLineCode.Right(strLineCode.GetLength() - nPost - strCommand.GetLength());

	strSymbol.TrimLeft();

	nPost = strSymbol.Find(" ");
	if(nPost > 0)
		strSymbol = strSymbol.Left(nPost);

	
	ptrSymbol = m_ptrFirstSymbol;
	while(ptrSymbol != NULL)
	{
		if(strSymbol == ptrSymbol->strSymBol)
			return ptrSymbol->dwLc;
		ptrSymbol = ptrSymbol->ptsNext;
	}
	return SYMBOL_ERROR;

}

/*
** This function is used to check whether MRI instruction is direct or indirect address
*/
BOOL CCommand::DirectMRI(CString strLineCode)
{
	CString strTemp;
	strTemp = strLineCode.Right(strlen(INDIRECT));
	if(strTemp == INDIRECT)
		return FALSE;
	return TRUE;
}


BOOL CCommand::fntAsmCLA(CString strLineCode)
{
	OutPut("7800");
	return TRUE;
}
BOOL CCommand::fntAsmCLE(CString strLineCode)
{

	OutPut("7400");
	return TRUE;
}
BOOL CCommand::fntAsmCMA(CString strLineCode)
{

	OutPut("7200");
	return TRUE;
}
BOOL CCommand::fntAsmCME(CString strLineCode)
{

	OutPut("7100");
	return TRUE;
}
BOOL CCommand::fntAsmCIR(CString strLineCode)
{
	OutPut("7080");
	return TRUE;
}
BOOL CCommand::fntAsmCIL(CString strLineCode)
{

	OutPut("7040");
	return TRUE;
}
BOOL CCommand::fntAsmINC(CString strLineCode)
{
	OutPut("7020");
	return TRUE;
}
BOOL CCommand::fntAsmSPA(CString strLineCode)
{
	OutPut("7010");
	return TRUE;
}
BOOL CCommand::fntAsmSNA(CString strLineCode)
{
	OutPut("7008");
	return TRUE;
}
BOOL CCommand::fntAsmSZA(CString strLineCode)
{
	OutPut("7004");
	return TRUE;
}
BOOL CCommand::fntAsmSZE(CString strLineCode)
{

	OutPut("7002");
	return TRUE;
}
BOOL CCommand::fntAsmHLT(CString strLineCode)
{

	OutPut("7001");
	return TRUE;
}
BOOL CCommand::fntAsmINP(CString strLineCode)
{
	OutPut("F800");
	return TRUE;
}
BOOL CCommand::fntAsmOUT(CString strLineCode)
{
	OutPut("F400");
	return TRUE;
}
BOOL CCommand::fntAsmSKI(CString strLineCode)
{
	OutPut("F200");
	return TRUE;
}
BOOL CCommand::fntAsmSKO(CString strLineCode)
{
	OutPut("F100");
	return TRUE;
}
BOOL CCommand::fntAsmION(CString strLineCode)
{
	OutPut("F080");
	return TRUE;
}
BOOL CCommand::fntAsmIOF(CString strLineCode)
{
	OutPut("F404");
	return TRUE;
}

void CCommand::End()
{
	FILE* pFile;
	pFile = fopen(m_strOutPutFile,"ab");

	if(pFile == NULL)
		return;
	
	fwrite("END;/r/n",1,strlen("END;"),pFile);

	fclose(pFile);
	pFile = NULL;

}

DWORD CCommand::HexToDword(DWORD n)
{
	if(n > 9999)
		return 0;
	DWORD dw;
	DWORD n1, n2, n3, n4;
	n1 = n / 1000;
	n2 = (n-n1*1000)/100;
	n3 = (n -n1*1000 - n2*100)/10;
	n4 = (n -n1*1000 - n2*100 - n3*10);
	dw = n1*pow(16,3) + n2*pow(16,2) + n3*16 + n4;
	return dw;

}

BOOL CCommand::IsLineCode(CString strLine)
{
	CString strTemp;
	int nPost;

	strTemp = strLine;
	
	nPost = strTemp.Find("\r");	
	if(nPost >= 0)
		strTemp = strTemp.Left(nPost);

	nPost = strTemp.Find("/");	
	if(nPost >= 0)
		strTemp = strTemp.Left(nPost);

	strTemp.TrimLeft();
	strTemp.TrimRight();
	
	if(strTemp.GetLength() == 0)
		return FALSE;
	return TRUE;

}

BOOL CCommand::OutPutBlank(DWORD dwFrom, DWORD dwTo)
{
	char szBuffer[256];
	FILE *pFile;

	memset(szBuffer,0,sizeof(szBuffer));

	if(dwFrom == dwTo)
	{
		sprintf(szBuffer,"%s%04x :%s%04x;\r\n",TAB,dwFrom,TAB,0);
	}
	else{
		sprintf(szBuffer,"%s[%04x..%04x] : %s%04x;\r\n",TAB, dwFrom, dwTo,TAB,0);
	}

	pFile = fopen(m_strOutPutFile,"ab");
	if(pFile == NULL)
		return FALSE;
	
	_strupr(szBuffer);
	fwrite(szBuffer, strlen(szBuffer), 1, pFile);
	fclose(pFile);

	m_lgLineOuput = dwTo;

	return TRUE;
}

BOOL CCommand::OutPutFile(CString strOutPutFileName)
{
	BOOL bResult;
	DeleteFile(strOutPutFileName);
	bResult = MoveFile(m_strOutPutFile, strOutPutFileName);

	/*LPVOID lpMsgBuf;
    FormatMessage( 
    FORMAT_MESSAGE_ALLOCATE_BUFFER | 
    FORMAT_MESSAGE_FROM_SYSTEM | 
    FORMAT_MESSAGE_IGNORE_INSERTS,
    NULL,
    GetLastError(),
    MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
    (LPTSTR) &lpMsgBuf,
    0,
    NULL 
	);
	// Process any inserts in lpMsgBuf.
	// ...
	// Display the string.
	MessageBox( NULL, (LPCTSTR)lpMsgBuf, "Error", MB_OK | MB_ICONINFORMATION );
	// Free the buffer.
	LocalFree( lpMsgBuf );*/

	
	return TRUE;
}

BOOL CCommand::DeletOutPutFile()
{
	DeleteFile(m_strOutPutFile);
	return TRUE;
}

// Create temporary binary file
CString CCommand::CreateTempFile()
{
	char strPath[MAX_PATH +1];

	memset(strPath, 0, sizeof(strPath));
	GetCurrentDirectory(MAX_PATH, strPath);
	strcat(strPath,"\\Tepm");

	return strPath;
}

BOOL CCommand::CheckLabel(CString strLineCode)
{
	CString strTemp = strLineCode;
	int i = 0;
	BOOL bLable = FALSE;
	while(i < strTemp.GetLength())
	{
		if(strTemp.GetAt(i) == ',')
		{
			bLable = TRUE;
			break;
		}
		i++;
	}
	
	if(!bLable)
		return FALSE;

	strTemp = strTemp.Right(strTemp.GetLength() - i - 1);
	strTemp.TrimLeft();
	strTemp.TrimRight();
	
	if(strTemp.GetLength() == 0) return TRUE;

	return FALSE;

}

BOOL CCommand::CheckError(CString strLineCode, CString strCmd)
{
	CString strTemp;
	strTemp = strLineCode;
	int nPost;
	char ch;

	nPost = strTemp.Find(strCmd);
	if(nPost > 0)
	{
		ch = strTemp.GetAt(nPost - 1);
		if(ch != 9 && ch != 32) // 9 -> HT && 32-> Space
		{
				return FALSE;
		}
		strTemp = strTemp.Right(strTemp.GetLength() - nPost);
	}

	nPost = strTemp.Find(SPACE);
	if(nPost > 0)
		strTemp = strTemp.Left(nPost);
	
	strTemp.TrimLeft();
	strTemp.TrimRight();

	if(strTemp != strCmd)
		return FALSE;

	return TRUE;
}
