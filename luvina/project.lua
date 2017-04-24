------------
-- Project
-- description
-- classmod: Project
-- author: AitorATuin
-- license:MIT

local luvina = require('luvina')
local lfs    = require('lfs')
local _      = require('fun')

local function get_files(dir, dirs_to_recurse)
  for file in lfs.dir(dir) do
    local file_path = dir .. '/' .. file
    local mode = lfs.attributes(file_path, 'mode')
    if mode == 'directory' then
      -- entry found /a/b/c/d
      local needs_recursion = _.findIndex(dirs_to_recurse, function (_, dir_candidate)
        return file_path:match(dir_candidate .. '$') ~= nil
      end)
    if needs_recursion then
      get_files(file_path, dirs_to_recurse)
    end
    elseif mode == 'file' then
      coroutine.yield(file_path)
    end
  end
end

function candidates_iter(candidates)
  local dir_paths = _(candidates)
    :map(function(i, v) return i, _.split(v, '/') end)
    :map(function(i ,paths) return i, _.head(paths, #paths-1) end)
    :sortBy(function (paths) return #paths end)
    :value()

  local first_dir = _.join(_.head(dir_paths)[1], '/')
  local dirs_to_recurse = _.map(_.tail(dir_paths, 2), function(i, v)
    return i, _.join(v, '/')
  end)
  -- If first directory to iterate contains a pattern we can use it so remove
  -- the pattern, use the result as first dir and add it to the list of 
  -- directories to iterate
  if first_dir:match('%(%%w%+%)') then
    _.addTop(dirs_to_recurse, first_dir)
    first_dir = first_dir:match('(.+)/%(%%%w%+%)')
  end
 
  return coroutine.wrap(function ()
    return get_files(first_dir, dirs_to_recurse)
  end)
end

-- class table
local Project = {}

Project.__index = Project

Project.new = function()
  local search_paths, candidates_iter = get_candidates()
  luvina.get_available_modules(search_paths, candidates_iter)
end
