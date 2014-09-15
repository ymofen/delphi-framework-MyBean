//---------------------------------------------------------------------------

#ifndef ufrmMainH
#define ufrmMainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "uIFormShow.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm, IShowAsNormal, IShowAsModal
{
__published:	// IDE-managed Components
	TEdit *Edit1;
	TMemo *Memo1;
private:	// User declarations
public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
	int __stdcall showAsModal(void);
	void __stdcall showAsNormal(void);
    //INTFOBJECT_IMPL_IUNKNOWN(TForm);
	ULONG __stdcall AddRef()
	{
			return TForm::_AddRef();
	}

	ULONG __stdcall Release()
	{
			return TForm::_Release();
	}
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
