unit uAppPluginContext;

interface

uses
  uIAppliationContext;


function appPluginContext: IApplicationContext; stdcall; external
    'BeanManager.dll';

implementation


end.
