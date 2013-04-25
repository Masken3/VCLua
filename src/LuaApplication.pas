unit LuaApplication;

interface

Uses Classes, Controls, LuaPas, Forms, TypInfo, SysUtils;

function CreateApplication(L: Plua_State): Integer; cdecl;

// other stuff
function GetScreenSize(L: Plua_State): Integer; cdecl;
function LuaFileExists(L: Plua_State): Integer; cdecl;
function LuaDirectoryExists(L: Plua_State): Integer; cdecl;

implementation

Uses LuaProperties, Lua, LuaForm;

// ***********************************************

function GetScreenSize(L: Plua_State): Integer; cdecl;
begin
  lua_pushnumber(L, Screen.Width);
  lua_pushnumber(L, Screen.Height);
  Result := 2;
end;

function LuaFileExists(L: Plua_State): Integer; cdecl;
begin
  CheckArg(L, 1);
  lua_pushboolean(L,FileExists(lua_tostring(L,1)));
  Result := 1;
end;

function LuaDirectoryExists(L: Plua_State): Integer; cdecl;
begin
  CheckArg(L, 1);
  lua_pushboolean(L,DirectoryExists(lua_tostring(L,1)));
  Result := 1;
end;

// ***********************************************
function ApplicationInitialize(L: Plua_State): Integer; cdecl;
var
  App: TApplication;
begin
  CheckArg(L, 1);
  App := TApplication(GetLuaObject(L, 1));
  App.initialize;
  Result := 0;
end;

function ApplicationRun(L: Plua_State): Integer; cdecl;
var
  App: TApplication;
begin
  CheckArg(L, 1);
  App := TApplication(GetLuaObject(L, 1));
  App.run;
  Result := 0;
end;

function ApplicationTerminate(L: Plua_State): Integer; cdecl;
var
  App: TApplication;
begin
  CheckArg(L, 1);
  App := TApplication(GetLuaObject(L, 1));
  App.terminate;
  Result := 0;
end;

function ApplicationProcessmessages(L: Plua_State): Integer; cdecl;
var
  App: TApplication;
begin
  CheckArg(L, 1);
  App := TApplication(GetLuaObject(L, 1));
  App.processmessages;
  Result := 0;
end;

function ApplicationExeName(L: Plua_State): Integer; cdecl;
var
  App: TApplication;
begin
  CheckArg(L, 1);
  App := TApplication(GetLuaObject(L, 1));
  lua_pushString(L,pchar(App.Exename));
  Result := 1;
end;

function ApplicationExePath(L: Plua_State): Integer; cdecl;
var
  App: TApplication;
begin
  CheckArg(L, 1);
  App := TApplication(GetLuaObject(L, 1));
  lua_pushString(L,pchar(ExtractFilePath(App.Exename)));
  Result := 1;
end;

function ApplicationFindForm(L:Plua_State): Integer; cdecl;
Var Temp: TComponent;
	i: Integer;
begin
 Result := 1;
 CheckArg(L, 2);
 for i:=0 to Application.ComponentCount-1 do begin
	Temp := Application.Components[I];
	if ((Temp is TLuaForm) or (Temp is TForm)) and (Temp.Name=lua_tostring(L,2))then begin
		TLuaForm(Temp).LuaCtl.ToTable(L, -1, Temp);
		Exit;
	end;
 end;
 lua_pushnil(L);
end;


function ApplicationGetMainForm(L:Plua_State): Integer; cdecl;
begin
 Result := 1;
 CheckArg(L, 1);
 if Application.MainForm = nil then
      lua_pushnil(L)
 else begin
   TLuaForm(Application.MainForm).LuaCtl.ToTable(L, -1, Application.MainForm);
 end;
end;


procedure ApplicationTable(L:Plua_State; Index:Integer);
begin
  lua_newtable(L);
  LuaSetTableLightUserData(L, Index, HandleStr, Pointer(Application));

  LuaSetTableFunction(L, Index, 'Initialize', ApplicationInitialize);
  LuaSetTableFunction(L, Index, 'Run', ApplicationRun);
  LuaSetTableFunction(L, Index, 'Terminate', ApplicationTerminate);
  LuaSetTableFunction(L, Index, 'ProcessMessages', ApplicationProcessmessages);
  LuaSetTableFunction(L, Index, 'FindForm', ApplicationFindForm);
  LuaSetTableFunction(L, Index, 'GetMainForm', ApplicationGetMainForm);  
  LuaSetTableFunction(L, Index, 'ExeName', ApplicationExeName);
  LuaSetTableFunction(L, Index, 'ExePath', ApplicationExePath);

  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);

end;


function CreateApplication(L: Plua_State): Integer; cdecl;
begin
  ApplicationTable(L, -1);
  Result := 1;
end;

end.
