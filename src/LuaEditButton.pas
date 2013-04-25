unit LuaEditButton;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateEditButton(L: Plua_State): Integer; cdecl;
type
    TLuaEditButton = class(TEditButton)
        LuaCtl: TLuaControl;
       published
        property Text: string read GetText write SetText;
    end;
implementation
Uses LuaProperties, Lua;
procedure ToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateEditButton(L: Plua_State): Integer; cdecl;
var
  lEditButton:TLuaEditButton;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lEditButton := TLuaEditButton.Create(Parent);
  lEditButton.Parent := TWinControl(Parent);
  lEditButton.LuaCtl := TLuaControl.Create(lEditButton,L,@ToTable);
  lEditButton.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lEditButton),-1)
  else 
     lEditButton.Name := Name;
  
  ToTable(L, -1, lEditButton);
  Result := 1;
end;
end.
