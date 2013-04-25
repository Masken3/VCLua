unit LuaFont;

interface

Uses Graphics,LuaPas,Lua,LuaProperties;

type
      TLuaFont = class(TFont)
          public
            L:Plua_State;
            procedure ToTable(LL:Plua_State; Index:Integer; Sender:TObject);
      end;

implementation

Uses Forms, TypInfo;

procedure TLuaFont.ToTable(LL:Plua_State; Index:Integer; Sender:TObject);
begin
  L := LL;
  lua_newtable(L);
  LuaSetTableLightUserData(L, Index, HandleStr, Pointer(GetInt64Prop(Sender,'Font')));
  LuaSetMetaFunction(L, index, '__index', @LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', @LuaSetProperty);
end;

end.
