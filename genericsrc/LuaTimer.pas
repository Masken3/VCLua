unit LuaTimer;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateTimer(L: Plua_State): Integer; cdecl;
type
    TLuaTimer = class(TTimer)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure TimerToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateTimer(L: Plua_State): Integer; cdecl;
var
  lTimer:TLuaTimer;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lTimer := TLuaTimer.Create(Parent);
  
  lTimer.LuaCtl := TLuaControl.Create(lTimer,L,@TimerToTable);
  lTimer.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lTimer),-1)
  else
     lTimer.Name := Name;
  TimerToTable(L, -1, lTimer);
  Result := 1;
end;
end.
