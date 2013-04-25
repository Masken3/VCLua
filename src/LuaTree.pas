unit LuaTree;

interface

Uses LuaPas,LuaControl,ComCtrls,Controls,Classes,Types;

function CreateTree(L: Plua_State): Integer; cdecl;

type
    TLuaTree = class(TTreeView)
       LuaCtl: TLuaControl;
    end;


// forward
function LoadTreeFromLuaTable(L: Plua_State; PN:TLuaTree; TI:TTreeNode):Boolean;

implementation

Uses Forms, SysUtils, Lua, LuaImageList, LuaProperties;

// **************************************************************

function ClearTree(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
begin
  CheckArg(L, 1);
  lTree := TLuaTree(GetLuaObject(L, 1));
  if lTree <> nil then
    lTree.Items.Clear;
  Result := 0;
end;

function AddToTree(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN:TTreeNode;
  n: Integer;
begin
  n := lua_gettop(L);
  if n >= 3 then begin
    lTree := TLuaTree(GetLuaObject(L, 1));
    if (lua_isnil(L,2)) or (lua_tonumber(L,2)=0) then begin
      TN := nil;
      TN := lTree.Items.Add(nil,lua_tostring(L,3));
      TN.ImageIndex := -1;
      TN.SelectedIndex := -1;
    end else begin
      TN := lTree.Items[trunc(lua_tonumber(L,2))-1];
      TN := lTree.Items.AddChild(TN,lua_tostring(L,3));
      TN.ImageIndex := -1;
      TN.SelectedIndex := -1;
    end;
    if n > 3 then
        TN.Data := lua_touserdata(L,4);
    if n > 4 then begin
      TN.ImageIndex := trunc(lua_tonumber(L,5)-1);
      TN.SelectedIndex := TN.ImageIndex;
    end;
    if n > 5 then
      TN.SelectedIndex := trunc(lua_tonumber(L,6)-1);

    lua_pushnumber(L,TN.AbsoluteIndex+1);
  end
  else CheckArg(L, 3);
  Result := 1;
end;

function DeleteFromTree(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN:TTreeNode;
begin
  CheckArg(L, 2);
  lTree := TLuaTree(GetLuaObject(L, 1));
  TN := lTree.Items[trunc(lua_tonumber(L,2))-1];
  if TN <> nil then
    TN.Delete;
  Result := 0;
end;

function GetSelected(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
begin
  CheckArg(L, 1);
  lTree := TLuaTree(GetLuaObject(L, 1));
  if (lTree <> nil) and (lTree.Selected <> nil) then
    lua_pushnumber(L,lTree.Selected.AbsoluteIndex+1)
  else
    lua_pushnil(L);
  Result := 1;
end;

function GetItems(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN: TTreeNode;
//  i:Integer;

procedure nodetotable(TTN:TTreeNode);
// var ii:Integer;
begin
    lua_pushnumber(L,TTN.AbsoluteIndex+1);
    lua_newtable(L);
      lua_pushliteral(L, 'text');
      lua_pushstring(L, PChar(TTN.Text));
      lua_rawset(L,-3);
      lua_pushliteral(L, 'data');
      lua_pushlightuserdata(L, TTN.Data);
      lua_rawset(L,-3);
//      ii := 0;
      if TTN.HasChildren then begin
        TTN := TTN.getFirstChild;
        repeat
          nodetotable(TTN);
//          inc(ii);
          TTN := TTN.GetNextSibling;
        until TTN=nil;
      end;
    lua_rawset(L,-3);
end;

begin
  CheckArg(L, 1);
  lTree := TLuaTree(GetLuaObject(L, 1));
  if (lTree=nil) or (lTree.Items[0]=nil) then
    lua_pushnil(L)
  else begin
    lua_newtable(L);
    TN := lTree.Items.GetFirstNode;
    nodetotable(TN);
//    i := 0;
    repeat
      nodetotable(TN);
//      inc(i);
      TN := TN.GetNextSibling;
    until TN=nil;
  end;
  Result := 1;
end;

function GetItemValue(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN: TTreeNode;
begin
  CheckArg(L, 2);
  lTree := TLuaTree(GetLuaObject(L, 1));
  TN := lTree.Items[trunc(lua_tonumber(L,2))-1];
  lua_pushstring(L,PChar(TN.Text));
  Result := 1;
end;

function SetItemValue(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN: TTreeNode;
begin
  CheckArg(L, 3);
  lTree := TLuaTree(GetLuaObject(L, 1));
  TN := lTree.Items[trunc(lua_tonumber(L,2))-1];
  TN.Text := lua_tostring(L,3);
  Result := 0;
end;

function LoadTreeFromLuaTable(L: Plua_State; PN:TLuaTree; TI:TTreeNode):Boolean;
var m: Integer;
    key,val:String;
    P:Pointer;
    NewTI:TTreeNode; 
begin
  result := false;
  if lua_istable(L,-1) then begin
     m := lua_gettop(L);
     result := true;
     lua_pushnil(L);
     while (lua_next(L, m) <> 0) do begin
         if lua_istable(L,-1) and lua_isnumber(L,-2) then begin
            if TI = nil then begin
               TI := PN.Items.AddChild(nil,'');
               TI.ImageIndex := -1;
               TI.SelectedIndex := -1;
            end;
            newTI := PN.Items.AddChild(TI,'');
            LoadTreeFromLuaTable(L,PN,newTI);
         end else begin
            if TI = nil then begin
               TI := PN.Items.AddChild(TI,'');
               TI.ImageIndex := -1;
               TI.SelectedIndex := -1;
            end;
            key := lua_tostring(L, -2);
            val := lua_tostring(L, -1);
            if uppercase(key) = 'DATA' then  begin
              TI.Data := lua_topointer(L,-1);
            end
            else if uppercase(key) = 'TEXT' then begin
              TI.Text := lua_tostring(L, -1);
            end
            else if uppercase(key) = 'IMAGE' then begin
              TI.ImageIndex := trunc(lua_tonumber(L, -1)-1);
              if TI.SelectedIndex = -1 then
                TI.SelectedIndex := TI.ImageIndex;
            end
            else if uppercase(key) = 'SELECTED' then begin
              TI.SelectedIndex := trunc(lua_tonumber(L, -1)-1);
            end
         end;
         lua_pop(L, 1);
     end;
  end;
end;

function SetItems(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TI:TTreeNode;  
  n:Integer;
begin
  CheckArg(L, 2);
  lTree := TLuaTree(GetLuaObject(L, 1));
  n := lua_gettop(L);
  if lua_istable(L,2) then begin
     lua_pushnil(L);
     while (lua_next(L, n) <> 0) do begin
        LoadTreeFromLuaTable(L,lTree,nil);
        lua_pop(L, 1);
     end;
  end;
  result := 0;
end;

function GetItemData(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN: TTreeNode;
begin
  CheckArg(L, 2);
  lTree := TLuaTree(GetLuaObject(L, 1));
  TN := lTree.Items[trunc(lua_tonumber(L,2))-1];
  lua_pushlightuserdata(L,TN.Data);
  Result := 1;
end;

function SetItemData(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN: TTreeNode;
  P:Pointer;
begin
  CheckArg(L, 3);
  lTree := TLuaTree(GetLuaObject(L, 1));
  TN := lTree.Items[trunc(lua_tonumber(L,2))-1];
  TN.Data := lua_topointer(L,3);
  Result := 0;
end;

function SetTreeImages(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TI:TLuaImageList;
begin
  CheckArg(L, 2);
  lTree := TLuaTree(GetLuaObject(L, 1));
  TI := TLuaImageList(GetLuaObject(L, 2));
  lTree.Images := TI;
  Result := 0;
end;

function SetNodeImage(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN: TTreeNode;
  P:Pointer;
begin
  CheckArg(L, 3);
  lTree := TLuaTree(GetLuaObject(L, 1));
  TN := lTree.Items[trunc(lua_tonumber(L,2))-1];
  TN.ImageIndex := trunc(lua_tonumber(L,3)-1);
  Result := 0;
end;

function SetNodeSelectedImage(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  TN: TTreeNode;
  P:Pointer;
begin
  CheckArg(L, 3);
  lTree := TLuaTree(GetLuaObject(L, 1));
  TN := lTree.Items[trunc(lua_tonumber(L,2))-1];
  TN.SelectedIndex := trunc(lua_tonumber(L,3)-1);
  Result := 0;
end;

function TreeSaveToFile(L: Plua_State): Integer; cdecl;
var
  lT:TLuaTree;
  fn:String;
begin
  CheckArg(L,2);
  lT := TLuaTree(GetLuaObject(L, 1));
  lT.SaveToFile(lua_tostring(L,2));
  Result := 0;
end;

function TreeLoadFromFile(L: Plua_State): Integer; cdecl;
var
  lT:TLuaTree;
  fn:String;
begin
  CheckArg(L,2);
  lT := TLuaTree(GetLuaObject(L, 1));
  lT.LoadFromFile(lua_tostring(L,2));
  Result := 0;
end;

procedure ToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L, Index, Sender);
  SetAnchorMethods(L,Index,Sender);
  
  LuaSetTableFunction(L, Index, 'Selected', GetSelected);
  LuaSetTableFunction(L, Index, 'Get', GetItemValue);
  LuaSetTableFunction(L, Index, 'Set', SetItemValue);
  LuaSetTableFunction(L, Index, 'ToTable', GetItems);
  LuaSetTableFunction(L, Index, 'LoadFromTable', SetItems);

  LuaSetTableFunction(L, Index, 'GetData', GetItemData);
  LuaSetTableFunction(L, Index, 'SetData', SetItemData);

  LuaSetTableFunction(L, Index, 'Clear', ClearTree);

  LuaSetTableFunction(L, Index, 'Add', AddToTree);
  LuaSetTableFunction(L, Index, 'Delete', DeleteFromTree);

  LuaSetTableFunction(L, Index, 'Images', SetTreeImages);
  LuaSetTableFunction(L, Index, 'SetImage', SetNodeImage);  
  LuaSetTableFunction(L, Index, 'SetSelectedImage', SetNodeSelectedImage);

  LuaSetTableFunction(L, Index, 'SaveToFile',@TreeSaveToFile);
  LuaSetTableFunction(L, Index, 'LoadFromFile',@TreeLoadFromFile);

  LuaSetMetaFunction(L, index, '__index', @LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', @LuaSetProperty);
end;

function CreateTree(L: Plua_State): Integer; cdecl;
var
  lTree:TLuaTree;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  lTree := TLuaTree.Create(Parent);
  lTree.Parent := TWinControl(Parent);
  lTree.LuaCtl := TLuaControl.Create(lTree,L,@ToTable);
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(lTree),-1)
  else 
     lTree.Name := Name;
  ToTable(L, -1, lTree);
  Result := 1;
end;

end.
