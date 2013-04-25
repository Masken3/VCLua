unit LuaStrings;

interface

Uses Classes, Types, Controls, Contnrs, LuaPas, Forms, StdCtrls, FileCtrl, TypInfo;

function StringsGet(L: Plua_State): Integer; cdecl;
function StringsSet(L: Plua_State): Integer; cdecl;
function StringsAdd(L: Plua_State): Integer; cdecl;
function StringsInsert(L: Plua_State): Integer; cdecl;
function StringsDelete(L: Plua_State): Integer; cdecl;
function StringsClear(L: Plua_State): Integer; cdecl;
function StringsCount(L: Plua_State): Integer; cdecl;

// Listbox related
function ListIndex(L: Plua_State): Integer; cdecl;
function ListGet(L: Plua_State): Integer; cdecl;
function ListItemAtPos(L: Plua_State): Integer; cdecl;

// CheckListbox only
function ListGetChecked(L: Plua_State): Integer; cdecl;
function CheckListToggle(L: Plua_State): Integer; cdecl;
function CheckListItemEnabled(L: Plua_State): Integer; cdecl;

implementation

Uses SysUtils, LuaProperties, Lua, SynEdit, CheckLst, Dialogs;

function getObjectStrings(O:TObject):TStrings;
var cName:String;
begin
    Result := nil;
    if Assigned(O) then begin
      cName := O.ClassName;
      if cName='TLuaMemo' then
       Result := TMemo(O).Lines
      else
      if cName='TLuaSynEdit' then
       Result := TSynEdit(O).Lines
      else
      if cName='TLuaComboBox' then
       Result := TComboBox(O).Items
      else
      if cName='TLuaListBox' then
       Result := TListBox(O).Items
      else
      if cName='TLuaCheckListBox' then
       Result := TCheckListBox(O).Items
      else
      if cName='TLuaFileListBox' then
       Result := TFileListBox(O).Items
    end
end;

function StringsGet(L: Plua_State): Integer; cdecl;
var
  lStrings: TStrings;
  i :Integer;
begin
  CheckArg(L, 1);
  lStrings := getObjectStrings(GetLuaObject(L, 1));
  if Assigned(lStrings) then begin
    lua_newtable(L);
    for i:= 0 to lStrings.Count-1 do begin
      lua_pushnumber(L,i+1);
      lua_pushstring(L,pchar(lStrings[i]));
      lua_rawset(L,-3);
    end;
  end else
    lua_pushnil(L);
  (*
  lua_pushnumber(L,lStrings.Items.Count);
  lua_pushliteral(L,'n');
  lua_rawset(L,-3);
  *)
  Result := 1;
end;

function StringsSet(L: Plua_State): Integer; cdecl;
var
  lStrings: TStrings;
  n: Integer;
begin
  CheckArg(L, 2);
  n := lua_gettop(L);
  lStrings := getObjectStrings(GetLuaObject(L, 1));
  lStrings.Clear;
  if lua_isstring(L,2) then begin
     lStrings.Text := lua_tostring(L,-1);
  end else
  if lua_istable(L,2) then begin
    lua_pushnil(L);
    while (lua_next(L, n) <> 0) do
    begin
      lStrings.Add(lua_tostring(L,-1));
      lua_pop(L, 1);
    end;
  end;
  Result := 0;
end;

function StringsAdd(L: Plua_State): Integer; cdecl;
var
  lStrings: TStrings;
begin
  CheckArg(L, 2);
  lStrings := getObjectStrings(GetLuaObject(L, 1));
  lStrings.Add(lua_tostring(L,2));
  Result := 0;
end;

function StringsInsert(L: Plua_State): Integer; cdecl;
var
  lStrings: TStrings;
begin
  CheckArg(L, 3);
  lStrings := getObjectStrings(GetLuaObject(L, 1));
  lStrings.Insert(Trunc(lua_tonumber(L,2)),lua_tostring(L,3));
  Result := 0;
end;

function StringsDelete(L: Plua_State): Integer; cdecl;
var
  lStrings: TStrings;
begin
  CheckArg(L, 2);
  lStrings := getObjectStrings(GetLuaObject(L, 1));
  lStrings.Delete(Trunc(lua_tonumber(L,2)));
  Result := 0;
end;

function StringsClear(L: Plua_State): Integer; cdecl;
var
  lStrings: TStrings;
