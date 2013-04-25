unit LuaCalcEdit;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateCalcEdit(L: Plua_State): Integer; cdecl;
type
    TLuaCalcEdit = class(TCalcEdit)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure CalcEditToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateCalcEdit(L: Plua_State): Integer; cdecl;
var
  lCalcEdit:TLuaCalcEdit;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lCalcEdit := TLuaCalcEdit.Create(Parent);
  lCalcEdit.Parent := TWinControl(Parent);
  lCalcEdit.LuaCtl := TLuaControl.Create(lCalcEdit,L,@CalcEditToTable);
  lCalcEdit.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lCalcEdit),-1)
  else
     lCalcEdit.Name := Name;
  CalcEditToTable(L, -1, lCalcEdit);
  Result := 1;
end;
end.
