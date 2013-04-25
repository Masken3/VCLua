unit LuaSpinEdit;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateSpinEdit(L: Plua_State): Integer; cdecl;
type
    TLuaSpinEdit = class(TSpinEdit)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure SpinEditToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateSpinEdit(L: Plua_State): Integer; cdecl;
var
  lSpinEdit:TLuaSpinEdit;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lSpinEdit := TLuaSpinEdit.Create(Parent);
  lSpinEdit.Parent := TWinControl(Parent);
  lSpinEdit.LuaCtl := TLuaControl.Create(lSpinEdit,L,@SpinEditToTable);
  lSpinEdit.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lSpinEdit),-1)
  else
     lSpinEdit.Name := Name;
  SpinEditToTable(L, -1, lSpinEdit);
  Result := 1;
end;
end.
