unit LuaFloatSpinEdit;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateFloatSpinEdit(L: Plua_State): Integer; cdecl;
type
    TLuaFloatSpinEdit = class(TFloatSpinEdit)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure FloatSpinEditToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateFloatSpinEdit(L: Plua_State): Integer; cdecl;
var
  lFloatSpinEdit:TLuaFloatSpinEdit;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lFloatSpinEdit := TLuaFloatSpinEdit.Create(Parent);
  lFloatSpinEdit.Parent := TWinControl(Parent);
  lFloatSpinEdit.LuaCtl := TLuaControl.Create(lFloatSpinEdit,L,@FloatSpinEditToTable);
  lFloatSpinEdit.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lFloatSpinEdit),-1)
  else
     lFloatSpinEdit.Name := Name;
  FloatSpinEditToTable(L, -1, lFloatSpinEdit);
  Result := 1;
end;
end.
