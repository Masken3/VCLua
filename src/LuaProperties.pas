unit LuaProperties;

interface

Uses  Dialogs, Forms, Graphics, Classes, Controls, StdCtrls, TypInfo, LuaPas, Lua;

function LuaListProperties(L: Plua_State): Integer; cdecl;
function LuaGetProperty(L: Plua_State): Integer; cdecl;
function LuaSetProperty(L: Plua_State): Integer; cdecl;
function GetLuaObject(L: Plua_State; Index: Integer): TObject;
function SetPropertiesFromLuaTable(L: Plua_State; Obj:TObject; Index:Integer):Boolean;
procedure SetProperty(L:Plua_State; Index:Integer; Comp:TComponent; PInfo:PPropInfo);

// forward
procedure lua_pushtable_object(L: Plua_State; Comp:TObject; index: Integer);

implementation

Uses SysUtils, ExtCtrls, LuaFont, Grids, LuaActionList, LuaImageList, LuaControl;

// ****************************************************************
procedure ListProperty(L: Plua_State; PName:String; PInfo: PPropInfo);
var
     PropType: String;
begin
        PropType := PInfo^.Proptype^.Name;
        if PropType[1] = 'T' then
           delete(Proptype,1,1);
        lua_pushstring(L, PChar(PName));
        lua_pushstring(L, PChar(PropType));
        // writeln('  ',PName, PropType);
        lua_rawset(L,-3);
end;

procedure ListObjectProperties(L: Plua_State; PObj:TObject);
var subObj:TObject;
    Count,Loop:Integer;
    PInfo: PPropInfo;
    PropInfos: PPropList;
    s:String;
begin
     Count := GetPropList(PObj.ClassInfo, tkAny, nil);
     GetMem(PropInfos, Count * SizeOf(PPropInfo));
     GetPropList(PObj.ClassInfo, tkAny, PropInfos, true);
     for Loop := 0 to Count - 1 do begin
         PInfo := GetPropInfo(PObj.ClassInfo, PropInfos^[Loop]^.Name);
         case PInfo^.Proptype^.Kind of
              tkClass:
                  begin
                       if PInfo^.Proptype^.Name<>'TAnchorSide' then begin
                          subObj := GetObjectProp(PObj, PInfo);
                          if subObj<>nil then begin
                             s := PropInfos^[Loop]^.Name;
                             // writeln(s);
                             lua_pushstring(L, pchar(s));
                             lua_newtable(L);
                             ListObjectProperties(L,subObj);
                             lua_rawset(L,-3);
                          end;
                       end;
                  end
              (*
              tkMethod:
                  begin
                       // writeln('*METHOD -> ', PropInfos^[Loop]^.Name);
                  end
              *)
              else
                  ListProperty(L, PropInfos^[Loop]^.Name, PInfo);
         end;
     end;
     FreeMem(PropInfos);
end;

function LuaListProperties(L: Plua_State): Integer; cdecl;
var
  PObj: TObject;
begin
  CheckArg(L, 1);
  PObj := GetLuaObject(L, 1);
  lua_newtable(L);
  ListObjectProperties(L, PObj);
  Result := 1;
end;

// ****************************************************************
procedure SetProperty(L:Plua_State; Index:Integer; Comp:TComponent; PInfo:PPropInfo);
Var propVal:String;
    PPInfo: PPropInfo;
    Str: String;
    tm: TMethod;
    cc: TComponent;
