unit LuaVCLDoc;

interface

Uses Classes, Contnrs, TypInfo, LuaPas;

procedure makeDoc;
procedure ListProperties(PObj: TObject);

implementation

Uses Forms,Buttons,StdCtrls,ExtCtrls,ComCtrls,Menus,Grids;

function info(p:string):String;
begin
	if p = 'Align' then Result := '(alNone, alTop, alBottom, alLeft, alRight, alClient, alCustom)' else
	if p = 'Anchors' then Result := '(akTop, akLeft, akRight, akBottom)' else
	if p = 'BiDiMode' then Result := '(bdLeftToRight, bdRightToLeft, bdRightToLeftNoAlign, bdRightToLeftReadingOnly)' else
	if p = 'BorderIcons' then Result := '{ biSystemMenu, biMinimize, biMaximize, biHelp }' else
	if (p = 'BorderStyle') or (p = 'FormBorderStyle') then Result := '(bsNone, bsSingle, bsSizeable, bsDialog, bsToolWindow, bsSizeToolWin)' else
        if p = 'DefaultMonitor' then Result := '( dmDesktop, dmPrimary, dmMainForm, dmActiveForm )' else
        if p = 'DragKind' then Result := '(dkDrag, dkDock)' else
        if p = 'DragMode' then Result := '(dmManual , dmAutomatic)' else
        if p = 'ShowInTaskBar' then Result := '(stDefault, stAlways, stNever)' else
        if (p = 'Color') or (p='GraphicsColor') then Result := '(clXXXX)' else
	if p = 'Cursor' then Result := '(crDefault, crNone, crArrow, crCross, crIBeam, crSizeNESW, crSizeNS,'
          +'crSizeNWSE, crSizeWE, crUpArrow, crHourGlass, crDrag, crNoDrop,'
          +'crHSplit, crVSplit, crMultiDrag, crSQLWait, crNo, crAppStart, crHelp,'
    		  +'crHandPoint, crSize, crSizeAll)' else
	if p = 'FormStyle' then Result := '(fsNormal, fsMDIChild, fsMDIForm, fsStayOnTop)' else
	if p = 'HelpType' then Result := '(htKeyword, htContext)' else
	if p = 'ModalResult' then Result := '(mrNone, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore,'
		     +'mrYes, mrNo, mrAll, mrNoToAll, mrYesToAll)' else
	if p = 'Position' then Result := '(poDesigned, poDefault, poDefaultPosOnly, poDefaultSizeOnly, poScreenCenter, poDesktopCenter, poMainFormCenter, poOwnerFormCenter)' else
	if p = 'PrintScale' then Result := '(poNone, poProportional, poPrintToFit)' else
        if p = 'ResizeStyle' then Result := '(rsNone, rsLine, rsUpdate, rsPattern)' else
	if p = 'WindowState' then Result := '(wsNormal, wsMinimized, wsMaximized)' else
        if p = 'BalloonHintIcon' then Result := '(bitNone, bitInfo, bitWarning, bitError, bitCustom)' else
	
	Result := '&nbsp;';

end;

procedure ListProperties(PObj: TObject);
var
  PropInfos: PPropList;
  Count, Loop: Integer;
  PInfo: PPropInfo;
  PropType: String;
  FS:TStringList;
  FN:String;
begin
  FS := TStringList.Create;
  Count := GetPropList(PObj.ClassInfo, tkAny, nil);
  GetMem(PropInfos, Count * SizeOf(PPropInfo));
  GetPropList(PObj.ClassInfo, tkAny, PropInfos);
  FN := PObj.ClassName;
  delete(FN,1,1);
  FS.Add('<html><head></head>');
  FS.Add('<title>'+FN+ '</title>');
  FS.Add('<body>');
  FS.Add('<b>'+FN+'</b><BR>');
  FS.Add('<table border=1><tr height=17><td width=200><b>Property</b></td><td width=200><b>Type</b></td><td width=400><b>Description</b></td></tr>');
  for Loop := 0 to Count - 1 do begin
      PInfo := GetPropInfo(PObj.ClassInfo, PropInfos^[Loop]^.Name);
      PropType := PInfo^.Proptype^.Name;
      if PropType[1] = 'T' then
         delete(Proptype,1,1);
      if PropType<>'AnchorSide' then
      case PInfo^.Proptype^.Kind of
          tkSet,
          tkEnumeration,
          tkClass,
          tkInteger,
          tkChar,
          tkWChar,
          tkFloat,
          tkString,
          tkLString,
          tkWString,
          tkInt64
          :
          	begin
          	   FS.Add('<tr height=17>');
                   FS.Add('<td>'+PropInfos^[Loop]^.Name+'</td>');
                   FS.Add('<td>'+PropType+'</td>');
                   FS.Add('<td>'+Info(PropType)+'</td>');
                   FS.Add('</tr>');
            end
      end;
  end;

  (*
  FS.Add('</table><BR>');
  FS.Add('<table border=1><tr height=17><td width=200><b>Event</b></td><td width=200><b>Type</b></td><td width=400><b>Description</b></td></tr>');
  for Loop := 0 to Count - 1 do begin
      PInfo := GetPropInfo(PObj.ClassInfo, PropInfos^[Loop]^.Name);
  	  PropType := PInfo^.Proptype^.Name;
      if PropType[1] = 'T' then
         delete(Proptype,1,1);
      case PInfo^.Proptype^.Kind of
          tkMethod: begin
               FS.Add('<tr height=17>');
               FS.Add('<td>'+PropInfos^[Loop]^.Name+'</td>');
               FS.Add('<td>'+PropType+'</td>');
               FS.Add('<td>&nbsp;</td>');
               FS.Add('</tr>');
          end
      end;
  end;
  *)

  FreeMem(PropInfos);
  FS.Add('</table>');  
  FS.Add('</body>');
  FS.Add('</html>');  
  FS.SaveToFile('doc/'+FN+'.html');
  FS.Free;
