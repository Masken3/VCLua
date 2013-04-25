unit LuaControl;

interface

Uses Controls, ExtCtrls, Classes, Types, Forms, Grids,
     LuaPas,
     Lua,
     SynEdit,
     SynEditKeyCmds,
     LclType,
     Messages,
     SysUtils;

type

    ToTableProc = procedure(LL:Plua_State; Index:Integer; Sender:TObject);

    TLuaControl = class(TComponent)
        constructor Create(Owner:TComponent; LL: Plua_State; T:ToTableProc);

        public
          L: Plua_State;
          ToTable: ToTableProc;
        private

          // LUA Event Strings
          fOnLuaCreate_Func,
          fOnLuaClick_Func,
          fOnLuaDblClick_Func,
          fOnLuaDestroy_Func,
          fOnLuaShow_Func,
          fOnLuaHide_Func,
          fOnLuaActivate_Func,
          fOnLuaDeactivate_Func,
          fOnLuaResize_Func,
          fOnLuaPaint_Func,
          fOnLuaClose_Func,
          fOnLuaCloseQuery_Func,
          fOnLuaWindowStateChange_Func,
          fOnLuaChangeBounds_Func,

          fOnLuaEnter_Func,
          fOnLuaExit_Func,
          fOnLuaChange_Func,

          fOnLuaKeyDown_Func,
          fOnLuaKeyUp_Func,
          fOnLuaMouseDown_Func,
          fOnLuaMouseUp_Func,
          fOnLuaMouseMove_Func,
          fOnLuaMouseWheel_Func,
          fOnLuaMouseWheelDown_Func,
          fOnLuaMouseWheelUp_Func,
	  fOnLuaMouseEnter_Func,
          fOnLuaMouseExit_Func,
		  
	  //StringGrid
          fOnLuaHeaderClick_Func,
          fOnLuaEditButtonClick_Func,
		  fOnLuaSelectCell_Func,
          fOnLuaDrawCell_Func,
          fOnLuaGetEditText_Func,
          fOnLuaGetEditMask_Func,
          fOnLuaSetEditText_Func,
          fOnLuaColumnMoved_Func,
          fOnLuaRowMoved_Func,
          fOnLuaTopLeftChanged_Func,
          // DropFiles
          fOnLuaDropFiles_Func,
          // DragDrop
          fOnLuaDragDrop_Func,
          fOnLuaDragOver_Func,
          // Docking
          fOnLuaDockDrop_Func,
	  fOnLuaDockOver_Func,
	  fOnLuaUnDock_Func,
	  fOnLuaStartDock_Func,
	  fOnLuaEndDock_Func,
	  // Action
          fOnLuaExecute_Func,
          fOnLuaUpdate_Func,
	  // Timer
	  fOnLuaTimer_Func,
	  fOnLuaIdleTimer_Func,
	  
          // Extended edit
          fOnLuaAcceptDirectory_Func,
          fOnLuaAcceptFileName_Func,
          fOnLuaAcceptValue_Func,
          fOnLuaAcceptDate_Func,
	  fOnLuaButtonClick_Func,
          //PageControl
          fOnLuaPageChanged_func,

          //FindDialog
          fOnLuaFind_Func,
          fOnLuaReplace_Func,

          //SynEdit
          fOnLuaReplaceText_Func,
          fOnLuaCommandProcessed_Func,
          fOnLuaClickLink_Func,
          fOnLuaMouseLink_Func,

          // Min/Max
          fOnLuaMinimize_Func,
          fOnLuaMaximize_Func : String;

        published

          // procedure ToTable(LL:Plua_State; Index:Integer; Sender:TObject);
          // LUA Events
          procedure OnLuaChangeBounds(Sender: TObject);
          procedure OnLuaCreate(Sender: TObject);
          procedure OnLuaDeactivate(Sender: TObject);
          procedure OnLuaClick(Sender: TObject);
          procedure OnLuaDblClick(Sender: TObject);
          procedure OnLuaDestroy(Sender: TObject);
          procedure OnLuaShow(Sender: TObject);
          procedure OnLuaHide(Sender: TObject);
          procedure OnLuaActivate(Sender: TObject);
          procedure OnLuaResize(Sender: TObject);
          procedure OnLuaPaint(Sender: TObject);
          procedure OnLuaClose(Sender: TObject; var Action: TCloseAction);
          procedure OnLuaCloseQuery(Sender: TObject; var CanClose: Boolean);
          procedure OnLuaWindowStateChange(Sender: TObject);
          procedure OnLuaEnter(Sender: TObject);
          procedure OnLuaExit(Sender: TObject);
          procedure OnLuaChange(Sender: TObject);
          procedure OnLuaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
          procedure OnLuaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
          procedure OnLuaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
          procedure OnLuaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
          procedure OnLuaMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
          procedure OnLuaMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
          procedure OnLuaMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
          procedure OnLuaMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
	      procedure OnLuaMouseEnter(Sender: TObject);
          procedure OnLuaMouseExit(Sender: TObject);

          //PageControl
          procedure OnLuaPageChanged(Sender: TObject);

          //Action
	  procedure OnLuaExecute(Sender: TObject);
	  procedure OnLuaUpdate(Sender: TObject);

	  //Timer
	  procedure OnLuaTimer(Sender: TObject);
	  procedure OnLuaIdleTimer(Sender: TObject);

          // Extended Edit
          procedure OnAcceptDirectory(Sender: TObject; var Value: String);
          procedure OnAcceptFileName(Sender: TObject; var Value: String);
          procedure OnAcceptValue(Sender: TObject; var AValue: Double; var Action: Boolean);
          procedure OnAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: Boolean);
		  procedure OnLuaButtonClick(Sender: TObject);
		  
          //StringGrid
          procedure OnLuaHeaderClick(Sender: TObject; IsColumn: Boolean; Index:Integer);
          procedure OnLuaEditButtonClick(Sender: TObject);
	  procedure OnLuaSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
          procedure OnLuaDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
          procedure OnLuaGetEditText(Sender: TObject; ACol, ARow: Longint; var Value: string);
          procedure OnLuaGetEditMask(Sender: TObject; ACol, ARow: Longint; var Value: string);
          procedure OnLuaSetEditText(Sender: TObject; ACol, ARow: Longint; var Value: string);
          procedure OnLuaColumnMoved(Sender: TObject; FromIndex, ToIndex: Longint);
          procedure OnLuaRowMoved(Sender: TObject; FromIndex, ToIndex: Longint);
          procedure OnLuaTopLeftChanged(Sender: TObject);

          // DropFiles
          procedure OnLuaDropFiles(Sender: TObject; const FileNames: array of String);
          // DragDrop
          procedure OnLuaDragDrop(Sender: TObject; Source: TObject; X, Y: Integer);
          procedure OnLuaDragOver(Sender: TObject; Source: TObject; X, Y: Integer;State: TDragState; var Accept: Boolean);
          // Docking
          procedure OnLuaDockDrop(Sender: TObject; Source: TDragDockObject; X, Y: Integer);
          procedure OnLuaDockOver(Sender: TObject; Source: TDragDockObject; X, Y: Integer;State: TDragState; var Accept: Boolean);
          procedure OnLuaUnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
          procedure OnLuaStartDock(Sender: TObject; var DockObject: TDragDockObject);
          procedure OnLuaEndDock(Sender: TObject; Target: TObject; X, Y: Integer);
          // FindDialog
          procedure OnLuaFind(Sender: TObject);
          procedure OnLuaReplace(Sender: TObject);

          //SynEdit
          procedure OnLuaReplaceText(Sender: TObject; const ASearch,
                    AReplace: string; Line, Column: integer; var ReplaceAction: TSynReplaceAction);
          procedure OnLuaCommandProcessed(Sender: TObject;
                    var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
          procedure OnLuaClickLink(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
          procedure OnLuaMouseLink(Sender: TObject; X, Y: Integer; var AllowMouseLink: Boolean);

          // ----------------------------------------------------------------------------------------
          // SynEdit
          procedure ReplaceTextEventHandler(Sender: TObject; EventFunc:String; const ASearch,
                    AReplace: string; Line, Column: integer; var ReplaceAction: TSynReplaceAction);
          procedure CommandProcessedEventHandler(Sender: TObject; EventFunc:String;
                    var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
          procedure ClickLinkEventHandler(Sender: TObject; EventFunc:String; Button: TMouseButton;
                    Shift: TShiftState; X, Y: Integer);
          procedure MouseLinkEventHandler(Sender: TObject; EventFunc:String; X, Y: Integer;
                    var AllowMouseLink: Boolean);

          // Events
          procedure NotifyEventHandler(Sender: TObject; EventFunc:String);
          procedure KeyEventHandler(Sender: TObject; EventFunc:String; var Key: Word; Shift: TShiftState);
          procedure MouseEventHandler(Sender: TObject; EventFunc:String; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
          procedure MouseMoveEventHandler(Sender: TObject; EventFunc:String; Shift: TShiftState; X, Y: Integer);
          procedure MouseWheelEventHandler(Sender: TObject; EventFunc:String; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
          procedure MouseWheelUpDownEventHandler(Sender: TObject; EventFunc:String; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
          // DropFiles
          procedure DropFilesEventHandler(Sender: TObject; EventFunc:String; const FileNames: array of String);
          // DragDrop
          procedure DragDropEventHandler(Sender: TObject; EventFunc:String; Source: TObject; X, Y: Integer);
          procedure DragOverEventHandler(Sender: TObject; EventFunc:String; Source: TObject; X, Y: Integer;State: TDragState; var Accept: Boolean);
          procedure StartDragEventHandler(Sender: TObject; EventFunc:String; var DragObject: TDragObject);
          procedure EndDragEventHandler(Sender: TObject; EventFunc:String; Target: TObject; X, Y: Integer);
          // Dock
          procedure DockDropEventHandler(Sender: TObject; EventFunc:String; Source:TDragDockObject; X, Y: Integer);
          procedure DockOverEventHandler(Sender: TObject; EventFunc:String; Source:TDragDockObject; X, Y: Integer;State: TDragState; var Accept: Boolean);
          procedure StartDockEventHandler(Sender: TObject; EventFunc:String; var DockObject: TDragDockObject);
          procedure EndDockEventHandler(Sender: TObject; EventFunc:String; Target: TObject; X, Y: Integer);
          procedure UnDockEventHandler(Sender: TObject; EventFunc:String; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
          // Form related
          procedure CloseEventHandler(Sender: TObject; EventFunc:String; var Action: TCloseAction);
          procedure CloseQueryEventHandler(Sender: TObject; EventFunc:String; var CanClose: Boolean);
          // StringGrid related
          procedure HeaderClickEventHandler(Sender: TObject; EventFunc:String; IsColumn: Boolean; Index:Integer);
	  procedure SelectCellEventHandler(Sender: TObject; EventFunc:String; ACol, ARow: Longint; var CanSelect: Boolean);
	  procedure DrawCellEventHandler(Sender: TObject; EventFunc:String; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
	  procedure GetEditTextEventHandler(Sender: TObject; EventFunc:String; ACol, ARow: Longint; var Value: string);
          procedure SetEditTextEventHandler(Sender: TObject; EventFunc:String; ACol, ARow: Longint; var Value: string);
	  procedure RowColumnMovedEventHandler(Sender: TObject; EventFunc:String; FromIndex, ToIndex: Longint);
          // Extended edit
          procedure AcceptDirectoryHandler(Sender: TObject; EventFunc:String; var Value: String);
          procedure AcceptFileNameHandler(Sender: TObject; EventFunc:String; var Value: String);
          procedure AcceptValueHandler(Sender: TObject; EventFunc:String; var AValue: Double; var Action: Boolean);
          procedure AcceptDateHandler(Sender: TObject; EventFunc:String; var ADate: TDateTime; var AcceptDate: Boolean);

        published

          // LUA Events
          // min/Max
          // property OnMinimize: String read fOnLuaMinimize_Func write fOnLuaMinimize_Func;
          // property OnMaximize: String read fOnLuaMaximize_Func write fOnLuaMaximize_Func;
          property OnMinimize_Function: String read fOnLuaMinimize_Func write fOnLuaMinimize_Func;
          property OnMaximize_Function: String read fOnLuaMaximize_Func write fOnLuaMaximize_Func;
          // Events
          property OnChangeBounds_Function:String read fOnLuaChangeBounds_Func write fOnLuaChangeBounds_Func;
          property OnClick_Function: String read fOnLuaClick_Func write fOnLuaClick_Func;
          property OnDblClick_Function: String read fOnLuaDblClick_Func write fOnLuaDblClick_Func;
          property OnCreate_Function: String read fOnLuaCreate_Func write fOnLuaCreate_Func;
          property OnDestroy_Function: String read fOnLuaDestroy_Func write fOnLuaDestroy_Func;
          property OnShow_Function: String read fOnLuaShow_Func write fOnLuaShow_Func;
          property OnHide_Function: String read fOnLuaHide_Func write fOnLuaHide_Func;
          property OnActivate_Function: String read fOnLuaActivate_Func write fOnLuaActivate_Func;
          property OnDeactivate_Function: String read fOnLuaDeactivate_Func write fOnLuaDeactivate_Func;
          property OnResize_Function: String read fOnLuaResize_Func write fOnLuaResize_Func;
          property OnPaint_Function: String read fOnLuaPaint_Func write fOnLuaPaint_Func;
          property OnClose_Function: String read fOnLuaClose_Func write fOnLuaClose_Func;
          property OnCloseQuery_Function: String read fOnLuaCloseQuery_Func write fOnLuaCloseQuery_Func;
          property OnWindowStateChange_Function: String read fOnLuaWindowStateChange_Func write fOnLuaWindowStateChange_Func;

          property OnEnter_Function: String read fOnLuaEnter_Func write fOnLuaEnter_Func;
          property OnExit_Function: String read fOnLuaExit_Func write fOnLuaExit_Func;
          property OnChange_Function: String read fOnLuaChange_Func write fOnLuaChange_Func;

          property OnKeyDown_Function: String read fOnLuaKeyDown_Func write fOnLuaKeyDown_Func;
          property OnKeyUp_Function: String read fOnLuaKeyUp_Func write fOnLuaKeyUp_Func;
          property OnMouseDown_Function: String read fOnLuaMouseDown_Func write fOnLuaMouseDown_Func;
          property OnMouseUp_Function: String read fOnLuaMouseUp_Func write fOnLuaMouseUp_Func;
          property OnMouseMove_Function: String read fOnLuaMouseMove_Func write fOnLuaMouseMove_Func;
          property OnMouseWheel_Function: String read fOnLuaMouseWheel_Func write fOnLuaMouseWheel_Func;
          property OnMouseWheelDown_Function: String read fOnLuaMouseWheelDown_Func write fOnLuaMouseWheelDown_Func;
          property OnMouseWheelUp_Function: String read fOnLuaMouseWheelUp_Func write fOnLuaMouseWheelUp_Func;
	  property OnMouseEnter_Function: String read fOnLuaMouseEnter_Func write fOnLuaMouseEnter_Func;
          property OnMouseExit_Function: String read fOnLuaMouseExit_Func write fOnLuaMouseExit_Func;

          //PageControl
          property OnPageChanged_Function: String read fOnLuaPageChanged_func write fOnLuaPageChanged_func;
          // Action
	  property OnExecute_Function: String read fOnLuaExecute_Func write fOnLuaExecute_Func;
	  property OnUpdate_Function: String read fOnLuaUpdate_Func write fOnLuaUpdate_Func;

	  // Timer
	  property OnTimer_Function: String read fOnLuaTimer_Func write fOnLuaTimer_Func;
	  property OnIdleTimer_Function: String read fOnLuaIdleTimer_Func write fOnLuaIdleTimer_Func;

          // Extended edit
          property OnAcceptDirectory_Function: String read fOnLuaAcceptDirectory_Func write fOnLuaAcceptDirectory_Func;
          property OnAcceptFileName_Function: String read fOnLuaAcceptFileName_Func write fOnLuaAcceptFileName_Func;
          property OnAcceptValue_Function: String read fOnLuaAcceptValue_Func write fOnLuaAcceptValue_Func;
          property OnAcceptDate_Function: String read fOnLuaAcceptDate_Func write fOnLuaAcceptDate_Func;
	  property OnButtonClick_Function: String read fOnLuaButtonClick_Func write fOnLuaButtonClick_Func;
          
		  // StringGrid
          property OnEditButtonClick_Function: String read fOnLuaEditButtonClick_Func write fOnLuaEditButtonClick_Func;
          property OnHeaderClick_Function: String read fOnLuaHeaderClick_Func write fOnLuaHeaderClick_Func;
	  property OnSelectCell_Function: String read fOnLuaSelectCell_Func write fOnLuaSelectCell_Func;
          property OnDrawCell_Function: String read fOnLuaDrawCell_Func write fOnLuaDrawCell_Func;
          property OnGetEditText_Function: String read fOnLuaGetEditText_Func write fOnLuaGetEditText_Func;
          property OnGetEditMask_Function: String read fOnLuaGetEditMask_Func write fOnLuaGetEditMask_Func;
          property OnSetEditText_Function: String read fOnLuaSetEditText_Func write fOnLuaSetEditText_Func;
          property OnColumnMoved_Function: String read fOnLuaColumnMoved_Func write fOnLuaColumnMoved_Func;
          property OnRowMoved_Function: String read fOnLuaRowMoved_Func write fOnLuaRowMoved_Func;
          property OnTopLeftChanged_Function: String read fOnLuaTopLeftChanged_Func write fOnLuaTopLeftChanged_Func;          

          // DropFiles
          property OnDropFiles_Function: String read fOnLuaDropFiles_Func write fOnLuaDropFiles_Func;
          // DragDrop
          property OnDragDrop_Function: String read fOnLuaDragDrop_Func write fOnLuaDragDrop_Func;
          property OnDragOver_Function: String read fOnLuaDragOver_Func write fOnLuaDragOver_Func;
	  // Docking
          property OnDockDrop_Function: String read fOnLuaDockDrop_Func write fOnLuaDockDrop_Func;
          property OnDockOver_Function: String read fOnLuaDockOver_Func write fOnLuaDockOver_Func;
          property OnUnDock_Function: String read fOnLuaUnDock_Func write fOnLuaUnDock_Func;
          property OnStartDock_Function: String read fOnLuaStartDock_Func write fOnLuaStartDock_Func;
          property OnEndDock_Function: String read fOnLuaEndDock_Func write fOnLuaEndDock_Func;

          // Find and Replace Dialog
          property OnFind_Function: String read fOnLuaFind_Func write fOnLuaFind_Func;
          property OnReplace_Function: String read fOnLuaReplace_Func write fOnLuaReplace_Func;

          //SynEdit
          property OnReplaceText_Function: String read fOnLuaReplaceText_Func write fOnLuaReplaceText_Func;
          property OnCommandProcessed_Function: String read fOnLuaCommandProcessed_Func write fOnLuaCommandProcessed_Func;

          property OnClickLink_Function: String read fOnLuaClickLink_Func write fOnLuaClickLink_Func;
          property OnMouseLink_Function: String read fOnLuaMouseLink_Func write fOnLuaMouseLink_Func;

     end;

     TLuaBaseControl = class(TComponent)
         LuaCtl: TLuaControl;
     end;

// *************************************************************************
procedure GetControlParents(L: Plua_State; var Parent:TComponent; var Name:String);
procedure SetDefaultMethods(L: Plua_State; Index:Integer; Sender:TObject);
procedure SetStringListMethods(L: Plua_State; Index: Integer; Sender: TObject);
procedure SetAnchorMethods(L: Plua_State; Index: Integer; Sender: TObject);

// extended properties
function ComponentStringList(Comp: TComponent; name:String; value:String):boolean;
function ComponentGlyphFile(Comp: TComponent; imgName:String): boolean;
function ComponentGlyphBuffer(Comp: TComponent; image:TImage): boolean;
function ComponentBitmapString(Comp: TComponent; imageStr:String): boolean;
function ComponentShortCut(Comp: TComponent; scName:String): boolean;

// default methods
function ControlFree(L: Plua_State): Integer; cdecl;
function ControlFocus(L: Plua_State): Integer; cdecl;
function ControlRefresh(L: Plua_State): Integer; cdecl;
function ControlParentName(L: Plua_State): Integer; cdecl;
function ControlGlyph(L: Plua_State): Integer; cdecl;
function GetLuaState(Sender:TObject):Plua_State;
function CheckEvent(L:Plua_State; Sender: TObject; EFn:String):Boolean;

function ControlAnchorSide(L: Plua_State): Integer; cdecl;
function ControlAnchorSideControl(L: Plua_State): Integer; cdecl;
function ControlAnchorToNeighbour(L: Plua_State): Integer; cdecl;
function ControlAnchorParallel(L: Plua_State): Integer; cdecl;
function ControlAnchorHorizontalCenterTo(L: Plua_State): Integer; cdecl;
function ControlAnchorVerticalCenterTo(L: Plua_State): Integer; cdecl;

implementation

Uses TypInfo,
     base64,
     Buttons,
     Graphics,
     LuaImage,
     ImgList,
     LuaStrings,
     LuaProperties,
     Menus,
     Dialogs,
     LCLProc,
     ComCtrls;

{$I showstack.inc}
     
// ***********************************************
// LUA Control Methods
// ***********************************************
procedure SetDefaultMethods(L: Plua_State; Index: Integer; Sender: TObject);
begin
	lua_newtable(L);
	LuaSetTableLightUserData(L, Index, HandleStr, Pointer(Sender));
	LuaSetTableFunction(L, index, 'Free', ControlFree);
	LuaSetTableFunction(L, index, 'SetFocus', ControlFocus);
        LuaSetTableFunction(L, index, 'Refresh', ControlRefresh);
end;

procedure SetAnchorMethods(L: Plua_State; Index: Integer; Sender: TObject);
begin
        LuaSetTableFunction(L, index, 'AnchorSide', ControlAnchorSide);
        LuaSetTableFunction(L, index, 'AnchorSideControl', ControlAnchorSideControl);

        LuaSetTableFunction(L, index, 'AnchorToNeighbour', ControlAnchorToNeighbour);
        LuaSetTableFunction(L, index, 'AnchorParallel', ControlAnchorParallel);
        LuaSetTableFunction(L, index, 'AnchorHorizontalCenterTo', ControlAnchorHorizontalCenterTo);
        LuaSetTableFunction(L, index, 'AnchorVerticalCenterTo', ControlAnchorVerticalCenterTo);
end;

procedure SetStringListMethods(L: Plua_State; Index: Integer; Sender: TObject);
begin
	LuaSetTableFunction(L, Index, 'GetText', StringsGet);
	LuaSetTableFunction(L, Index, 'SetText', StringsSet);
	LuaSetTableFunction(L, Index, 'Add', StringsAdd);
	LuaSetTableFunction(L, Index, 'Insert', StringsInsert);
	LuaSetTableFunction(L, Index, 'Delete', StringsDelete);
	LuaSetTableFunction(L, Index, 'Clear', StringsClear);
	LuaSetTableFunction(L, Index, 'Count', StringsCount);

        LuaSetTableFunction(L, Index, 'Index', ListIndex);
        LuaSetTableFunction(L, Index, 'Get', ListGet);
        LuaSetTableFunction(L, Index, 'GetChecked', ListGetChecked);
        LuaSetTableFunction(L, Index, 'Toggle', CheckListToggle);
        LuaSetTableFunction(L, Index, 'ItemAtPos', ListItemAtPos);
        LuaSetTableFunction(L, Index, 'ItemEnabled', CheckListItemEnabled);
end;

procedure GetControlParents;
var n:Integer;
begin
  Parent := nil;
  Name := '';
  n := lua_gettop(L);
  if n>0 then begin
    if lua_istable(L,1) then begin
       Parent := TComponent(GetLuaObject(L, 1));
       if n=2 then
          Name := lua_tostring(L,2);
    end
  end;
  if not Assigned(Parent) then begin
     Parent := Application.MainForm;
  end;
  if Name = '' then begin
     Name := FormatDateTime('ymdhns',now())+IntToStr(Random(999999));
     for n:=1 to length(Name) do
         Name[n]:=char(ord(Name[n])+17+Random(14)); 
  end;
end;

function ControlFree(L: Plua_State): Integer; cdecl;
var
  lC: TComponent;
begin
  CheckArg(L, 1);
  lC := TComponent(GetLuaObject(L, 1));
  LC.Free;
  LC := nil;
  LuaSetTableClear(L, 1);
  Result := 0;
end;

function ControlFocus(L: Plua_State): Integer; cdecl;
var
  lC: TWinControl;
begin
  CheckArg(L, 1);
  lC := TWincontrol(GetLuaObject(L, 1));
  lC.Setfocus;
  Result := 0;
end;

function ControlRefresh(L: Plua_State): Integer; cdecl;
var
  lC: TWinControl;
begin
  CheckArg(L, 1);
  lC := TWincontrol(GetLuaObject(L, 1));
  lC.Refresh;
  Result := 0;
end;


function ControlParentName(L: Plua_State): Integer; cdecl;
var
  lC: TWinControl;
begin
  CheckArg(L, 1);
  lC := TWincontrol(GetLuaObject(L, 1));
  if (lC<>nil) and Assigned(lC.Parent) then
      lua_pushString(L,pchar(lC.Parent.Name))
  else
      lua_pushnil(L);
  Result := 1;
end;

// ***************************************************************
//  TAnchorKind = (akTop, akLeft, akRight, akBottom);
//  TAnchorSideReference = (asrTop, asrBottom, asrCenter);
function getAnchorKind(ak: string):TAnchorKind;
begin
     result := akTop;
     if uppercase(ak)='AKLEFT' then
        result := akLeft
     else if uppercase(ak)='AKRIGHT' then
        result := akRight
     else if uppercase(ak)='AKBOTTOM' then
        result := akBottom;
end;

function getAnchorRef(ar: string):TAnchorSideReference;
begin
     result := asrTop;
     if uppercase(ar)='ASRCENTER' then
        result := asrCenter
     else if uppercase(ar)='ASRLEFT' then
        result := asrLeft
     else if uppercase(ar)='ASRRIGHT' then
        result := asrRight
     else if uppercase(ar)='ASRBOTTOM' then
        result := asrBottom;
end;

function ControlAnchorToNeighbour(L: Plua_State): Integer; cdecl;
var
  lC: TComponent;
begin
  CheckArg(L, 4);
  lC := TComponent(GetLuaObject(L, 1));
  TControl(lC).AnchorToNeighbour(getAnchorKind(lua_tostring(L,2)), trunc(lua_tonumber(L,3)) ,TControl(GetLuaObject(L, 4)));
  Result := 0;
end;

function ControlAnchorParallel(L: Plua_State): Integer; cdecl;
var
  lC: TComponent;
begin
  CheckArg(L, 4);
  lC := TComponent(GetLuaObject(L, 1));
  TControl(lC).AnchorParallel(getAnchorKind(lua_tostring(L,2)), trunc(lua_tonumber(L,3)) ,TControl(GetLuaObject(L, 4)));
  Result := 0;
end;

function ControlAnchorHorizontalCenterTo(L: Plua_State): Integer; cdecl;
var
  lC: TComponent;
begin
  CheckArg(L, 2);
  lC := TComponent(GetLuaObject(L, 1));
  TControl(lC).AnchorHorizontalCenterTo(TControl(GetLuaObject(L, 2)));
  Result := 0;
end;

function ControlAnchorVerticalCenterTo(L: Plua_State): Integer; cdecl;
var
  lC: TComponent;
begin
  CheckArg(L, 2);
  lC := TComponent(GetLuaObject(L, 1));
  TControl(lC).AnchorVerticalCenterTo(TControl(GetLuaObject(L, 2)));
  Result := 0;
end;


function ControlAnchorSide(L: Plua_State): Integer; cdecl;
var
  lC: TComponent;
begin
  CheckArg(L, 3);
  lC := TComponent(GetLuaObject(L, 1));
  TControl(lC).AnchorSide[getAnchorKind(lua_tostring(L,2))].Side := getAnchorRef(lua_tostring(L,3));
  Result := 0;
end;

function ControlAnchorSideControl(L: Plua_State): Integer; cdecl;
var
  lC: TComponent;
begin
  CheckArg(L, 3);
  lC := TComponent(GetLuaObject(L, 1));
  TControl(lC).AnchorSide[getAnchorKind(lua_tostring(L,2))].Control := TControl(GetLuaObject(L, 3));
  Result := 0;
end;

// ***************************************************************

function ControlGlyph(L: Plua_State): Integer; cdecl;
var lBtn: TComponent;
    lImage: TLuaImage;
    bmp: TBitmap;
    PInfo: PPropInfo;
begin
  CheckArg(L, 2);
  lBtn := TComponent(GetLuaObject(L, 1));
  if lua_isnil(L,1) then
      LuaError(L, 'Cant handle NullObject in IMAGE');
  PInfo:= GetPropInfo(lBtn.ClassInfo, 'Glyph');
  if PInfo=nil then
     LuaError(L, 'Cant add Image to this Object: '+lBtn.ClassName);
  if lua_isnil(L,2) then begin
     SetInt64Prop(lBtn, PInfo, Int64(Pointer(nil)));
     // TSpeedButton(lBtn).Glyph := nil;
  end else begin
   lImage := TLuaImage(GetLuaObject(L, 2));
   bmp:=TBitmap.Create;
   try
     bmp.Width := lImage.Picture.Graphic.Width;
     bmp.Height := lImage.Picture.Graphic.Height;
     bmp.Canvas.Draw(0, 0, lImage.Picture.Graphic);
     // mask color hack
     bmp.TransparentColor := bmp.Canvas.Pixels[0,0];
     bmp.Transparent:=true;
     SetInt64Prop(lBtn, PInfo, Int64(Pointer(bmp)));
     // TSpeedButton(lBtn).Glyph:=bmp;
   finally
     bmp.Free;
   end;
  end;
  result := 0;
end;

// ***********************************************

function ComponentStringList(Comp: TComponent; name:String; value:String):boolean;
var sl:TStringList;
begin
     Result:=false;
     try
        sl := TStringList.Create;
        sl.SetText(pchar(value));
        SetInt64Prop(Comp, name, Int64(Pointer(sl)));
        Result := true;
     finally
        sl.Free;
     end;

end;

// ***********************************************
function ComponentShortCut(Comp: TComponent; scName:String): boolean;
begin
     try
        TMenuItem(Comp).ShortCut := TextToShortCut(scName);
        Result:=true;
     except
        Result:=false;
     end;
end;

// ***************************************************************

function DecodeHexString(s:String):TMemoryStream;
var
  i: Integer;
  B:Byte;
  OutStr: TMemoryStream;
begin
    OutStr := TMemoryStream.Create;
    i := 0;
    While i<Length(s) Do Begin
          B:=Byte(StrToIntDef('$'+Copy(s,i,2),0));
          Inc(i,2);
          OutStr.Write(B,1);
    End;
    OutStr.Seek(0, soFromBeginning);
    Result := OutStr;
end;

function ComponentBitmapString(Comp: TComponent; imageStr:String): boolean;
var
    img: TImage;
    str: TMemoryStream;
    PInfo: PPropInfo;
begin
  Result := False;
  PInfo:= GetPropInfo(Comp.ClassInfo, 'Glyph');
  if PInfo<>nil then begin
     try
            str := DecodeHexString(imageStr);
            img := TImage.Create(nil);
            try
               img.Picture.Bitmap.LoadFromStream(str);
            finally
            end;
            SetInt64Prop(Comp, PInfo, Int64(Pointer(img.Picture.Bitmap)));
            TControl(Comp).Repaint;
            str.Free;
            Result := true;
     finally
            img.Free;
     end;
  end else begin
      (*
      PInfo:= GetPropInfo(Comp.ClassInfo, 'PICTURE');
      if PInfo=nil then exit;
      try
            str := DecodeHexString(imageStr);
            TImage(Comp).Picture.LoadFromStreamWithFileExt(str,'BMP');
            str.Free;
            Result := true;
     finally
            img.Free;
     end;
     *)
  end;
end;

function ComponentGlyphFile(Comp: TComponent; imgName:String): boolean;
var
    img: TImage;
    ico: TIcon;
    PInfo: PPropInfo;
begin
  Result := False;
  try
     PInfo:= GetPropInfo(Comp.ClassInfo, 'Glyph');
     if PInfo=nil then begin
        if GetPropInfo(Comp.ClassInfo, 'Image') <> nil then begin
           TLuaImage(comp).Picture.LoadFromFile(imgName);
           Result := true;
        end else
        if GetPropInfo(Comp.ClassInfo, 'Icon') <> nil then begin
           ico := TIcon(GetInt64Prop(Comp,'Icon'));
           // must be an icon
           ico.LoadFromFile(imgName);
           Result := true;
        end;
     end else begin
         try
            img := TImage.Create(nil);
            img.Picture.LoadFromFile(imgName);
            SetInt64Prop(Comp, PInfo, Int64(Pointer(img.Picture.Bitmap)));
            Result := true;
         finally
            img.Free;
         end;
     end;
   finally
   end;
end;

function ComponentGlyphBuffer(Comp: TComponent; image:TImage): boolean;
var
    PInfo: PPropInfo;
begin
  Result := False;
  try
     PInfo:= GetPropInfo(Comp.ClassInfo, 'Glyph');
     if PInfo=nil then begin
        if GetPropInfo(Comp.ClassInfo, 'Image') <> nil then begin
           comp := image;
           image.Free;
           Result := true;
        end else
        if GetPropInfo(Comp.ClassInfo, 'Icon') <> nil then begin
           SetInt64Prop(Comp, PInfo, Int64(Pointer(image.Picture.Bitmap)));
           image.free;
           Result := true;
        end;
     end else begin
         SetInt64Prop(Comp, PInfo, Int64(Pointer(image.Picture.Bitmap)));
         image.Free;
         Result := true;
     end;
   finally
   end;
end;


// Not used
function ComponentImageListFile(Comp: TComponent; listName:String; imgNames:TStrings): boolean;
var
    n:Integer;
    Image: TImage;
    PInfo: PPropInfo;
    iList: TCustomImageList;
begin
  Result := False;
  iList := TCustomImageList.Create(Comp);
  try
     PInfo:= GetPropInfo(Comp.ClassInfo, ListName);
     if PInfo<>nil then begin
       for n:=0 to imgNames.count-1 do begin
         Image := TImage.Create(nil);
         try
            Image.Picture.LoadFromFile(imgNames[n]);
            iList.AddMasked( Image.Picture.Bitmap, clNone );
         finally
            Image.Free;
         end;
       end;
       SetInt64Prop(Comp, PInfo, Int64(Pointer(iList)));
     end;
     Result := True;
  finally
     iList.Free;
  end;
end;

// ***********************************************
function GetLuaState(Sender:TObject):Plua_State;
begin
     Result := TLuaControl(TComponent(Sender).Components[0]).L;
end;

constructor TLuaControl.Create(Owner:TComponent; LL: Plua_State; T:ToTableProc);
begin
     inherited Create(Owner);
     L := LL;
     ToTable := T;
end;

// ***********************************************
// LUA Events
// ***********************************************
function CheckEvent(L:Plua_State; Sender: TObject; EFn:String):Boolean;
var n,i,p:integer;
    s:String;
begin
    Result := False;
    if L=nil then begin
        ShowMessage('Sender has no lua_State: '+Sender.Classname);
        exit;
    end;
    if (EFn = '') then begin
       LuaError(L,'Event name not set in '+Sender.ClassName);
    end;
    lua_getglobal(L, pchar(EFn));
    if lua_isnil(L,-1) then begin
      lua_pop(L,1);
      p:=length(Efn);
      for i:=length(Efn) downto 1 do begin
          if Efn[i]='.' then begin
             p := i;
             break;
          end;
      end;
      s := copy(Efn,p+1,length(Efn));
      Efn := copy(Efn,1,p-1);
      lua_getglobal(L, pchar(EFn));
      lua_getfield(L, -1, pchar(s));
      if lua_isnil(L,-1) then
         LuaError(L,'Event not found in module '+EFn);
      // unix!
	  // lua_remove(L,2);
    end;
    Result := True;
end;

procedure TLuaControl.NotifyEventHandler(Sender: TObject; EventFunc:String);
var
  LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
      ToTable(LL, -1, Sender);
      DoCall(LL,1);
    end
end;

procedure TLuaControl.KeyEventHandler(Sender: TObject; EventFunc:String; var Key: Word; Shift: TShiftState);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushnumber(LL,Word(Key));
    lua_pushstring(LL,pchar(ShiftStateToString(Shift)));
    DoCall(LL,3);
    if lua_isnumber(LL,-1) then
       Key := Word(Round(lua_tonumber(LL,-1)));
    end
end;

procedure TLuaControl.MouseEventHandler(Sender: TObject; EventFunc:String; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushstring(LL,pchar(GetEnumName(TypeInfo(TMouseButton),Integer(Button))));
    lua_pushstring(LL,pchar(ShiftStateToString(Shift)));
    lua_pushnumber(LL,X);
    lua_pushnumber(LL,Y);
    DoCall(LL,5);
    end;
end;

procedure TLuaControl.MouseMoveEventHandler(Sender: TObject; EventFunc:String; Shift: TShiftState; X, Y: Integer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushstring(LL,pchar(ShiftStateToString(Shift)));
    lua_pushnumber(LL,X);
    lua_pushnumber(LL,Y);
    DoCall(LL,4);
    end;
end;

procedure TLuaControl.MouseWheelEventHandler(Sender: TObject; EventFunc:String; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushstring(LL,pchar(ShiftStateToString(Shift)));
    lua_pushnumber(LL,WheelDelta);

    lua_newtable(LL);
    lua_pushliteral(LL,'X');
    lua_pushnumber(LL,MousePos.X);
    lua_rawset(LL,-3);
    lua_pushliteral(LL,'X');
    lua_pushnumber(LL,MousePos.Y);
    lua_rawset(LL,-3);
    lua_pushnumber(LL,2);
    lua_pushliteral(LL,'n');
    lua_rawset(LL,-3);

    lua_pushboolean(LL,Handled);

    DoCall(LL,5);
    if lua_isboolean(LL,-1) then
       Handled := lua_toboolean(LL,-1);
    end;
end;

procedure TLuaControl.MouseWheelUpDownEventHandler(Sender: TObject; EventFunc:String; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushstring(LL,pchar(ShiftStateToString(Shift)));

    lua_newtable(LL);
    lua_pushliteral(LL,'X');
    lua_pushnumber(LL,MousePos.X);
    lua_rawset(LL,-3);
    lua_pushliteral(LL,'X');
    lua_pushnumber(LL,MousePos.Y);
    lua_rawset(LL,-3);
    lua_pushnumber(LL,2);
    lua_pushliteral(LL,'n');
    lua_rawset(LL,-3);

    lua_pushboolean(LL,Handled);

    DoCall(LL,4);
    if lua_isboolean(LL,-1) then
       Handled := lua_toboolean(LL,-1);
    end;
end;


// Extended Edit

procedure TLuaControl.AcceptDirectoryHandler(Sender: TObject; EventFunc:String; var Value: String);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushstring(LL,pchar(Value));
    DoCall(LL,2);
    if lua_isstring(LL,-1) then
       Value := lua_tostring(LL,-1);
    end;
end;

procedure TLuaControl.AcceptFileNameHandler(Sender: TObject; EventFunc:String; var Value: String);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushstring(LL,pchar(Value));
    DoCall(LL,2);
    if lua_isstring(LL,-1) then
       Value := lua_tostring(LL,-1);
    end;
end;

procedure TLuaControl.AcceptValueHandler(Sender: TObject; EventFunc:String; var AValue: Double; var Action: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushnumber(LL,AValue);
    lua_pushboolean(LL,Action);
    DoCall(LL,2);
    if lua_isstring(LL,-1) then
       AValue := lua_tonumber(LL,-1)
    else if lua_isboolean(LL,-1) then
       Action := lua_toboolean(LL,-1);
    if lua_isstring(LL,-2) then
       AValue := lua_tonumber(LL,-2)
    else if lua_isboolean(LL,-2) then
       Action := lua_toboolean(LL,-2);
    end;
end;

procedure TLuaControl.AcceptDateHandler(Sender: TObject; EventFunc:String; var ADate: TDateTime; var AcceptDate: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushnumber(LL,ADate);
    lua_pushboolean(LL,AcceptDate);
    DoCall(LL,2);
    if lua_isstring(LL,-1) then
       ADate := lua_tonumber(LL,-1)
    else if lua_isboolean(LL,-1) then
       AcceptDate := lua_toboolean(LL,-1);
    if lua_isstring(LL,-2) then
       ADate := lua_tonumber(LL,-2)
    else if lua_isboolean(LL,-2) then
       AcceptDate := lua_toboolean(LL,-2);
    end;
end;

// Form related
procedure TLuaControl.CloseEventHandler(Sender: TObject; EventFunc:String; var Action: TCloseAction);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushstring(LL,pchar(GetEnumName(TypeInfo(TCloseAction),Integer(Action))));
    DoCall(LL,2);
    if lua_isstring(LL,-1) then
       Action := TCloseAction(GetEnumValue(TypeInfo(TCloseAction),lua_tostring(LL,-1)));
    end;
end;

procedure TLuaControl.CloseQueryEventHandler(Sender: TObject; EventFunc:String; var CanClose: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushboolean(LL,CanClose);
    DoCall(LL,2);
    if lua_isboolean(LL,-1) then
       CanClose := lua_toboolean(LL,-1);
    end;
end;

// StringGrid related

procedure TLuaControl.HeaderClickEventHandler(Sender: TObject; EventFunc:String; IsColumn: Boolean; Index:Integer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
       ToTable(LL, -1, Sender);
       lua_pushboolean(LL,IsColumn);
       lua_pushnumber(LL,Index);
       DoCall(LL,3);
    end;
end;

procedure TLuaControl.SelectCellEventHandler(Sender: TObject; EventFunc:String; ACol, ARow: Longint; var CanSelect: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushnumber(LL,ACol);
    lua_pushnumber(LL,ARow);
    lua_pushboolean(LL,CanSelect);
    DoCall(LL,4);

    if lua_isboolean(LL,-1) then
       CanSelect := lua_toboolean(LL,-1);
    end;
end;

function DrawGridStateToString(State:TGridDrawState):String;
begin
  Result := '';
  if State = [gdSelected] then Result := 'gdSelected'
  else if State = [gdFocused] then Result := 'gdFocused'
  else if State = [gdFixed] then Result := 'gdFixed';
end;

procedure TLuaControl.DrawCellEventHandler(Sender: TObject; EventFunc:String; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushnumber(LL,ACol);
    lua_pushnumber(LL,ARow);
    
    lua_newtable(LL);
    lua_pushliteral(LL,'Left');
    lua_pushnumber(LL,Rect.Left);    
    lua_rawset(LL,-3);
    lua_pushliteral(LL,'Top');
    lua_pushnumber(LL,Rect.Top);    
    lua_rawset(LL,-3);
    lua_pushliteral(LL,'Right');
    lua_pushnumber(LL,Rect.Right);    
    lua_rawset(LL,-3);
    lua_pushliteral(LL,'Bottom');
    lua_pushnumber(LL,Rect.Bottom);    
    lua_rawset(LL,-3);    
    lua_pushnumber(LL,4);
    lua_pushliteral(LL,'n');
    lua_rawset(LL,-3);
  	lua_pushstring(LL,pchar(DrawGridStateToString(State)));
    DoCall(LL,5);
    end;
end;

procedure TLuaControl.SetEditTextEventHandler(Sender: TObject; EventFunc:String; ACol, ARow: Longint; var Value: string);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushnumber(LL,ACol);
    lua_pushnumber(LL,ARow);
    lua_pushstring(LL,pchar(TStringGrid(Sender).Cells[ACol, ARow]));
    DoCall(LL,4);
  	if lua_isstring(LL,-1) then
//       Value := lua_tostring(LL,-1);
       TStringGrid(Sender).Cells[ACol, ARow] := lua_tostring(LL,-1);
    end;
end;

procedure TLuaControl.GetEditTextEventHandler(Sender: TObject; EventFunc:String; ACol, ARow: Longint; var Value: string);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushnumber(LL,ACol);
    lua_pushnumber(LL,ARow);
    lua_pushstring(LL,pchar(Value));
    DoCall(LL,4);
  	if lua_isstring(LL,-1) then
       Value := lua_tostring(LL,-1);
//       TStringGrid(Sender).Cells[ACol, ARow] := lua_tostring(LL,-1);
    end;
end;

procedure TLuaControl.RowColumnMovedEventHandler(Sender: TObject; EventFunc:String; FromIndex, ToIndex: Longint);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    lua_pushnumber(LL,FromIndex);
    lua_pushnumber(LL,ToIndex);
    DoCall(LL,3);
    end;
end;


// DragDrop Events
// TDragDropEvent = procedure(Sender, Source: TObject; X, Y: Integer) of object;
procedure TLuaControl.DragDropEventHandler(Sender: TObject; EventFunc:String; Source: TObject; X, Y: Integer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // Source here...
    ToTable(LL, -2, Source);
    lua_pushnumber(LL,trunc(X));
    lua_pushnumber(LL,trunc(Y));
    DoCall(LL,4);
    end;
end;

// TDragOverEvent = procedure(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean) of object;
procedure TLuaControl.DragOverEventHandler(Sender: TObject; EventFunc:String; Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // Source here...
    ToTable(LL, -2, Source);
    lua_pushnumber(LL,trunc(X));
    lua_pushnumber(LL,trunc(Y));
    lua_pushstring(LL,pchar(GetEnumName(TypeInfo(TDragState),Integer(State))));
    DoCall(LL,5);
    if lua_isboolean(LL,-1) then
       Accept := lua_toboolean(LL,-1);
    end;
end;

// type TStartDragEvent = procedure (Sender: TObject; var DragObject: TDragObject) of object; 
procedure TLuaControl.StartDragEventHandler(Sender: TObject; EventFunc:String; var DragObject: TDragObject);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // If the OnStartDrag event handler sets the DragObject parameter to nil (Delphi) or NULL (C++), a TDragControlObject object is automatically created and dragging begins on the control itself.
    DragObject := nil;
    DoCall(LL,1);
    end;
end;

// type TEndDragEvent = procedure(Sender, Target: TObject; X, Y: Integer) of object;
procedure TLuaControl.EndDragEventHandler(Sender: TObject; EventFunc:String; Target: TObject; X, Y: Integer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // Target here...
    ToTable(LL, -2, Target);
    lua_pushnumber(LL,trunc(X));
    lua_pushnumber(LL,trunc(Y));
    DoCall(LL,4);
    end;
end;


// Docking Events
procedure TLuaControl.DockDropEventHandler(Sender: TObject; EventFunc:String; Source: TDragDockObject; X, Y: Integer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // Source here...
    ToTable(LL, -2, Source.Control);
    lua_pushnumber(LL,trunc(X));
    lua_pushnumber(LL,trunc(Y));
    DoCall(LL,4);
    end;
end;

// TDockOverEvent = procedure(Sender, Source: TObject; X, Y: Integer; State: TDockState; var Accept: Boolean) of object;
procedure TLuaControl.DockOverEventHandler(Sender: TObject; EventFunc:String; Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // Source here...
    ToTable(LL, -2, Source.Control);
    lua_pushnumber(LL,trunc(X));
    lua_pushnumber(LL,trunc(Y));
    lua_pushstring(LL,pchar(GetEnumName(TypeInfo(TDragState),Integer(State))));
    DoCall(LL,5);
    if lua_isboolean(LL,-1) then
       Accept := lua_toboolean(LL,-1);
    end;
end;

// type TStartDockEvent = procedure (Sender: TObject; var DockObject: TDockObject) of object;
procedure TLuaControl.StartDockEventHandler(Sender: TObject; EventFunc:String; var DockObject: TDragDockObject);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // If the OnStartDock event handler sets the DockObject parameter to nil (Delphi) or NULL (C++), a TDockControlObject object is automatically created and Dockging begins on the control itself.
    DockObject := nil;
    DoCall(LL,1);
    end;
end;

// type TEndDockEvent = procedure(Sender, Target: TObject; X, Y: Integer) of object;
procedure TLuaControl.EndDockEventHandler(Sender: TObject; EventFunc:String; Target: TObject; X, Y: Integer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // Target here...
    ToTable(LL, -1, Target);
    lua_pushnumber(LL,trunc(X));
    lua_pushnumber(LL,trunc(Y));
    DoCall(LL,4);
    end;
end;

procedure TLuaControl.UnDockEventHandler(Sender: TObject; EventFunc:String; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
    ToTable(LL, -1, Sender);
    // Client and NewTarget here...
    ToTable(LL, -2, Client);
    ToTable(LL, -3, NewTarget);
    DoCall(LL,3);
    if lua_isboolean(LL,-1) then
       Allow := lua_toboolean(LL,-1);
    end;
end;

procedure TLuaControl.DropFilesEventHandler(Sender: TObject; EventFunc:String; const FileNames: array of String);
var LL:Plua_State;
    i:Integer;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
      ToTable(LL, -1, Sender);
      For i:=0 to Length(FileNames)-1 do begin
        if i=0 then lua_newtable(LL);
        lua_pushnumber(LL,i+1);
        lua_pushstring(LL,pchar(FileNames[i]));
        lua_rawset(LL,-3);
      end;
      DoCall(LL,2);
    end;
end;


procedure TLuaControl.ReplaceTextEventHandler(Sender: TObject; EventFunc:String; const ASearch,
  AReplace: string; Line, Column: integer; var ReplaceAction: TSynReplaceAction);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
      ToTable(LL, -1, Sender);
      lua_pushstring(LL,pchar(ASearch));
      lua_pushstring(LL,pchar(AReplace));
      lua_pushnumber(LL,Line);
      lua_pushnumber(LL,Column);
      lua_pushstring(LL,pchar(GetEnumName(TypeInfo(TSynReplaceAction),Integer(ReplaceAction))));
      DoCall(LL,6);
      if lua_isstring(LL,-1) then
         ReplaceAction := TSynReplaceAction(GetEnumValue(TypeInfo(TSynReplaceAction),lua_tostring(LL,-1)));
    end;
end;

procedure TLuaControl.CommandProcessedEventHandler(Sender: TObject; EventFunc:String;
  var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
      ToTable(LL, -1, Sender);
      lua_pushstring(LL,pchar(EditorCommandToCodeString(Command)));
      DoCall(LL,2);
    end;
end;

procedure TLuaControl.ClickLinkEventHandler(Sender: TObject; EventFunc:String; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
       ToTable(LL, -1, Sender);
       lua_pushstring(LL,pchar(GetEnumName(TypeInfo(TMouseButton),Integer(Button))));
       lua_pushstring(LL,pchar(ShiftStateToString(Shift)));
       lua_pushnumber(LL,X);
       lua_pushnumber(LL,Y);
       DoCall(LL,5);
    end;
end;

procedure TLuaControl.MouseLinkEventHandler(Sender: TObject; EventFunc:String; X, Y: Integer;
          var AllowMouseLink: Boolean);
var LL:Plua_State;
begin
    LL := GetLuaState(Sender);
    if CheckEvent(LL,Sender,EventFunc) then begin
       ToTable(LL, -1, Sender);
       lua_pushnumber(LL,X);
       lua_pushnumber(LL,Y);
       lua_pushboolean(LL,AllowMouseLink);
       DoCall(LL,3);
       if lua_isboolean(LL,-1) then
          AllowMouseLink := lua_toboolean(LL,-1);
    end;
end;


//LUA Event Catch
procedure TLuaControl.OnLuaChangeBounds(Sender: TObject);
  begin NotifyEventHandler(Sender, OnChangeBounds_Function);end;
procedure TLuaControl.OnLuaCreate(Sender: TObject);
  begin NotifyEventHandler(Sender, OnCreate_Function);end;
procedure TLuaControl.OnLuaClick(Sender: TObject);
  begin NotifyEventHandler(Sender,OnClick_Function);end;
procedure TLuaControl.OnLuaDblClick(Sender: TObject);
  begin NotifyEventHandler(Sender, OnDblClick_Function);end;
procedure TLuaControl.OnLuaDestroy(Sender: TObject);
  begin NotifyEventHandler(Sender, OnDestroy_Function);end;
procedure TLuaControl.OnLuaShow(Sender: TObject);
  begin NotifyEventHandler(Sender, OnShow_Function);end;
procedure TLuaControl.OnLuaHide(Sender: TObject);
  begin NotifyEventHandler(Sender, OnHide_Function);end;
procedure TLuaControl.OnLuaActivate(Sender: TObject);
  begin NotifyEventHandler(Sender, OnActivate_Function);end;
procedure TLuaControl.OnLuaDeactivate(Sender: TObject);
  begin NotifyEventHandler(Sender, OnDeactivate_Function);end;
procedure TLuaControl.OnLuaResize(Sender: TObject);
  begin NotifyEventHandler(Sender, OnResize_Function); end;
procedure TLuaControl.OnLuaPaint(Sender: TObject);
  begin NotifyEventHandler(Sender, OnPaint_Function);end;
procedure TLuaControl.OnLuaChange(Sender: TObject);
  begin NotifyEventHandler(Sender, OnChange_Function);end;


procedure TLuaControl.OnLuaClose(Sender: TObject; var Action: TCloseAction);
  begin CloseEventHandler(Sender, OnClose_Function, Action);end;
procedure TLuaControl.OnLuaCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin CloseQueryEventHandler(Sender, OnCloseQuery_Function, CanClose);end;
procedure TLuaControl.OnLuaWindowStateChange(Sender: TObject);
  begin NotifyEventHandler(Sender, OnWindowStateChange_Function);end;

procedure TLuaControl.OnLuaEnter(Sender: TObject);
  begin NotifyEventHandler(Sender, OnEnter_Function);end;
procedure TLuaControl.OnLuaExit(Sender: TObject);
  begin NotifyEventHandler(Sender, OnExit_Function);end;

procedure TLuaControl.OnLuaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin KeyEventHandler(Sender, OnKeyDown_Function, Key, Shift);end;
procedure TLuaControl.OnLuaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin KeyEventHandler(Sender, OnKeyUp_Function, Key, Shift);end;

procedure TLuaControl.OnLuaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin MouseEventHandler(Sender, OnMouseDown_Function, Button, Shift, X, Y);end;
procedure TLuaControl.OnLuaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin MouseEventHandler(Sender, OnMouseUp_Function, Button, Shift, X, Y);end;
procedure TLuaControl.OnLuaMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  begin MouseMoveEventHandler(Sender, OnMouseMove_Function, Shift, X, Y);end;
procedure TLuaControl.OnLuaMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  begin MouseWheelEventHandler(Sender, OnMouseWheel_Function, Shift, WheelDelta, MousePos, Handled);end;
procedure TLuaControl.OnLuaMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
  begin MouseWheelUpDownEventHandler(Sender, OnMouseWheelDown_Function, Shift, MousePos, Handled);end;
procedure TLuaControl.OnLuaMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
  begin MouseWheelUpDownEventHandler(Sender, OnMouseWheelUp_Function, Shift, MousePos, Handled);end;
procedure TLuaControl.OnLuaMouseEnter(Sender: TObject);
  begin NotifyEventHandler(Sender, OnMouseEnter_Function);end;
procedure TLuaControl.OnLuaMouseExit(Sender: TObject);
  begin NotifyEventHandler(Sender, OnMouseExit_Function);end; 

//PageControl
procedure TLuaControl.OnLuaPageChanged(Sender: TObject);
  begin NotifyEventHandler(Sender, OnPageChanged_Function);end;
// Action
procedure TLuaControl.OnLuaExecute(Sender: TObject);
  begin NotifyEventHandler(Sender, OnExecute_Function);end;
procedure TLuaControl.OnLuaUpdate(Sender: TObject);
  begin NotifyEventHandler(Sender, OnUpdate_Function);end;

// Timer
procedure TLuaControl.OnLuaTimer(Sender: TObject);
  begin NotifyEventHandler(Sender, OnTimer_Function);end; 
procedure TLuaControl.OnLuaIdleTimer(Sender: TObject);
  begin NotifyEventHandler(Sender, OnIdleTimer_Function);end;

// Extended edit
procedure TLuaControl.OnAcceptDirectory(Sender: TObject; var Value: String);
  begin AcceptDirectoryHandler(Sender, OnAcceptDirectory_Function, Value); end;

procedure TLuaControl.OnAcceptFileName(Sender: TObject; var Value: String);
  begin AcceptFileNameHandler(Sender, OnAcceptFileName_Function, Value); end;

procedure TLuaControl.OnAcceptValue(Sender: TObject; var AValue: Double; var Action: Boolean);
begin AcceptValueHandler(Sender, OnAcceptValue_Function, AValue, Action) end;

procedure TLuaControl.OnAcceptDate(Sender: TObject; var ADate: TDateTime; var AcceptDate: Boolean);
begin AcceptDateHandler(Sender, OnAcceptDate_Function, ADate, AcceptDate) end;

procedure TLuaControl.OnLuaButtonClick(Sender: TObject);
  begin NotifyEventHandler(Sender,OnButtonClick_Function);end;

// StringGrid

procedure TLuaControl.OnLuaHeaderClick(Sender: TObject; IsColumn: Boolean; Index:Integer);
  begin HeaderClickEventHandler(Sender, OnHeaderClick_Function, IsColumn, Index);end;
procedure TLuaControl.OnLuaEditButtonClick(Sender: TObject);
  begin NotifyEventHandler(Sender,OnEditButtonClick_Function);end;
procedure TLuaControl.OnLuaSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
  begin SelectCellEventHandler(Sender, OnSelectCell_Function, ACol, ARow, CanSelect);end;
procedure TLuaControl.OnLuaDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
  begin DrawCellEventHandler(Sender, OnDrawCell_Function, ACol, ARow, Rect, State);end;
procedure TLuaControl.OnLuaGetEditText(Sender: TObject; ACol, ARow: Longint; var Value: string);
  begin GetEditTextEventHandler(Sender, OnGetEditText_Function, ACol, ARow, Value);end;
procedure TLuaControl.OnLuaGetEditMask(Sender: TObject; ACol, ARow: Longint; var Value: string);
  begin GetEditTextEventHandler(Sender, OnGetEditMask_Function, ACol, ARow, Value);end;
procedure TLuaControl.OnLuaSetEditText(Sender: TObject; ACol, ARow: Longint; var Value: string);
  begin SetEditTextEventHandler(Sender, OnSetEditText_Function, ACol, ARow, Value);end;
procedure TLuaControl.OnLuaColumnMoved(Sender: TObject; FromIndex, ToIndex: Longint);
  begin RowColumnMovedEventHandler(Sender, OnColumnMoved_Function, FromIndex, ToIndex);end;
procedure TLuaControl.OnLuaRowMoved(Sender: TObject; FromIndex, ToIndex: Longint);
  begin RowColumnMovedEventHandler(Sender, OnRowMoved_Function, FromIndex, ToIndex);end;
  
procedure TLuaControl.OnLuaTopLeftChanged(Sender: TObject);
  begin NotifyEventHandler(Sender, OnTopLeftChanged_Function);end;
  
// FileDrop
procedure TLuaControl.OnLuaDropFiles(Sender: TObject; const FileNames: array of String);
  begin DropFilesEventHandler(Sender, OnDropFiles_Function, FileNames); end;

// DragDrop
procedure TLuaControl.OnLuaDragDrop;
  begin DragDropEventHandler(Sender, OnDragDrop_Function, Source, X, Y); end;
procedure TLuaControl.OnLuaDragOver;
  begin DragOverEventHandler(Sender, OnDragOver_Function, Source, X, Y, State, Accept); end;

// Docking
procedure TLuaControl.OnLuaDockDrop;
  begin DockDropEventHandler(Sender, OnDockDrop_Function, Source, X, Y); end;
procedure TLuaControl.OnLuaDockOver;
  begin DockOverEventHandler(Sender, OnDockOver_Function, Source, X, Y, State, Accept); end;
procedure TLuaControl.OnLuaUnDock;
  begin UnDockEventHandler(Sender, OnUnDock_Function, Client, NewTarget, Allow); end;
procedure TLuaControl.OnLuaStartDock;
  begin StartDockEventHandler(Sender, OnStartDock_Function, DockObject); end;
procedure TLuaControl.OnLuaEndDock;
  begin EndDockEventHandler(Sender, OnEndDock_Function, Target, X, Y); end;

// FindDialog
procedure TLuaControl.OnLuaFind(Sender: TObject);
  begin NotifyEventHandler(Sender, OnFind_Function);end;
procedure TLuaControl.OnLuaReplace(Sender: TObject);
  begin NotifyEventHandler(Sender, OnReplace_Function);end;

// SynEdit
procedure TLuaControl.OnLuaReplaceText(Sender: TObject; const ASearch,AReplace: string; Line, Column: integer; var ReplaceAction: TSynReplaceAction);
begin ReplaceTextEventHandler(Sender, OnReplaceText_Function, ASearch, AReplace, Line, Column, ReplaceAction); end;
procedure TLuaControl.OnLuaCommandProcessed(Sender: TObject; var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
begin CommandProcessedEventHandler(Sender, OnCommandProcessed_Function, Command, AChar, Data); end;
procedure TLuaControl.OnLuaClickLink(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin ClickLinkEventHandler(Sender, OnClickLink_Function, Button, Shift, X, Y); end;
procedure TLuaControl.OnLuaMouseLink(Sender: TObject; X, Y: Integer; var AllowMouseLink: Boolean);
begin MouseLinkEventHandler(Sender, OnMouseLink_Function, X, Y, AllowMouseLink); end;

end.
