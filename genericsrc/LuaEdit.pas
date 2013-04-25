unit LuaEdit;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateEdit(L: Plua_State): Integer; cdecl;
type
    TLuaEdit = class(TEdit)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure EditToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateEdit(L: Plua_State): Integer; cdecl;
var
  lEdit:TLuaEdit;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lEdit := TLuaEdit.Create(Parent);
  lEdit.Parent := TWinControl(Parent);
  lEdit.LuaCtl := TLuaControl.Create(lEdit,L,@EditToTable);
  lEdit.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lEdit),-1)
  else
     lEdit.Name := Name;
  EditToTable(L, -1, lEdit);
  Result := 1;
end;
end.
