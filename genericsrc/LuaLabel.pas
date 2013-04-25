unit LuaLabel;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateLabel(L: Plua_State): Integer; cdecl;
type
    TLuaLabel = class(TLabel)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure LabelToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateLabel(L: Plua_State): Integer; cdecl;
var
  lLabel:TLuaLabel;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lLabel := TLuaLabel.Create(Parent);
  lLabel.Parent := TWinControl(Parent);
  lLabel.LuaCtl := TLuaControl.Create(lLabel,L,@LabelToTable);
  lLabel.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lLabel),-1)
  else
     lLabel.Name := Name;
  LabelToTable(L, -1, lLabel);
  Result := 1;
end;
end.
