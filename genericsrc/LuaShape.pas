unit LuaShape;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateShape(L: Plua_State): Integer; cdecl;
type
    TLuaShape = class(TShape)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure ShapeToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateShape(L: Plua_State): Integer; cdecl;
var
  lShape:TLuaShape;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lShape := TLuaShape.Create(Parent);
  lShape.Parent := TWinControl(Parent);
  lShape.LuaCtl := TLuaControl.Create(lShape,L,@ShapeToTable);
  lShape.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lShape),-1)
  else
     lShape.Name := Name;
  ShapeToTable(L, -1, lShape);
  Result := 1;
end;
end.
