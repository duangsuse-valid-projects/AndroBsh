--[[ author: duangsuse
-- license: gplv3
-- a tool designed for evaluate java(bsh)
-- and lua scripts(using built-in support)
--]]

-- require events for button events
require "events"
-- require utils for interpreter support
require "utils"

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"

-- initialize ui
activity.setTitle('AndroBean')
activity.setContentView(loadlayout(layout))

-- initialize script engine
init_ngin()

-- binds a view's onClick event to a function
function bindOnClick(t, f)
  t.onClick=f
end

function getScript()
  return script.Text
end

-- bind events
local buttons={btn_lua, btn_java, btn_result, btn_exit, btn_get, btn_set, btn_source, btn_mod, btn_strict}
local events={doLuaEval, doBshEval, showResult, exit, get_obj, set_obj, source, mod, strict}
for i, b in ipairs(buttons) do
  bindOnClick(b, events[i])
end

btn_lua.onLongClick=doLuaEvalWithFn
btn_java.onLongClick=putsBshVersion
btn_strict.onLongClick=togdebug
btn_source.onLongClick=redirout