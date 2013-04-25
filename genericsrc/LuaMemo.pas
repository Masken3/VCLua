unit LuaMemo;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateMemo(L: Plua_State): Integer; cdecl;
type
    TLuaMemo = class(TMemo)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure MemoToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  SetStringListMethods(L,Index,Sender);
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateMemo(L: Plua_State): Integer; cdecl;
var
  lMemo:TLuaMemo;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lMemo := TLuaMemo.Create(Parent);
  lMemo.Parent := TWinControl(Parent);
  lMemo.LuaCtl := TLuaControl.Create(lMemo,L,@MemoToTable);
  lMemo.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lMemo),-1)
  else
     lMemo.Name := Name;
  MemoToTable(L, -1, lMemo);
  Result := 1;
end;
end.
