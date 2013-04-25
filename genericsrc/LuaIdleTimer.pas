unit LuaIdleTimer;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateIdleTimer(L: Plua_State): Integer; cdecl;
type
    TLuaIdleTimer = class(TIdleTimer)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure IdleTimerToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateIdleTimer(L: Plua_State): Integer; cdecl;
var
  lIdleTimer:TLuaIdleTimer;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lIdleTimer := TLuaIdleTimer.Create(Parent);
  
  lIdleTimer.LuaCtl := TLuaControl.Create(lIdleTimer,L,@IdleTimerToTable);
  lIdleTimer.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lIdleTimer),-1)
  else
     lIdleTimer.Name := Name;
  IdleTimerToTable(L, -1, lIdleTimer);
  Result := 1;
end;
end.
