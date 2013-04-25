unit LuaBitBtn;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function CreateBitBtn(L: Plua_State): Integer; cdecl;
type
    TLuaBitBtn = class(TBitBtn)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure BitBtnToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  SetAnchorMethods(L,Index,Sender);
  
  LuaSetTableFunction(L, Index, 'Image', ControlGlyph);
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function CreateBitBtn(L: Plua_State): Integer; cdecl;
var
  lBitBtn:TLuaBitBtn;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lBitBtn := TLuaBitBtn.Create(Parent);
  lBitBtn.Parent := TWinControl(Parent);
  lBitBtn.LuaCtl := TLuaControl.Create(lBitBtn,L,@BitBtnToTable);
  lBitBtn.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lBitBtn),-1)
  else
     lBitBtn.Name := Name;
  BitBtnToTable(L, -1, lBitBtn);
  Result := 1;
end;
end.
