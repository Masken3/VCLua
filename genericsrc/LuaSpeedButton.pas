unit LuaSpeedButton;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateSpeedButton(L: Plua_State): Integer; cdecl;
type
    TLuaSpeedButton = class(TSpeedButton)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure SpeedButtonToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  LuaSetTableFunction(L, Index, 'Image', ControlGlyph);
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateSpeedButton(L: Plua_State): Integer; cdecl;
var
  lSpeedButton:TLuaSpeedButton;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lSpeedButton := TLuaSpeedButton.Create(Parent);
  lSpeedButton.Parent := TWinControl(Parent);
  lSpeedButton.LuaCtl := TLuaControl.Create(lSpeedButton,L,@SpeedButtonToTable);
  lSpeedButton.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lSpeedButton),-1)
  else
     lSpeedButton.Name := Name;
  SpeedButtonToTable(L, -1, lSpeedButton);
  Result := 1;
end;
end.
