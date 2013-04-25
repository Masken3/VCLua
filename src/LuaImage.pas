unit LuaImage;

interface

Uses ExtCtrls, Controls, Classes,
     LuaPas,
     LuaControl,
     Graphics;

function CreateImage(L: Plua_State): Integer; cdecl;

type
	TLuaImage = class(TImage)
		  LuaCtl: TLuaControl;
        end;

implementation

Uses Forms, SysUtils, LuaProperties, Lua, Dialogs;

// ************ IMAGE ******************** //
function LoadImageFromFile(L: Plua_State): Integer; cdecl;
var success:Boolean;
    lImage:TLuaImage;
    fname, ftype : String;
begin
  success := false;
  CheckArg(L, 2);
  lImage := TLuaImage(GetLuaObject(L, 1));
  fname := lua_tostring(L,2);
  ftype := ExtractFileExt(fname);
  try
      lImage.Picture.LoadFromFile(fname);
      success := true;
  finally
  end;
  lua_pushboolean(L,success);
  result := 1;
end;

function LoadImageFromBuffer(L: Plua_State): Integer; cdecl;
var lImage:TLuaImage;
    fname,fext: String;
    ST: TMemoryStream;
    Buf: pointer;
    Size: Integer;
begin
  CheckArg(L, 4);
  lImage := TLuaImage(GetLuaObject(L, 1));
  Size := trunc(lua_tonumber(L,3));
  Buf := lua_tolstring(L,2,@Size);
  fname := lua_tostring(L,4);
  if (Buf=nil) then
    LuaError(L,'Image not found: '+lua_tostring(L,2));
  try
       ST := TMemoryStream.Create;
       ST.WriteBuffer(Buf^,trunc(lua_tonumber(L,3)));
       ST.Seek(0, soFromBeginning);
       fext := ExtractFileExt(fname);
       System.Delete(fext, 1, 1);
       lImage.Picture.LoadFromStreamWithFileExt(ST,fext);
  finally
       if (Assigned(ST)) then ST.Free;
  end;
  lua_pushnumber(L,size);
  result := 1;
end;

procedure ToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L, Index, Sender);
  SetAnchorMethods(L,Index,Sender);
  LuaSetTableFunction(L, index, 'LoadFromFile', LoadImageFromFile);
  LuaSetTableFunction(L, index, 'LoadFromBuffer', LoadImageFromBuffer);

  // lua_pushnumber(L,3);
  // lua_pushliteral(L,'n');
  // lua_rawset(L,-3);

  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;

function CreateImage(L: Plua_State): Integer; cdecl;
var
  lImage:TLuaImage;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lImage := TLuaImage.Create(Parent);
  lImage.Parent := TWinControl(Parent);
  lImage.LuaCtl := TLuaControl.Create(lImage,L,@ToTable);
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lImage),-1)
  else 
     lImage.Name := Name;
  ToTable(L, -1, lImage);

  Result := 1;
end;

end.
