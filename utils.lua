-- lua&bsh aBsh utils

require "import"

-- pub lua libs
PUBLIC_LUA_FILES={}
-- main function ident
MAIN="main"
-- return ident
RETURN="RETURN"
-- context var ident
CTX="ctx"

-- initialize beanshell.support
function init_bsh()
  -- load beanshell corib for java evaluate
  compile "beanshell/bshcore.dex"

  -- import beanshell embedded api
  import "bsh.Interpreter"
  
  -- set a global bsh var
  bsh=Interpreter()
end

-- initialize luajava support
function init_luaj()
  -- import lua embedded api(alua built-in)
  import "com.luajava.LuaStateFactory"
  -- set a global lua var
  lua=LuaStateFactory.newLuaState()
end

-- initialize script engine
function init_ngin()
  init_bsh()
  init_luaj()
end

-- beanshell eval
function bshEval(sh, s)
  return sh.eval(s)
end

-- toggle strict java
function toggleStrict(sh)
  local old=sh.getStrictJava()
  sh.setStrictJava(not old)
  return old
end

-- toggle debug
function toggleDebug(sh)
  local old=sh.DEBUG
  sh.DEBUG=not old
  return old
end

-- get beanshell version
function bshVersion(sh)
  return sh.VERSION
end

-- load extra bsh libs
function bshLoadLib(name)
  compile("beanshell/bsh" .. name .. ".dex")
end

-- beanshell get object return object
function bshGetObj(sh, n)
  return sh.get(n)
end

-- beanshell set object
function bshSetObj(sh, n, val)
  sh.set(n, val)
end

-- beanshell source
function bshSource(sh, f)
  return sh.source(f)
end

-- redir output
function bshredir(bsh, f)
  bsh.redirectOutputToFile(f)
end

-- lua load stdlib
function luaStd(l)
  l.openLibs()
end

-- lua source
function luaSource(l, f)
  l.LdoFile(f)
end

-- lua open extra libs
function luaLoadLib(l)
  if not PUBLIC_LUA_FILES==nil then
    for f in PUBLIC_LUA_FILES do
      l.LdoFile(f)
    end
  end
end

-- lua eval
function luaDoString(l, s)
  l.LdoString(s)
end

-- lua get global
function luaGetGlobal(l, n)
  local ret=l.getGlobal(n)
  return ret
end

-- lua set global
function luaSetGlobal(l, n)
  local ret=l.setGlobal(n)
  return ret
end

-- lua get object
function luaGetObject(l, n)
  return l.getLuaObject(n)
end

-- lua do call
function luaDoCall(l, a, b)
  l.call(a, b)
end

-- lua pushstring
function luaPushString(l, s)
  l.pushString(s)
end

-- lua do script return string
function luaScript(l, s, a)
  luaStd(l)
  luaLoadLib(l)
  luaDoString(l, s)
  luaGetGlobal(l, MAIN)
  l.pushJavaObject(activity)
  luaPushString(l, a)
  luaDoCall(l, 2, 0) --nargs, nret
  local ret=luaGetObject(l, RETURN)
  return ret or ''
end