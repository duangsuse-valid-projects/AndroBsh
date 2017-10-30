-- aBsh button triggered function

-- require utils for helper function
require "utils"

require "import"
import "android.widget.*"
import "android.view.*"

-- return var ident
RET="ret"
-- none message
NONE="(none)"

-- btn_lua
function doLuaEval()
  local text=getScript()
  luaDoString(lua, text)
  local o=luaGetObject(lua, RET)
  result=tostring(o)
  result_class=type(o)
end

-- btn_lua longclick
function doLuaEvalWithFn()
  local text=getScript()
  local o=luaScript(lua, text, "")
  result=tostring(o)
  result_class=type(o)
end

-- btn_java
function doBshEval()
  local text=getScript()
  local o=bshEval(bsh, text)
  result_class=type(o)
  result=luajava.tostring(o)
end

-- btn_result
function showResult()
  AlertDialog.Builder(activity)
    .setTitle(result_class or NONE)
    .setMessage(result or NONE)
    .show()
end

-- btn_exit
function exit()
  activity.finish()
end

-- btn_get
function get_obj()
  local text=getScript()
  o=bshGetObj(bsh, text)
  result_class=type(o)
  result=luajava.tostring(o)
end

-- btn_set
function set_obj()
  local text=getScript()
  local t=EditText(activity)
  t.setHint("٩(๑ᵒ̴̶̷͈᷄ᗨᵒ̴̶̷͈᷅)و 长按保存变量名")
  local a=AlertDialog.Builder(activity)
    .setView(t)
    .show()
  t.onLongClick=function()
    bshSetObj(bsh, t.Text, text)
    a.dismiss()
  end
end

-- btn_strict
function strict()
  print(not toggleStrict(bsh))
end

-- btn_source
function source()
  local text=getScript()
  luaSource(lua, "/data/data/org.duangsuse.alua.beanshell/files/lua"..text..".lua")
  o=bshSource(bsh, text)
  result=luajava.tostring(o)
  result_class=type(o)
end

-- btn_mod
function mod()
  local text=getScript()
  if text=="CTX" then bshSetObj(bsh, CTX, activity.getContext()) else
    bshLoadLib(text)
  end
end

function putsBshVersion()
  print(bshVersion(bsh))
end

function togdebug()
  print(not toggleDebug(bsh))
end

function redirout()
  local text=getScript()
  bshredir(bsh, text)
end