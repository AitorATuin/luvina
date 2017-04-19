------------
-- luvina
-- lua tools to be used with vim
-- module: luvina
-- author: AitorATuin
-- license: GPL3

local _ = require('moses')

local luvina = {}

local function is_module_candidate(mod_regex, candidates)
  local modules = _(candidates)
    :filter(function(_, c)
      local m = c:match(mod_regex)
      return m ~= nil and m ~= c 
    end)
    :map(function(i, c) return i, string.match(c, mod_regex) end)
    :value()
  return modules
end

--- Returns a list of available modules able to be loaded in current scope
function luvina.get_available_modules(search_paths, paths)
  return _(search_paths)
    :map(function(k, path) return k, '^' .. string.gsub(path, '?', '(%%w+)') end)
    :map(function(k, mod_regex) return k, is_module_candidate(mod_regex, paths) end)
    :flatten()
    :value()
end

return luvina