begin
     Str := PInfo^.Proptype^.Name;
     if ((Str = 'TBitmap') or (Str = 'TPicture')) and
        (ComponentBitmapString(TComponent(Comp),lua_tostring(L, -1)))
     then
     else
     if (Str = 'TIcon') and
        (ComponentGlyphFile(TComponent(Comp),lua_tostring(L, -1)))
     then
     else
     if (Str = 'TStrings') and
        (ComponentStringList(TComponent(Comp), lua_tostring(L, -2), lua_tostring(L, -1)))
     then
     else
     case PInfo^.Proptype^.Kind of
      tkMethod: begin
          // Property Name
          Str := lua_tostring(L,index-1);
          // omg watchout!
          cc := Comp.Components[0];
          PPInfo := GetPropInfo(cc, Str+'_Function');
	  if PPInfo <> nil then begin
              // OnXxxx_Function
              Str := lua_tostring(L,index);
              SetStrProp(cc, PPInfo, Str);
              if (Str='') then begin
                 tm.Data:= nil;
                 tm.Code:= nil;
                 SetMethodProp(Comp, PInfo, tm);
              end else begin
                // OnXxxx
                Str := lua_tostring(L,index-1);
                PPInfo := GetPropInfo(Comp.ClassInfo, Str);
                // OnXxxx -->OnLuaXxxx
                insert('Lua',Str,3);
                if (PPInfo<>nil) then begin
                  tm.Data := Pointer(cc);
                  tm.Code := cc.MethodAddress(Str);
                  SetMethodProp(Comp, PInfo, tm);
                end else begin
                  LuaError(L,'Method not found: ' + lua_tostring(L,index));
                end
              end
          end
	  else begin
               SetMethodProp(Comp, PInfo, tm);
          end
        end;
        tkSet:
            begin
               // writeln('SET ', Comp.Classname, StringToSet(PInfo,lua_tostring(L,index)));
               SetOrdProp(Comp, PInfo, StringToSet(PInfo,lua_tostring(L,index)));
            end;
	tkClass:
           begin
      	       SetInt64Prop(Comp, PInfo, Int64(Pointer(GetLuaObject(L, index))));
           end;
	tkInteger:
     	      SetOrdProp(Comp, PInfo, Round(lua_tonumber(L, index)));
	tkChar, tkWChar:
          begin
            Str := lua_tostring(L, index);
            if length(Str)<1 then
              SetOrdProp(Comp, PInfo, 0)
            else
              SetOrdProp(Comp, PInfo, Ord(Str[1]));
          end;
        tkBool:
               begin
		    // writeln(PInfo^.Name, lua_toboolean(L,index)); 
		    {$IFDEF UNIX}
                    propval := BoolToStr(lua_toboolean(L,index));
                    SetOrdProp(Comp, PInfo, GetEnumValue(PInfo^.PropType, PropVal));
		    {$ELSE}
                    SetPropValue(Comp, PInfo^.Name, lua_toboolean(L,index));
		    {$ENDIF}
               end;
        tkEnumeration:
	         begin
	            if lua_type(L, index) = LUA_TBOOLEAN then
                       propval := BoolToStr(lua_toboolean(L,index))
		    else
		       propVal := lua_tostring(L, index);
		    // writeln('ENUM ', Comp.Classname, PInfo^.Name, PropVal);
                    SetOrdProp(Comp, PInfo, GetEnumValue(PInfo^.PropType, PropVal));
	         end;
        tkFloat:
	      	SetFloatProp(Comp, PInfo, lua_tonumber(L, index));

        tkString, tkLString, tkWString:
	      	SetStrProp(Comp, PInfo, lua_tostring(L, index));

        tkInt64:
	      	SetInt64Prop(Comp, PInfo, Int64(Round(lua_tonumber(L, index))));
     else begin
               if (PInfo^.Proptype^.Name='TTranslateString') then
		    SetStrProp(Comp, PInfo, lua_tostring(L, index))
               else if (PInfo^.Proptype^.Name='AnsiString') then
		    SetStrProp(Comp, PInfo, lua_tostring(L, index))
	       else if (PInfo^.Proptype^.Name='WideString') then
		    SetStrProp(Comp, PInfo, lua_tostring(L, index))
               else
		    LuaError(L,'Property not supported: ' + PInfo^.Proptype^.Name);
	    end;
      end;
end;


// ****************************************************************
// Sets Property Values from a Lua table
// ****************************************************************

function SetPropertiesFromLuaTable(L: Plua_State; Obj:TObject; Index:Integer):Boolean;
var n: Integer;
    PInfo: PPropInfo;
    pName: String;
