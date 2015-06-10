// Command.h: interface for the CCommand class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_COMMAND_H__CCDC80DB_A8E6_425F_B1AB_D0673A5A1C76__INCLUDED_)
#define AFX_COMMAND_H__CCDC80DB_A8E6_425F_B1AB_D0673A5A1C76__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

//////////////////////////////////////////////////////////////////////////////////////////////
// Definition of Peseudo-instruction
#define ORG "ORG"
#define END "END"
#define DEC "DEC"
#define HEX "HEX"



/********************************************************************************************/
typedef struct tagSymbol
{
	DWORD   	dwLc;
	//DWORD       dwOrg;
	char		strSymBol[10];
	struct		tagSymbol *ptsNext;
}SYMBOL,*PSYMBOL;
/********************************************************************************************/


class CCommand;
typedef BOOL (CCommand::*pCallBackfn)(CString strLineCode);

typedef struct tagCmd
{
    //int                     nCmdLength;
    //char                    szValue[10];
	char                    szCommandName[10];
    pCallBackfn             pExecute;
} COMMAND_SET, *PCOMMAND_SET;

/*// Pseudo-instruction table
typedef struct tagCmd
{
    int                     nCmdLength;
    char                    szCmdCode[10];
    pCallBackfn             pExecute;
	char                    szCommandName[10];
} COMMAND_SET, *PCOMMAND_SET;*/ 


class CCommand  
{
public:
	BOOL CheckError(CString strLineCode, CString strCmd);
	BOOL CheckLabel(CString strLineCode);
	CString CreateTempFile();
	BOOL DeletOutPutFile();
	BOOL OutPutFile(CString strOutPutFileName);
	void	FreeSymbolTable(PSYMBOL ptrFistSymbol);
	CCommand();
	virtual ~CCommand();
	BOOL	fntGenerateBnCode(CString strFileName);
	DWORD   m_dwErrorLine;

	// Pseudo-instruction
	BOOL	fntAsmORG(CString strLineCode);
	BOOL	fntAsmEND(CString strLineCode);
	BOOL	fntAsmDEC(CString strLineCode);
	BOOL	fntAsmHEX(CString strLineCode);

	// MRI instruction
	BOOL	fntAsmADD(CString strLineCode);
	BOOL	fntAsmAND(CString strLineCode);
	BOOL	fntAsmLDA(CString strLineCode);
	BOOL	fntAsmSTA(CString strLineCode);
	BOOL	fntAsmBUN(CString strLineCode);
	BOOL	fntAsmBSA(CString strLineCode);
	BOOL	fntAsmISZ(CString strLineCode);

	// None-MRI instruction
	BOOL	fntAsmCLA(CString strLineCode);
	BOOL	fntAsmCLE(CString strLineCode);
	BOOL	fntAsmCMA(CString strLineCode);
	BOOL	fntAsmCME(CString strLineCode);
	BOOL	fntAsmCIR(CString strLineCode);
	BOOL	fntAsmCIL(CString strLineCode);
	BOOL	fntAsmINC(CString strLineCode);
	BOOL	fntAsmSPA(CString strLineCode);
	BOOL	fntAsmSNA(CString strLineCode);
	BOOL	fntAsmSZA(CString strLineCode);
	BOOL	fntAsmSZE(CString strLineCode);
	BOOL	fntAsmHLT(CString strLineCode);
	BOOL	fntAsmINP(CString strLineCode);
	BOOL	fntAsmOUT(CString strLineCode);
	BOOL	fntAsmSKI(CString strLineCode);
	BOOL	fntAsmSKO(CString strLineCode);
	BOOL	fntAsmION(CString strLineCode);
	BOOL	fntAsmIOF(CString strLineCode);
	// Address symbol table
private:
	BOOL OutPutBlank(DWORD dwFrom, DWORD dwTo);
	BOOL IsLineCode(CString strLine);
	DWORD HexToDword(DWORD dwValue);
	void	End();
	BOOL	DirectMRI(CString strLineCode);
	LONG	SearchSymbol(CString strLineCode, CString strCommand);
	BOOL	OutPut(char* szBuffer);
	BOOL	ParserLineCode(CString strLineCode);
	BOOL	fntSecondPass(CString strFineName);
	BOOL	CheckEnd(CString strLineCode);
	BOOL	CheckORG(CString strLineCode);
	BOOL	CheckSymbol(CString strLineCode);
	void	fntFirsftPass(CString strFileName);
	PSYMBOL m_ptrFirstSymbol, m_ptrLastSymbol;
	BOOL	CreateOuputFile(CString strOutPutFileName);
	DWORD	m_dwLC;
	CString m_strInPutFile;
	CString m_strOutPutFile;
	DWORD   m_dwOrg;
	LONG    m_lgLineOuput;
	
};

#endif // !defined(AFX_COMMAND_H__CCDC80DB_A8E6_425F_B1AB_D0673A5A1C76__INCLUDED_)
