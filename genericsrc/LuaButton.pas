unit LuaButton;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateButton(L: Plua_State): Integer; cdecl;
type
    TLuaButton = class(TButton)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure ButtonToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateButton(L: Plua_State): Integer; cdecl;
var
  lButton:TLuaButton;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lButton := TLuaButton.Create(Parent);
  lButton.Parent := TWinControl(Parent);
  lButton.LuaCtl := TLuaControl.Create(lButton,L,@ButtonToTable);
  lButton.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lButton),-1)
  else
     lButton.Name := Name;
  ButtonToTable(L, -1, lButton);
  Result := 1;
end;
end.
