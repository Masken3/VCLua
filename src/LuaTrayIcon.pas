unit LuaTrayIcon;

interface

Uses Classes, Controls, Contnrs, LuaPas, LuaControl, Forms, ExtCtrls, TypInfo;

function CreateTrayIcon(L: Plua_State): Integer; cdecl;

type
    TLuaTrayIcon = class(TTrayIcon)
          LuaCtl: TLuaControl;
     end;

// ***********************************************

implementation

Uses LuaProperties, Lua, Dialogs, SysUtils, LuaForm;


function TrayIconShow(L: Plua_State): Integer; cdecl;
var
  lTrayIcon: TTrayIcon;
begin
  CheckArg(L, 1);
  lTrayIcon := TLuaTrayIcon(GetLuaObject(L, 1));
  lTrayIcon.Show;
  Result := 0;
end;

function TrayIconHide(L: Plua_State): Integer; cdecl;
var
  lTrayIcon: TTrayIcon;
begin
  CheckArg(L, 1);
  lTrayIcon := TLuaTrayIcon(GetLuaObject(L, 1));
  lTrayIcon.Hide;
  Result := 0;
end;

function TrayIconShowBalloonHint(L: Plua_State): Integer; cdecl;
var
  lTrayIcon: TTrayIcon;
begin
  CheckArg(L, 1);
  lTrayIcon := TLuaTrayIcon(GetLuaObject(L, 1));
  lTrayIcon.ShowBalloonHint;
  Result := 0;
end;

function TrayIconLoad(L:Plua_State): Integer; cdecl;
var
  Frm: TTrayIcon;
  Str: String;
  Buf: Pointer;
  Size: Integer;
  Bm: TImage;
  ST: TMemoryStream;
begin
 Result := 0;
 Frm := TTrayIcon(GetLuaObject(L, 1));
 Str := lua_tostring(L,2);
 if (fileExists(Str)) then begin
      Frm.Icon.LoadFromFile(Str);
 end;
end;

procedure ToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L, Index, Sender);

  LuaSetTableFunction(L, Index, 'Show', TrayIconShow);
  LuaSetTableFunction(L, Index, 'Hide', TrayIconHide);
  LuaSetTableFunction(L, Index, 'ShowBalloonHint', TrayIconShowBalloonHint);
  LuaSetTableFunction(L, Index, 'Icon', TrayIconLoad);

  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;

function CreateTrayIcon(L: Plua_State): Integer; cdecl;
var
  lTrayIcon:TLuaTrayIcon;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lTrayIcon := TLuaTrayIcon.Create(Parent);
  lTrayIcon.LuaCtl := TLuaControl.Create(lTrayIcon,L,@Totable);
  lTrayIcon.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lTrayIcon),-1)
  else 
     lTrayIcon.Name := Name;	 
  ToTable(L, -1, lTrayIcon);
  Result := 1;
end;

end.
