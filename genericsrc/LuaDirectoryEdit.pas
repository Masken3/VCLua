unit LuaDirectoryEdit;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateDirectoryEdit(L: Plua_State): Integer; cdecl;
type
    TLuaDirectoryEdit = class(TDirectoryEdit)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure DirectoryEditToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateDirectoryEdit(L: Plua_State): Integer; cdecl;
var
  lDirectoryEdit:TLuaDirectoryEdit;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lDirectoryEdit := TLuaDirectoryEdit.Create(Parent);
  lDirectoryEdit.Parent := TWinControl(Parent);
  lDirectoryEdit.LuaCtl := TLuaControl.Create(lDirectoryEdit,L,@DirectoryEditToTable);
  lDirectoryEdit.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lDirectoryEdit),-1)
  else
     lDirectoryEdit.Name := Name;
  DirectoryEditToTable(L, -1, lDirectoryEdit);
  Result := 1;
end;
end.
