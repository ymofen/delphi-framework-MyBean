unit BeanExpertReg;

interface

procedure Register;

implementation

uses WizHelpers, BeanHostAppWiz, BeanFormWiz, BeanDPKWiz, BeanLogicWiz,
  BeanDLLWiz, NewInterface;

procedure Register;
begin
  wzRegisterPackageWizard(THostApplicationWizard.Create);
  wzRegisterPackageWizard(TBeanFormWizard.Create);
  wzRegisterPackageWizard(TdpkBeanWizard.Create);
  wzRegisterPackageWizard(TLogicBeanWizard.Create);
  wzRegisterPackageWizard(TDllBeanWizard.Create);
  wzRegisterPackageWizard(TBeanInterfaceWizard.Create);
end;

end.
