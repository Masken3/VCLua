SourceCodeDir = "genericsrc/"
UsesInclude = "genuses.inc"
LibInclude = "genlibs.inc"
LibCount = "genlibcount.inc"
GenericComponentCount = 0
CToken = "#CMPNT#"
PToken = "#PN#"
SToken = "#SL#"
GToken = "#GL#"
AToken = "#AS#"

GenericComponents = {
    "Bevel",
	"Button",
	"CheckBox",
	"Edit",
	"CalcEdit",
    "DirectoryEdit",
    "FileNameEdit",
	"GroupBox",
	"Label",
	"PageControl",	
	"Panel",
	"RadioButton",
	"RadioGroup",
	"SpinEdit",
	"FloatSpinEdit",
	"Shape",
	"Splitter",
	"ScrollBox",
	"TabSheet",
	"ToggleBox",
	"TrackBar"
}

GenericComponents_PN = {
	"Timer",
	"IdleTimer",
}

GenericComponents_SL = {
	"ComboBox",
	"ListBox",	
	"CheckListBox",
	"Memo"
}

GenericComponents_GL = {
	"SpeedButton",
	"BitBtn"
}


ComponentTemplate = [[
unit Lua#CMPNT#;	
interface
Uses Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, EditBtn, Buttons, Forms, Spin, ActnList, CheckLst, TypInfo, LuaPas, LuaControl;
function Create#CMPNT#(L: Plua_State): Integer; cdecl;
type
    TLua#CMPNT# = class(T#CMPNT#)
        LuaCtl: TLuaControl;
    end;
implementation
Uses LuaProperties, Lua;
procedure #CMPNT#ToTable(L:Plua_State; Index:Integer; Sender:TObject);
begin
  SetDefaultMethods(L,Index,Sender);
  #AS#
  #SL#
  #GL#
  LuaSetMetaFunction(L, index, '__index', LuaGetProperty);
  LuaSetMetaFunction(L, index, '__newindex', LuaSetProperty);
end;
function Create#CMPNT#(L: Plua_State): Integer; cdecl;
var
  l#CMPNT#:TLua#CMPNT#;
  Parent:TComponent;
  Name:String;
begin
  GetControlParents(L,Parent,Name);
  l#CMPNT# := TLua#CMPNT#.Create(Parent);
  #PN#
  l#CMPNT#.LuaCtl := TLuaControl.Create(l#CMPNT#,L,@#CMPNT#ToTable);
  l#CMPNT#.LuaCtl.ComponentIndex:=0;
  if (lua_gettop(L)>0) and (GetLuaObject(L, -1) = nil) then
     SetPropertiesFromLuaTable(L, TObject(l#CMPNT#),-1)
  else
     l#CMPNT#.Name := Name;
  #CMPNT#ToTable(L, -1, l#CMPNT#);
  Result := 1;
end;
end.
]]

-- //////////////////////////////////////////////////
function SaveFile(filename, rbuf)
  if rbuf==nil then return false end
  local f = io.open(filename, "w+b")
  if f==nil then return false end
  f:write(rbuf)
  f:flush()
  f:close()
  return true
end
-- ///////////////////////////////////////////////////

s = ""
l = ""

-- Standard
for i,v in ipairs(GenericComponents) do
	s = s.."Lua"..v.." in '"..SourceCodeDir.."Lua"..v..".pas',\n"
	c = i
	l = l.."(name:'"..v.."'; func:@Create"..v.."),\n"
	local p = string.gsub(ComponentTemplate,PToken,"l#CMPNT#.Parent := TWinControl(Parent);")
	p = string.gsub(p,CToken,v)
	p = string.gsub(p,SToken,"")
	p = string.gsub(p,GToken,"")
	p = string.gsub(p,AToken,"SetAnchorMethods(L,Index,Sender);"); 
	SaveFile(SourceCodeDir.."Lua"..v..".pas",p)
end

-- NonVisual
for i,v in ipairs(GenericComponents_PN) do
	s = s.."Lua"..v.." in '"..SourceCodeDir.."Lua"..v..".pas',\n"
	c2 = i
	l = l.."(name:'"..v.."'; func:@Create"..v.."),\n"
	local p = string.gsub(ComponentTemplate,PToken,"")
	p = string.gsub(p,CToken,v)
	p = string.gsub(p,SToken,"")
	p = string.gsub(p,GToken,"")
	p = string.gsub(p,AToken,""); 
	SaveFile(SourceCodeDir.."Lua"..v..".pas",p)
end

-- StringList based
for i,v in ipairs(GenericComponents_SL) do
	s = s.."Lua"..v.." in '"..SourceCodeDir.."Lua"..v..".pas',\n"
	c3 = i
	l = l.."(name:'"..v.."'; func:@Create"..v.."),\n"
	local p = string.gsub(ComponentTemplate,PToken,"l#CMPNT#.Parent := TWinControl(Parent);")
	p = string.gsub(p,CToken,v)
	p = string.gsub(p,SToken,"SetStringListMethods(L,Index,Sender);")
	p = string.gsub(p,GToken,"")
	p = string.gsub(p,AToken,"SetAnchorMethods(L,Index,Sender);"); 
	SaveFile(SourceCodeDir.."Lua"..v..".pas",p)
end

-- Glyph buttons 
for i,v in ipairs(GenericComponents_GL) do
	s = s.."Lua"..v.." in '"..SourceCodeDir.."Lua"..v..".pas',\n"
	c4 = i
	l = l.."(name:'"..v.."'; func:@Create"..v.."),\n"
	local p = string.gsub(ComponentTemplate,PToken,"l#CMPNT#.Parent := TWinControl(Parent);")
	p = string.gsub(p,CToken,v)
	p = string.gsub(p,SToken,"")
	p = string.gsub(p,GToken,"LuaSetTableFunction(L, Index, 'Image', ControlGlyph);")
	p = string.gsub(p,AToken,"SetAnchorMethods(L,Index,Sender);"); 
	SaveFile(SourceCodeDir.."Lua"..v..".pas",p)
end

SaveFile(SourceCodeDir..UsesInclude,s)
SaveFile(SourceCodeDir..LibCount,c+c2+c3+c4)
SaveFile(SourceCodeDir..LibInclude,l)
