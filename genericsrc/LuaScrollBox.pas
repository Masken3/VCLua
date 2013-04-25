unit LuaScrollBox;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateScrollBox(L: Plua_State): Integer; cdecl;
type
    TLuaScrollBox = class(TScrollBox)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure ScrollBoxToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateScrollBox(L: Plua_State): Integer; cdecl;
var
  lScrollBox:TLuaScrollBox;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lScrollBox := TLuaScrollBox.Create(Parent);
  lScrollBox.Parent := TWinControl(Parent);
  lScrollBox.LuaCtl := TLuaControl.Create(lScrollBox,L,@ScrollBoxToTable);
  lScrollBox.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lScrollBox),-1)
  else
     lScrollBox.Name := Name;
  ScrollBoxToTable(L, -1, lScrollBox);
  Result := 1;
end;
end.
