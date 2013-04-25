unit LuaToggleBox;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateToggleBox(L: Plua_State): Integer; cdecl;
type
    TLuaToggleBox = class(TToggleBox)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure ToggleBoxToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateToggleBox(L: Plua_State): Integer; cdecl;
var
  lToggleBox:TLuaToggleBox;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lToggleBox := TLuaToggleBox.Create(Parent);
  lToggleBox.Parent := TWinControl(Parent);
  lToggleBox.LuaCtl := TLuaControl.Create(lToggleBox,L,@ToggleBoxToTable);
  lToggleBox.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lToggleBox),-1)
  else
     lToggleBox.Name := Name;
  ToggleBoxToTable(L, -1, lToggleBox);
  Result := 1;
end;
end.
