unit LuaRadioButton;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateRadioButton(L: Plua_State): Integer; cdecl;
type
    TLuaRadioButton = class(TRadioButton)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure RadioButtonToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateRadioButton(L: Plua_State): Integer; cdecl;
var
  lRadioButton:TLuaRadioButton;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lRadioButton := TLuaRadioButton.Create(Parent);
  lRadioButton.Parent := TWinControl(Parent);
  lRadioButton.LuaCtl := TLuaControl.Create(lRadioButton,L,@RadioButtonToTable);
  lRadioButton.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lRadioButton),-1)
  else
     lRadioButton.Name := Name;
  RadioButtonToTable(L, -1, lRadioButton);
  Result := 1;
end;
end.
