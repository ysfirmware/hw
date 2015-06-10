// AsmCompiler.h : main header file for the ASMCOMPILER application
//

#if !defined(AFX_ASMCOMPILER_H__E4FB2EFB_B5EB_4A38_B441_633C4445EC44__INCLUDED_)
#define AFX_ASMCOMPILER_H__E4FB2EFB_B5EB_4A38_B441_633C4445EC44__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CAsmCompilerApp:
// See AsmCompiler.cpp for the implementation of this class
//

class CAsmCompilerApp : public CWinApp
{
public:
	CAsmCompilerApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAsmCompilerApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation
	//{{AFX_MSG(CAsmCompilerApp)
	afx_msg void OnAppAbout();
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_ASMCOMPILER_H__E4FB2EFB_B5EB_4A38_B441_633C4445EC44__INCLUDED_)
