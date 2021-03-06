unit LuaSplitter;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateSplitter(L: Plua_State): Integer; cdecl;
type
    TLuaSplitter = class(TSplitter)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure SplitterToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateSplitter(L: Plua_State): Integer; cdecl;
var
  lSplitter:TLuaSplitter;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lSplitter := TLuaSplitter.Create(Parent);
  lSplitter.Parent := TWinControl(Parent);
  lSplitter.LuaCtl := TLuaControl.Create(lSplitter,L,@SplitterToTable);
  lSplitter.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lSplitter),-1)
  else
     lSplitter.Name := Name;
  SplitterToTable(L, -1, lSplitter);
  Result := 1;
end;
end.
