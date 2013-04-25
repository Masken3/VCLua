library vcl;

{$mode objfpc}{$H+}

{$IFDEF WINDOWS}{$R vcl.rc}{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  LResources,
  Forms,

  Lua in 'src/Lua.pas',
  LuaPas in 'src/LuaPas.pas',
  LuaFont in 'src/LuaFont.pas',
  LuaStrings in 'src/LuaStrings.pas',
  LuaControl in 'src/LuaControl.pas',
  LuaProperties in 'src/LuaProperties.pas',
  LuaApplication in 'src/LuaApplication.pas',
  LuaForm in 'src/LuaForm.pas',
  {$I genericsrc/genuses.inc}
  LuaMenu in 'src/LuaMenu.pas',
  LuaActionList in 'src/LuaActionList.pas',
  LuaToolbar in 'src/LuaToolbar.pas',
  LuaTree in 'src/LuaTree.pas',
  LuaEditButton in 'src/LuaEditButton.pas',
  LuaStringGrid in 'src/LuaStringGrid.pas',
  LuaTrayIcon in 'src/LuaTrayIcon.pas',
  LuaStatusBar in 'src/LuaStatusBar.pas',
  LuaImage in 'src/LuaImage.pas',
  LuaImageList in 'src/LuaImageList.pas',
  LuaProgressBar in 'src/LuaProgressBar.pas',
  LuaDialogs in 'src/LuaDialogs.pas',
  LuaFileDialog in 'src/LuaFileDialog',
  LuaFindDialog in 'src/LuaFindDialog.pas',
  LuaDateEdit in 'src/LuaDateEdit.pas',
  LuaFileListBox in 'src/LuaFileListBox.pas',

  LuaXMLConfig in 'src/LuaXMLConfig.pas',

  LuaSyn in 'src/LuaSyn.pas',
  LuaSynEdit in 'src/LuaSynEdit',
  
  LuaColors in 'src/LuaColors.pas',
  LuaMouse in 'src/LuaMouse.pas';

const
  LUA_VCL_LIBNAME = 'VCL';
  LIB_COUNT = 36 + {$I genericsrc/genlibcount.inc};

var
   vcl_lib : array[0..LIB_COUNT] of lual_reg = (
		(name:'Application'; func:@CreateApplication),
		(name:'Form'; func:@CreateForm),

		(name:'MainMenu'; func:@CreateMainMenu),
		(name:'PopupMenu'; func:@CreatePopupMenu),
		(name:'MenuItem'; func:@CreateMenuItem),
                (name:'ToolBar'; func:@CreateToolBar),
                (name:'ToolButton'; func:@CreateToolButton),

		{$I genericsrc/genlibs.inc}

		(name:'ActionList'; func:@CreateActionList),
		(name:'Action'; func:@CreateAction),
		(name:'StringGrid'; func:@CreateStringGrid),
		(name:'StatusBar'; func:@CreateStatusBar),
		(name:'TrayIcon'; func:@CreateTrayIcon),
		(name:'Image'; func:@CreateImage),
		(name:'ImageList'; func:@CreateImageList),
		(name:'ProgressBar'; func:@CreateProgressBar),
		(name:'Tree'; func:@CreateTree),
		(name:'EditButton'; func:@CreateEditButton),

		// Dialogs
		(name:'OpenDlg'; func:@CreateOpenDialog),
		(name:'SaveDlg'; func:@CreateSaveDialog),
		(name:'SelectDirectoryDlg'; func:@CreateSelectDirectoryDialog),
		(name:'ColorDlg'; func:@CreateColorDialog),
		(name:'FontDlg'; func:@CreateFontDialog ),
		(name:'FindDlg'; func:@CreateFindDialog),
		(name:'ReplaceDlg'; func:@CreateReplaceDialog),

		(name:'DateEdit'; func:@CreateDateEdit),
		(name:'FileListBox'; func:@CreateFileListBox),

		// builtin
		(name:'ShowMessage'; func:@LuaShowMessage),
		(name:'MessageDlg'; func:@LuaMessageDlg),
		(name:'GetCursorPos'; func:@GetCursorPos),
		(name:'XMLConfig'; func:@CreateXMLConfig),

		// SynEdit
		(name:'SynEdit'; func:@CreateSynEditor),

		// Help
		(name:'ListProperties'; func:@LuaListProperties),

		// LUA
		(name:'RunSeparate'; func:@RunSeparate),
				
		// OS
                (name:'FileExists'; func:@LuaFileExists),
                (name:'DirectoryExists'; func:@LuaDirectoryExists),
                (name:'GetScreenSize'; func:@GetScreenSize),


		(name:nil;func:nil)
   );


function luaopen_vcl(L: Plua_State): Integer; cdecl;
begin
  luaL_openlib(L, LUA_VCL_LIBNAME, @vcl_lib, 0);
  lua_pushliteral (L, '_COPYRIGHT');
  lua_pushliteral (L, 'Copyright (C) 2006,2010 Hi-Project Ltd.');
  lua_settable (L, -3);
  lua_pushliteral (L, '_DESCRIPTION');
  lua_pushliteral (L, 'VCLua Visual Controls for LUA (5.x)');
  lua_settable (L, -3);
  lua_pushliteral (L, '_NAME');
  lua_pushliteral (L, 'VCLua');
  lua_settable (L, -3);
  lua_pushliteral (L, '_VERSION');
  lua_pushliteral (L, '0.3.5');
  lua_settable (L, -3);

  DefineColors(L);

  result := 1;
end;

exports luaopen_vcl;

initialization

// {$I vcl.lrs}

end.

