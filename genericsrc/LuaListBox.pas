unit LuaListBox;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateListBox(L: Plua_State): Integer; cdecl;
type
    TLuaListBox = class(TListBox)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure ListBoxToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  SetStringListMethods(L,Index,Sender);
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateListBox(L: Plua_State): Integer; cdecl;
var
  lListBox:TLuaListBox;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lListBox := TLuaListBox.Create(Parent);
  lListBox.Parent := TWinControl(Parent);
  lListBox.LuaCtl := TLuaControl.Create(lListBox,L,@ListBoxToTable);
  lListBox.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lListBox),-1)
  else
     lListBox.Name := Name;
  ListBoxToTable(L, -1, lListBox);
  Result := 1;
end;
end.
