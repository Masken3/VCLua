unit LuaFileNameEdit;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateFileNameEdit(L: Plua_State): Integer; cdecl;
type
    TLuaFileNameEdit = class(TFileNameEdit)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure FileNameEditToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateFileNameEdit(L: Plua_State): Integer; cdecl;
var
  lFileNameEdit:TLuaFileNameEdit;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lFileNameEdit := TLuaFileNameEdit.Create(Parent);
  lFileNameEdit.Parent := TWinControl(Parent);
  lFileNameEdit.LuaCtl := TLuaControl.Create(lFileNameEdit,L,@FileNameEditToTable);
  lFileNameEdit.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lFileNameEdit),-1)
  else
     lFileNameEdit.Name := Name;
  FileNameEditToTable(L, -1, lFileNameEdit);
  Result := 1;
end;
end.
