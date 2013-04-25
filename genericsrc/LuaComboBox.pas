unit LuaComboBox;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateComboBox(L: Plua_State): Integer; cdecl;
type
    TLuaComboBox = class(TComboBox)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure ComboBoxToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  SetStringListMethods(L,Index,Sender);
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateComboBox(L: Plua_State): Integer; cdecl;
var
  lComboBox:TLuaComboBox;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lComboBox := TLuaComboBox.Create(Parent);
  lComboBox.Parent := TWinControl(Parent);
  lComboBox.LuaCtl := TLuaControl.Create(lComboBox,L,@ComboBoxToTable);
  lComboBox.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lComboBox),-1)
  else
     lComboBox.Name := Name;
  ComboBoxToTable(L, -1, lComboBox);
  Result := 1;
end;
end.
