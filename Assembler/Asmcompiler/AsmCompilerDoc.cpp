// AsmCompilerDoc.cpp : implementation of the CAsmCompilerDoc class
//

#include "stdafx.h"
#include "AsmCompiler.h"

#include "AsmCompilerDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerDoc

IMPLEMENT_DYNCREATE(CAsmCompilerDoc, CDocument)

BEGIN_MESSAGE_MAP(CAsmCompilerDoc, CDocument)
	//{{AFX_MSG_MAP(CAsmCompilerDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerDoc construction/destruction

CAsmCompilerDoc::CAsmCompilerDoc()
{
	// TODO: add one-time construction code here

}

CAsmCompilerDoc::~CAsmCompilerDoc()
{
}

BOOL CAsmCompilerDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	((CEditView*)m_viewList.GetHead())->SetWindowText(NULL);

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerDoc serialization

void CAsmCompilerDoc::Serialize(CArchive& ar)
{
	// CEditView contains an edit control which handles all serialization
	((CEditView*)m_viewList.GetHead())->SerializeRaw(ar);
}

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerDoc diagnostics

#ifdef _DEBUG
void CAsmCompilerDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CAsmCompilerDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerDoc commands
