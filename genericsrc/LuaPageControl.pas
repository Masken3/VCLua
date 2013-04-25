unit LuaPageControl;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreatePageControl(L: Plua_State): Integer; cdecl;
type
    TLuaPageControl = class(TPageControl)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure PageControlToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreatePageControl(L: Plua_State): Integer; cdecl;
var
  lPageControl:TLuaPageControl;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lPageControl := TLuaPageControl.Create(Parent);
  lPageControl.Parent := TWinControl(Parent);
  lPageControl.LuaCtl := TLuaControl.Create(lPageControl,L,@PageControlToTable);
  lPageControl.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lPageControl),-1)
  else
     lPageControl.Name := Name;
  PageControlToTable(L, -1, lPageControl);
  Result := 1;
end;
end.
