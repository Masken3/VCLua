unit LuaTabSheet;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateTabSheet(L: Plua_State): Integer; cdecl;
type
    TLuaTabSheet = class(TTabSheet)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure TabSheetToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateTabSheet(L: Plua_State): Integer; cdecl;
var
  lTabSheet:TLuaTabSheet;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lTabSheet := TLuaTabSheet.Create(Parent);
  lTabSheet.Parent := TWinControl(Parent);
  lTabSheet.LuaCtl := TLuaControl.Create(lTabSheet,L,@TabSheetToTable);
  lTabSheet.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lTabSheet),-1)
  else
     lTabSheet.Name := Name;
  TabSheetToTable(L, -1, lTabSheet);
  Result := 1;
end;
end.
