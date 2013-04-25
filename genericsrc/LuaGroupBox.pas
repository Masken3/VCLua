unit LuaGroupBox;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateGroupBox(L: Plua_State): Integer; cdecl;
type
    TLuaGroupBox = class(TGroupBox)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure GroupBoxToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateGroupBox(L: Plua_State): Integer; cdecl;
var
  lGroupBox:TLuaGroupBox;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lGroupBox := TLuaGroupBox.Create(Parent);
  lGroupBox.Parent := TWinControl(Parent);
  lGroupBox.LuaCtl := TLuaControl.Create(lGroupBox,L,@GroupBoxToTable);
  lGroupBox.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lGroupBox),-1)
  else
     lGroupBox.Name := Name;
  GroupBoxToTable(L, -1, lGroupBox);
  Result := 1;
end;
end.
