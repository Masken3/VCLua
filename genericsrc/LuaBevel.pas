unit LuaBevel;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateBevel(L: Plua_State): Integer; cdecl;
type
    TLuaBevel = class(TBevel)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure BevelToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateBevel(L: Plua_State): Integer; cdecl;
var
  lBevel:TLuaBevel;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lBevel := TLuaBevel.Create(Parent);
  lBevel.Parent := TWinControl(Parent);
  lBevel.LuaCtl := TLuaControl.Create(lBevel,L,@BevelToTable);
  lBevel.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lBevel),-1)
  else
     lBevel.Name := Name;
  BevelToTable(L, -1, lBevel);
  Result := 1;
end;
end.
