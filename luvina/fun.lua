local fun = require 'moses'

function fun.list(iter)
  local xs = {}
  for i, v in iter do
    xs[#xs+1] = v
  end
  return xs
end

function fun.split(str, sep)
  return fun.list(coroutine.wrap(function()
    if str == '' or sep == '' then
      coroutine.yield(1, str)
      return
    end
    local lasti = 1
    local n = 2
    for v,i in str:gmatch('(.-)'..sep..'()') do
      coroutine.yield(n, v)
      lasti = i
      n = n + 1
    end
    coroutine.yield(n, str:sub(lasti))
  end))
end

return fun