begin
  result := false;
  // L,1 is the Object self
  if lua_istable(L,Index) then begin
        n := lua_gettop(L);
        lua_pushnil(L);
        while (lua_next(L, n) <> 0) do begin
          pName := lua_tostring(L, -2);
  	  PInfo := GetPropInfo(Obj.ClassInfo,lua_tostring(L, -2));
  	  if PInfo <> nil then begin
             Result:=True;
             if lua_istable(L,-1) and (TObject(GetInt64Prop(Obj,pName))<>nil) then begin
                // Skip some unsupported properties of SynEdit
                if ( (UpperCase(pName)='GUTTER') or
                   (UpperCase(pName)='BOOKMARKOPTIONS')
                ) then
                  // ignore
                else
                  SetPropertiesFromLuaTable(L,TObject(GetInt64Prop(Obj,pName)),-1);

             end else
             // Special handling solved in setproperties!
             (*
             if (PInfo^.Proptype^.Name = 'TIcon') and
                (ComponentGlyphFile(TComponent(Obj),lua_tostring(L, -1)))
                then
             else
             if (PInfo^.Proptype^.Name = 'TStrings') and
                (ComponentStringList(TComponent(Obj), lua_tostring(L, -2), lua_tostring(L, -1)))
                then
             else
             *)
             begin
  	      try
  	   	  SetProperty(L, -1, TComponent(Obj), PInfo);
              except
                Result:=false;
            	break;
              end;
             end;
          end else begin
              // Skip some unsupported properties of SynEdit
              if ( (UpperCase(pName)='MARKUPINFO') ) then
                   // do nothing just skip
              else
              // No Propinfo, do it yourself...
              if ( ((UpperCase(pName)='BITMAP') or (UpperCase(pName)='PICTURE') or (UpperCase(pName)='IMAGE') or (UpperCase(pName)='GLYPH') or (UpperCase(pName)='ICON'))
                  and ((lua_isstring(L,-1) and (ComponentGlyphFile(TComponent(Obj),lua_tostring(L, -1))))) )
              then
              else
              if ( ((UpperCase(pName)='BITMAP') or (UpperCase(pName)='PICTURE') or (UpperCase(pName)='IMAGE') or (UpperCase(pName)='GLYPH') or (UpperCase(pName)='ICON'))
                  and ( not(lua_isstring(L,-1)) and (ComponentGlyphBuffer(TComponent(Obj),TImage(GetLuaObject(L, -1)))) ) )
              then
              else
              if (UpperCase(pName)='SHORTCUT') and (ComponentShortCut(TComponent(Obj),lua_tostring(L, -1))) then
              else
              if UpperCase(pName) = 'PARENT' then begin
                 TControl(Obj).Parent := TWinControl(GetLuaObject(L, -1));
              end else
              LuaError(L,'Property not found: '+Obj.ClassName+'.'+lua_tostring(L, -2)+ ' = ' + lua_tostring(L, -1) );
          end;
          lua_pop(L, 1);
        end;
        result := true;
  end;
end;


// ****************************************************************
// Sets Property Value
// ****************************************************************


function LuaSetProperty(L: Plua_State): Integer; cdecl;
var
  PInfo: PPropInfo;
  Comp: TComponent;
  propname: String;
  propType: String;
begin
  Result := 0;
  Comp := TComponent(GetLuaObject(L, 1));
  if (Comp=nil) then exit;

  PropName := lua_tostring(L, 2);

  if (lua_gettop(L)=3) and (lua_isstring(L,3)) and
     ((UpperCase(PropName)='BITMAP') or (UpperCase(PropName)='IMAGE') or (UpperCase(PropName)='ICON')) and
     (ComponentGlyphFile(TComponent(Comp),lua_tostring(L, 3))) then
  else
  if (UpperCase(PropName)='SHORTCUT') and (ComponentShortCut(TComponent(Comp),lua_tostring(L, -1))) then
  else
  if (lua_gettop(L)=3) and (lua_istable(L,3)) and ((PropName='_') (* or (UpperCase(PropName)='FONT')*) ) then begin
     SetPropertiesFromLuaTable(L,Comp,3);
