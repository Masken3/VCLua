unit LuaRadioGroup;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateRadioGroup(L: Plua_State): Integer; cdecl;
type
    TLuaRadioGroup = class(TRadioGroup)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure RadioGroupToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateRadioGroup(L: Plua_State): Integer; cdecl;
var
  lRadioGroup:TLuaRadioGroup;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lRadioGroup := TLuaRadioGroup.Create(Parent);
  lRadioGroup.Parent := TWinControl(Parent);
  lRadioGroup.LuaCtl := TLuaControl.Create(lRadioGroup,L,@RadioGroupToTable);
  lRadioGroup.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lRadioGroup),-1)
  else
     lRadioGroup.Name := Name;
  RadioGroupToTable(L, -1, lRadioGroup);
  Result := 1;
end;
end.
