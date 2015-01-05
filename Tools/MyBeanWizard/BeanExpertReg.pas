unit BeanExpertReg;

interface

procedure Register;

implementation

uses WizHelpers, BeanHostAppWiz, BeanFormWiz, BeanDPKWiz, BeanLogicWiz,
  BeanDLLWiz, NewInterface, mergePkg, BeanDataModuleWiz;

procedure Register;
begin
  wzRegisterPackageWizard(THostApplicationWizard.Create);
  wzRegisterPackageWizard(TBeanFormWizard.Create);
  wzRegisterPackageWizard(TdpkBeanWizard.Create);
  wzRegisterPackageWizard(TLogicBeanWizard.Create);
  wzRegisterPackageWizard(TDllBeanWizard.Create);
  wzRegisterPackageWizard(TBeanInterfaceWizard.Create);
  wzRegisterPackageWizard(TdpkMerageWizard.Create);
  wzRegisterPackageWizard(TBeanDataModuleWizard.Create);

end;

end.
