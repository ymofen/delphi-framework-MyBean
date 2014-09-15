//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ufrmMain.h"
#include "mybean.core.beanFactoryForBCB.hpp"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}

int __stdcall TForm1::showAsModal()
{
 return this->ShowModal();
}

//HRESULT __stdcall TForm1::QueryInterface(const GUID &IID, /* out */ void *Obj)
//{
//  if (GetInterface(IID, Obj))
//  {
//	return 0;
//  } else
//  {
//  	return E_NOINTERFACE;
//  }
//}
//---------------------------------------------------------------------------
void __stdcall TForm1::showAsNormal()
{
 this->Show();
}
//---------------------------------------------------------------------------