end;

procedure MakeDoc;
var
  F:TForm;
  B:TButton;
  TBX:TToggleBox;
  SPB:TSpeedButton;
  E:TEdit;
  L:TLabel;
  P:TPanel;
  S:TSplitter;
  M:TMemo;
  CB:TCheckBox;
  LB:TListBox;
  COB:TComboBox;
  RB:TRadioButton;
  GB:TGroupBox;
  RG:TRadioGroup;
  MM:TMainMenu;
  PM:TPopupMenu;
  MI:TMenuItem;
  SB:TStatusBar;
  SG:TStringGrid;
  TW:TTreeView;
  PC:TPageControl;
  TS:TTabSheet;
  PB:TProgressBar;
  IM:TImage;
  TM: TTimer;
  TB: TTrackBar;
  BB: TBitBtn;
  BV: TBevel;
  CT: TTrayIcon;
begin
  (*
  F:=TForm.Create(nil);
  ListProperties(F);
  F.Free;
  *)

  B:=TButton.Create(nil);
  ListProperties(B);
  B.Free;

  SPB:=TSpeedButton.Create(nil);
  ListProperties(SPB);
  SPB.Free;

  TBX := TToggleBox.Create(nil);
  ListProperties(TBX);
  TBX.Free;

  (*
  E:=TEdit.Create(nil);
  ListProperties(E);
  E.Free;

  L:=TLabel.Create(nil);
  ListProperties(L);
  L.Free;

  P:=TPanel.Create(nil);
  ListProperties(P);
  P.Free;

  S:=TSplitter.Create(nil);
  ListProperties(S);
  S.Free;

  M:=TMemo.Create(nil);
  ListProperties(M);
  M.Free;

  CB:=TCheckBox.Create(nil);
  ListProperties(CB);
  CB.Free;

  LB:=TListBox.Create(nil);
  ListProperties(LB);
  LB.Free;

  COB:=TComboBox.Create(nil);
  ListProperties(COB);
  COB.Free;

  RB:=TRadioButton.Create(nil);
  ListProperties(RB);
  RB.Free;

  RG:=TRadioGroup.Create(nil);
  ListProperties(RG);
  RG.Free;

  GB:=TGroupBox.Create(nil);
  ListProperties(GB);
  GB.Free;

  MM:=TMainMenu.Create(nil);
  ListProperties(MM);
  MM.Free;

  PM:=TPopupMenu.Create(nil);
  ListProperties(PM);
  PM.Free;

  MI:=TMenuItem.Create(nil);
  ListProperties(MI);
  MI.Free;

  SB:=TStatusBar.Create(nil);
  ListProperties(SB);
  SB.Free;

  SG:=TStringGrid.Create(nil);
  ListProperties(SG);
  SG.Free;

  TW:=TTreeView.Create(nil);
  ListProperties(TW);
  TW.Free;

  PC:=TPageControl.Create(nil);
  ListProperties(PC);
  PC.Free;

  TS:=TTabSheet.Create(nil);
  ListProperties(TS);
  TS.Free;

  PB:=TProgressBar.Create(nil);
  ListProperties(PB);
  PB.Free;

  IM:=TImage.Create(nil);
  ListProperties(IM);
  IM.Free;

  TM:=TTimer.Create(nil);
  ListProperties(TM);
  TM.Free;

  TB:=TTrackBar.Create(nil);
  ListProperties(TB);
  TB.Free;

  BB:=TBitBtn.Create(nil);
  ListProperties(BB);
  BB.Free;

  BV:=TBevel.Create(nil);
  ListProperties(BV);
  BV.Free;

  CT:=TTrayIcon.Create(nil);
  ListProperties(CT);
  CT.Free;
  *)
end;

end.
