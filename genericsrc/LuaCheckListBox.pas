unit LuaCheckListBox;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateCheckListBox(L: Plua_State): Integer; cdecl;
type
    TLuaCheckListBox = class(TCheckListBox)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure CheckListBoxToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  SetStringListMethods(L,Index,Sender);
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateCheckListBox(L: Plua_State): Integer; cdecl;
var
  lCheckListBox:TLuaCheckListBox;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lCheckListBox := TLuaCheckListBox.Create(Parent);
  lCheckListBox.Parent := TWinControl(Parent);
  lCheckListBox.LuaCtl := TLuaControl.Create(lCheckListBox,L,@CheckListBoxToTable);
  lCheckListBox.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lCheckListBox),-1)
  else
     lCheckListBox.Name := Name;
  CheckListBoxToTable(L, -1, lCheckListBox);
  Result := 1;
end;
end.