(*  end
  else
  if (UpperCase(PropName)='TFONT') and (lua_gettop(L)=3) and (lua_istable(L,3)) and (PropName<>'_') then begin
     SetPropertiesFromLuaTable(LGetControlParents,Comp,3);
*)
  end else begin
    PInfo := GetPropInfo(TComponent(Comp).ClassInfo, PropName);
    if (PInfo <> nil) and (lua_gettop(L)=3) then begin
      PropType := PInfo^.Proptype^.Name;
      if lua_istable(L,3) and (TObject(GetInt64Prop(Comp,PropName))<>nil) then
          SetPropertiesFromLuaTable(L, TObject(GetInt64Prop(Comp,PropName)), 3)
      else
          SetProperty(L,3,Comp,PInfo);
    end else begin
       case lua_type(L,3) of
  		LUA_TNIL: LuaRawSetTableNil(L,1,lua_tostring(L, 2));
  		LUA_TBOOLEAN: LuaRawSetTableBoolean(L,1,lua_tostring(L, 2),lua_toboolean(L, 3));
  		LUA_TLIGHTUSERDATA: LuaRawSetTableLightUserData(L,1,lua_tostring(L, 2),lua_touserdata(L, 3));
  		LUA_TNUMBER: LuaRawSetTableNumber(L,1,lua_tostring(L, 2),lua_tonumber(L, 3));
  		LUA_TSTRING: LuaRawSetTableString(L,1,lua_tostring(L, 2),lua_tostring(L, 3));
  		LUA_TTABLE: LuaRawSetTableValue(L,1,lua_tostring(L, 2), 3);
  		LUA_TFUNCTION: LuaRawSetTableFunction(L,1,lua_tostring(L, 2),lua_CFunction(lua_touserdata(L, 3)));
       else
           if lowercase(PropName) = 'parent' then begin
              TWinControl(Comp).Parent := TWinControl(GetLuaObject(L, 3));

           end else
                   LuaError(L,'Property not found: '+PropName);
       end;
     end;
  end;
end;

// ****************************************************************

procedure lua_pushtable_object(L: Plua_State; Comp:TObject; index: Integer);
begin
    lua_newtable(L);
    LuaSetTableLightUserData(L, index, HandleStr, Pointer(Comp));
    LuaSetMetaFunction(L, index, '__index', @LuaGetProperty);
    LuaSetMetaFunction(L, index, '__newindex', @LuaSetProperty);
    // not needed on get!
    // lua_settable(L,index);
end;

//
function GetLuaObject(L: Plua_State; Index: Integer): TObject;
begin
  Result := TObject(LuaGetTableLightUserData(L, Index, HandleStr));
end;

// ****************************************************************
// Gets Property Value
// ****************************************************************
function LuaGetProperty(L: Plua_State): Integer; cdecl;
var
  PInfo, PPInfo: PPropInfo;
  proptype: String;
  propname: String;
  strValue: String;
  ordValue: Int64;
  Comp, Pcomp: TComponent;