begin
  CheckArg(L, 1);
  lStrings := getObjectStrings(GetLuaObject(L, 1));
  lStrings.Clear;
  Result := 0;
end;

function StringsCount(L: Plua_State): Integer; cdecl;
var
  lStrings: TStrings;
begin
  CheckArg(L, 1);
  lStrings := getObjectStrings(GetLuaObject(L, 1));
  lua_pushnumber(L, Trunc(lStrings.Count));
  Result := 1;
end;


// ListBox selected itemindex

function ListIndex(L: Plua_State): Integer; cdecl;
var ListBox:TListBox; i:Integer;
begin
  CheckArg(L, 1);
  if pos('ListBox', TObject(GetLuaObject(L, 1)).ClassName)>0 then begin
    ListBox := TListBox(GetLuaObject(L, 1));
    for i:=0 to ListBox.Count-1 do begin
      if ListBox.Selected[i] then begin
         lua_pushnumber(L,i);
         Result := 1;
         exit;
      end;
    end;
  end;
  lua_pushnil(L);
  Result := 1;
end;

function ListGet(L: Plua_State): Integer; cdecl;
var ListBox:TListBox; i,n:Integer;
begin
  CheckArg(L, 1);
  if pos('ListBox', TObject(GetLuaObject(L, 1)).ClassName)>0 then begin
    ListBox := TListBox(GetLuaObject(L, 1));
    lua_newtable(L);
    n := 1;
    for i:=0 to ListBox.Count-1 do begin
      if ListBox.Selected[i] then begin
         lua_pushnumber(L,n);
         lua_pushstring(L,pchar( ListBox.Items[i]));
         lua_rawset(L,-3);
         inc(n);
      end;
    end;
  end else
    lua_pushnil(L);
  Result := 1;
end;

function ListGetChecked(L: Plua_State): Integer; cdecl;
var ListBox:TCheckListBox; i,n:Integer;
begin
  CheckArg(L, 1);
  if pos('CheckListBox', TObject(GetLuaObject(L, 1)).ClassName)>0 then begin
    ListBox := TCheckListBox(GetLuaObject(L, 1));
    lua_newtable(L);
    n := 1;
    for i:= 0 to ListBox.Count-1 do begin
      if ListBox.Checked[i] then begin
         lua_pushnumber(L,n);
         lua_pushstring(L,pchar( ListBox.Items[i]));
         lua_rawset(L,-3);
         inc(n);
      end;
    end;
  end else
     lua_pushnil(L);
  Result := 1;
end;

function CheckListToggle(L: Plua_State): Integer; cdecl;
var ListBox:TCheckListBox; i:Integer;
begin
  CheckArg(L, 2);
  if pos('CheckListBox', TObject(GetLuaObject(L, 1)).ClassName)>0 then begin
    ListBox := TCheckListBox(GetLuaObject(L, 1));
    ListBox.Toggle(Trunc(lua_tonumber(L,2)));
  end;
  Result := 0;
end;

function CheckListItemEnabled(L: Plua_State): Integer; cdecl;
var ListBox:TCheckListBox; i:Integer;
begin
  // CheckArg(L, 3);
  Result := 0;
  if pos('CheckListBox', TObject(GetLuaObject(L, 1)).ClassName)>0 then begin
    ListBox := TCheckListBox(GetLuaObject(L, 1));
    if lua_gettop(L) = 3 then
       ListBox.ItemEnabled[Trunc(lua_tonumber(L,2))] := lua_toboolean(L,3)
    else begin
       Result := 1;
       lua_pushboolean(L,ListBox.ItemEnabled[Trunc(lua_tonumber(L,2))]);
    end;
  end;
end;

function ListItemAtPos(L: Plua_State): Integer; cdecl;
var ListBox:TListBox; i:Integer;
    p:TPoint;
begin
  CheckArg(L, 4);
  if pos('ListBox', TObject(GetLuaObject(L, 1)).ClassName)>0 then begin
     ListBox := TListBox(GetLuaObject(L, 1));
     p.x := trunc(lua_tonumber(L,2));
     p.y := trunc(lua_tonumber(L,3));
     lua_pushnumber(L,ListBox.ItemAtPos(p, lua_toboolean(L,4)));
  end else
     lua_pushnil(L);
  Result := 1;
end;

end.
