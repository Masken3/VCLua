unit LuaColors;

interface

Uses LuaPas,Graphics;

procedure DefineColors(L: Plua_State);
procedure DefineOneColor(L: Plua_State; Colorname:String; Color:TColor);

implementation

Uses TypInfo, SysUtils;

procedure DefineOneColor(L: Plua_State; Colorname:String; Color:TColor);
begin
  lua_pushliteral (L, pchar(ColorName));
	lua_pushnumber (L, Color);
	lua_settable (L, -3);
end;

procedure DefineColors(L: Plua_State);
begin
DefineOneColor(L,'clNone',clNone);
DefineOneColor(L,'clAqua',clAqua);
DefineOneColor(L,'clBlack',clBlack);
DefineOneColor(L,'clBlue',clBlue);
DefineOneColor(L,'clDkGray',clDkGray);
DefineOneColor(L,'clFuchsia',clFuchsia);
DefineOneColor(L,'clGray',clGray);
DefineOneColor(L,'clGreen',clGreen);
DefineOneColor(L,'clLime',clLime);
DefineOneColor(L,'clLtGray',clLtGray);
DefineOneColor(L,'clMaroon',clMaroon);
DefineOneColor(L,'clNavy',clNavy	);
DefineOneColor(L,'clOlive',clOlive	);
DefineOneColor(L,'clPurple',clPurple);
DefineOneColor(L,'clRed',clRed	);
DefineOneColor(L,'clSilver',clSilver);
DefineOneColor(L,'clTeal',clTeal	);
DefineOneColor(L,'clWhite',clWhite	);
DefineOneColor(L,'clYellow',clYellow);

DefineOneColor(L,'clScrollBar',clScrollBar	);
DefineOneColor(L,'clActiveCaption',clActiveCaption);
DefineOneColor(L,'clInactiveCaption',clInactiveCaption	);
DefineOneColor(L,'clMenu',clMenu	);
DefineOneColor(L,'clWindow',clWindow	);
DefineOneColor(L,'clWindowFrame',clWindowFrame);
DefineOneColor(L,'clMenuText',clMenuText	);
DefineOneColor(L,'clWindowText',clWindowText	);
DefineOneColor(L,'clCaptionText',clCaptionText	);
DefineOneColor(L,'clActiveBorder',clActiveBorder	);
DefineOneColor(L,'clInactiveBorder',clInactiveBorder);
DefineOneColor(L,'clAppWorkspace',clAppWorkspace	);
DefineOneColor(L,'clBtnFace',clBtnFace);
DefineOneColor(L,'clBtnShadow',clBtnShadow);
DefineOneColor(L,'clGrayText',clGrayText);
DefineOneColor(L,'clBtnText',clBtnText);
DefineOneColor(L,'clInactiveCaptionText',clInactiveCaptionText	);
DefineOneColor(L,'clBtnHighlight',clBtnHighlight	);
DefineOneColor(L,'cl3DDkShadow',cl3DDkShadow	);
DefineOneColor(L,'cl3DLight',cl3DLight	);
DefineOneColor(L,'clInfoText',clInfoText	);
DefineOneColor(L,'clInfoBk',clInfoBk	);
DefineOneColor(L,'clHighlightText',clHighlightText	);
end;

end.