begin
  Result := 1;
  Comp := TComponent(GetLuaObject(L, 1));
  PropName := lua_tostring(L, 2);
  PInfo := GetPropInfo(Comp.ClassInfo, PropName);
  // ShowMessage('PROP '+Comp.Classname+'.'+PropName);
  if PInfo <> nil then begin
    PropType := PInfo^.Proptype^.Name;
    if PropType = 'TFont' then
       TLuaFont(Comp).ToTable(L,-1,Comp)
    else if (Comp.ClassName = 'TLuaActionList') and  (UpperCase(PropName)='IMAGES') then
       TLuaImageList(TLuaActionList(Comp).Images).LuaCtl.ToTable(L,-1,TLuaImageList(TLuaActionList(Comp).Images))
    else
    begin
     case PInfo^.Proptype^.Kind of
          tkMethod:
            begin
               PPInfo := GetPropInfo(Comp.ClassInfo, PropName + '_FunctionName');
               if PPInfo <> nil then
                  lua_pushstring(L,pchar(GetStrProp(Comp, PPInfo)))
               else begin
                  lua_pushnil(L);
               end;
            end;
          tkSet:
            lua_pushstring(L,pchar(SetToString(PInfo,GetOrdProp(Comp, PInfo),true)));
	  tkClass:
             lua_pushtable_object(L, TObject(Ptr(GetInt64Prop(Comp, PInfo),0)),-1);
          tkInteger:
              lua_pushnumber(L,GetOrdProp(Comp, PInfo));
          tkChar,
          tkWChar:
            lua_pushnumber(L,GetOrdProp(Comp, PInfo));
          tkBool:
              begin
                   strValue := GetEnumName(PInfo^.PropType, GetOrdProp(Comp, PInfo));
                   if (strValue<>'') then
                      lua_pushboolean(L,StrToBool(strValue));
              end;
          tkEnumeration:
             lua_pushstring(L,PChar(GetEnumName(PInfo^.PropType, GetOrdProp(Comp, PInfo))));
          tkFloat:
            lua_pushnumber(L,GetFloatProp(Comp, PInfo));
          tkString,
          tkLString,
          tkWString:
            lua_pushstring(L,pchar(GetStrProp(Comp, PInfo)));
          tkInt64:
            lua_pushnumber(L,GetInt64Prop(Comp, PInfo));
      else begin
	        if (PInfo^.Proptype^.Name='TTranslateString') then begin
		        lua_pushstring(L,pchar(GetStrProp(Comp, PInfo)));
                end else if (PInfo^.Proptype^.Name='AnsiString') then begin
		        lua_pushstring(L,pchar(GetStrProp(Comp, PInfo)));
		end else begin
				lua_pushnil(L);
				LuaError(L,'Property not supported: '+lua_tostring(L,2) + ' ' + PInfo^.Proptype^.Name);
		end;
      end
    end;
    end
  end else begin
// try to find the property self
    if lowercase(lua_tostring(L,2)) = 'classname' then begin
       lua_pushstring(L, pchar(AnsiString(Comp.ClassName)));
    end else
    if lowercase(lua_tostring(L,2)) = 'parent' then begin
       lua_pushtable_object(L, Comp.Owner,-1);
    (* end else
    if lowercase(lua_tostring(L,2)) = 'canvas' then begin
       lua_pushtable_object(L, TWinControl(Comp).Canvas);
    *)
    end else begin
    // lua property?        
	case lua_type(L,1) of
	  LUA_TBOOLEAN:
             lua_pushBoolean(L, LuaRawGetTableBoolean(L,1,lua_tostring(L, 2)));
	  LUA_TLIGHTUSERDATA:
             lua_pushlightuserdata(L,LuaRawGetTableLightUserData(L,1,lua_tostring(L, 2)));
	  LUA_TNUMBER:
             lua_pushnumber(L,LuaRawGetTableNumber(L,1,lua_tostring(L, 2)));
	  LUA_TSTRING:
             lua_pushstring(L,PChar(LuaRawGetTableString(L,1,lua_tostring(L, 2))));
	  LUA_TTABLE:
            begin
                // ShowMessage('NOPROP '+Comp.Classname+'.'+PropName+' '+IntToStr(lua_type(L,1)));
	  	LuaRawGetTable(L,1,lua_tostring(L, 2));
	    end;
	  LUA_TFUNCTION:
            lua_pushcfunction(L,LuaRawGetTableFunction(L,1,lua_tostring(L, 2)));
	  else begin
               lua_pushnil(L);
	       LuaError(L,'(LuaGetProperty) Property not found: '+lua_tostring(L,2)+' type:'+IntToStr(lua_type(L,1)));
    	  end;
        end;
    end;
  end;
end;

end.
