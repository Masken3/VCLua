unit LuaPanel;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreatePanel(L: Plua_State): Integer; cdecl;
type
    TLuaPanel = class(TPanel)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure PanelToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreatePanel(L: Plua_State): Integer; cdecl;
var
  lPanel:TLuaPanel;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lPanel := TLuaPanel.Create(Parent);
  lPanel.Parent := TWinControl(Parent);
  lPanel.LuaCtl := TLuaControl.Create(lPanel,L,@PanelToTable);
  lPanel.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lPanel),-1)
  else
     lPanel.Name := Name;
  PanelToTable(L, -1, lPanel);
  Result := 1;
end;
end.
