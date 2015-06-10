// AsmCompilerView.cpp : implementation of the CAsmCompilerView class
//

#include "stdafx.h"
#include "AsmCompiler.h"

#include "AsmCompilerDoc.h"
#include "AsmCompilerView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerView

IMPLEMENT_DYNCREATE(CAsmCompilerView, CEditView)

BEGIN_MESSAGE_MAP(CAsmCompilerView, CEditView)
	//{{AFX_MSG_MAP(CAsmCompilerView)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
	// Standard printing commands
	ON_COMMAND(ID_ASSEMBLER, OnAssembler)

	ON_COMMAND(ID_FILE_PRINT, CEditView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_DIRECT, CEditView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, CEditView::OnFilePrintPreview)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerView construction/destruction

CAsmCompilerView::CAsmCompilerView()
{
	// TODO: add construction code here

}

CAsmCompilerView::~CAsmCompilerView()
{
}

BOOL CAsmCompilerView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	BOOL bPreCreated = CEditView::PreCreateWindow(cs);
	cs.style &= ~(ES_AUTOHSCROLL|WS_HSCROLL);	// Enable word-wrapping

	return bPreCreated;
}

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerView drawing

void CAsmCompilerView::OnDraw(CDC* pDC)
{
	CAsmCompilerDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);
	// TODO: add draw code for native data here
}

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerView printing

BOOL CAsmCompilerView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// default CEditView preparation
	return CEditView::OnPreparePrinting(pInfo);
}

void CAsmCompilerView::OnBeginPrinting(CDC* pDC, CPrintInfo* pInfo)
{
	// Default CEditView begin printing.
	CEditView::OnBeginPrinting(pDC, pInfo);
}

void CAsmCompilerView::OnEndPrinting(CDC* pDC, CPrintInfo* pInfo)
{
	// Default CEditView end printing
	CEditView::OnEndPrinting(pDC, pInfo);
}

// Get Path to document file
CString CAsmCompilerView::GetPathName()
{
	CAsmCompilerDoc* pDoc = GetDocument();
	return pDoc->GetPathName();//GetPathName();
}

// implement Assembler command
void CAsmCompilerView::OnAssembler()
{
	CString strFileName;
	CString strOutPutFile;
	CCommand objCommand;

	SaveModified();

	if(isModified()){
		return;
	}

	strFileName = GetPathName();
	strOutPutFile  = GetFileName();
	strOutPutFile = strOutPutFile + ".mif";

	if(strFileName.GetLength() == 0)
	{
		MessageBox("please input the assembler file","Warning", MB_ICONEXCLAMATION);
		return;
	}

	if(!objCommand.fntGenerateBnCode(strFileName))
	{
		char strMsg[256];
		sprintf(strMsg, "%s %d", "Error: Line ", objCommand.m_dwErrorLine);
		MessageBox(strMsg, "Error", MB_ICONSTOP);
		objCommand.DeletOutPutFile();
		return;
	}

	
	static char BASED_CODE szFilter[] = "MIF Files (*.mif)|*.mif|All Files (*.*)|*.*||";
	CFileDialog outPutFile(FALSE,NULL,strOutPutFile,OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT,szFilter,NULL);

	//outPutFile.
	if(outPutFile.DoModal() == IDOK)
	{
		strOutPutFile = outPutFile.GetPathName();
		if(strOutPutFile.Find(".mif", strOutPutFile.GetLength() - 4) < 0){
			strOutPutFile = strOutPutFile + ".mif";
		}
		objCommand.OutPutFile(strOutPutFile);

		MessageBox("Done","Warning", MB_OK);
	}else{
		objCommand.DeletOutPutFile();
	}

	
}


/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerView diagnostics

#ifdef _DEBUG
void CAsmCompilerView::AssertValid() const
{
	CEditView::AssertValid();
}

void CAsmCompilerView::Dump(CDumpContext& dc) const
{
	CEditView::Dump(dc);
}

CAsmCompilerDoc* CAsmCompilerView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CAsmCompilerDoc)));
	return (CAsmCompilerDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerView message handlers

BOOL CAsmCompilerView::isModified()
{
	CAsmCompilerDoc* pDoc = GetDocument();
	return pDoc->IsModified();

}

BOOL CAsmCompilerView::SaveModified()
{
	CAsmCompilerDoc* pDoc = GetDocument();
	return pDoc->SaveModified();
}

CString CAsmCompilerView::GetFileName()
{
	CAsmCompilerDoc* pDoc = GetDocument();
	return pDoc->GetTitle();//GetPathName();
}
