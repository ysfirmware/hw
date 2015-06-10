// AsmCompilerDoc.h : interface of the CAsmCompilerDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASMCOMPILERDOC_H__A4419AEC_22FA_4F7F_9632_D0701C5F3088__INCLUDED_)
#define AFX_ASMCOMPILERDOC_H__A4419AEC_22FA_4F7F_9632_D0701C5F3088__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class CAsmCompilerDoc : public CDocument
{
protected: // create from serialization only
	CAsmCompilerDoc();
	DECLARE_DYNCREATE(CAsmCompilerDoc)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAsmCompilerDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CAsmCompilerDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CAsmCompilerDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_ASMCOMPILERDOC_H__A4419AEC_22FA_4F7F_9632_D0701C5F3088__INCLUDED_)
