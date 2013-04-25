unit LuaTrackBar;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateTrackBar(L: Plua_State): Integer; cdecl;
type
    TLuaTrackBar = class(TTrackBar)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure TrackBarToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateTrackBar(L: Plua_State): Integer; cdecl;
var
  lTrackBar:TLuaTrackBar;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lTrackBar := TLuaTrackBar.Create(Parent);
  lTrackBar.Parent := TWinControl(Parent);
  lTrackBar.LuaCtl := TLuaControl.Create(lTrackBar,L,@TrackBarToTable);
  lTrackBar.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lTrackBar),-1)
  else
     lTrackBar.Name := Name;
  TrackBarToTable(L, -1, lTrackBar);
  Result := 1;
end;
end.
