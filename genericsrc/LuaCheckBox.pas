unit LuaCheckBox;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateCheckBox(L: Plua_State): Integer; cdecl;
type
    TLuaCheckBox = class(TCheckBox)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure CheckBoxToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateCheckBox(L: Plua_State): Integer; cdecl;
var
  lCheckBox:TLuaCheckBox;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lCheckBox := TLuaCheckBox.Create(Parent);
  lCheckBox.Parent := TWinControl(Parent);
  lCheckBox.LuaCtl := TLuaControl.Create(lCheckBox,L,@CheckBoxToTable);
  lCheckBox.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lCheckBox),-1)
  else
     lCheckBox.Name := Name;
  CheckBoxToTable(L, -1, lCheckBox);
  Result := 1;
end;
end.
