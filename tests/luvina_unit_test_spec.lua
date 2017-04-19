-- busted --coverage --verbose
-- busted tests
package.path = package.path .. ';' .. os.getenv('PWD') .. '/luvina/?.lua'
local luvina = require('luvina')
local get_available_modules = luvina.get_available_modules

describe('Luvima unit tests', function ()
  local paths = {
    {
      '/a/b/c/test1.lua',
      '/a/b/c/test2.lua',
      '/a/b/c/test3/init.lua',
      '/a/b/c/d/e/test4.lua',
      '/a/b/c/d/test5/init.lua',
      '/a/b/c/d/e/f/test6.lua',
      '/a/b/c/d/e/f/test7/init.lua',
      '/aa/b/c/test8.lua',
      '/aa/b/c/test9.lua',
      '/aa/b/c/test10/init.lua',
      '/aa/b/c/d/e/test11.lua',
      '/aa/b/c/d/test12/init.lua',
      '/aa/b/c/d/e/f/test13.lua',
      '/aa/b/c/d/e/f/test14/init.lua',
    },
  }

  describe('Luvima discover modules function', function ()
    it('should work when no paths are defined', function ()
      local search_paths = {}
      assert.are.same(get_available_modules({}, paths[1]), {})
    end)

    it('should work when no dynamic search paths are defined', function ()
      -- It returns an empty list, since there are no modules to discover dynamically
      local search_pahts = {
        '/a/b/c/test1.lua',
        '/a/b/c/test2.lua',
        '/a/b/c/d/test5/init.lua'
      }
      local expected = {}
      assert.are.same(expected, get_available_modules(search_pahts, paths[1]))
    end)

    it('should work when we only have ?.lua values', function ()
      local search_pahts = {
        '/a/b/c/?.lua',
      }
      local expected = {'test1', 'test2'}
      assert.are.same(expected, get_available_modules(search_pahts, paths[1]))
    end)

    it('should work when we only have ?.lua values with nested leved', function ()
      local search_pahts = {
        '/a/b/c/?.lua',
        '/a/b/c/test4/?.lua',
        '/a/b/c/d/e/?.lua',
        '/a/b/c/d/e/f/?.lua'
      }
      local expected = {'test1', 'test2', 'test4', 'test6'}
      assert.are.same(expected, get_available_modules(search_pahts, paths[1]))
    end)

    it('should work when we only have ?/init.lua values', function ()
      local search_pahts = {
        '/a/b/c/?/init.lua',
      }
      local expected = {'test3'}
      assert.are.same(expected, get_available_modules(search_pahts, paths[1]))
    end)

    it('should work when we only have ?/init.lua values with nested levels', function ()
      local search_pahts = {
        '/a/b/c/?/init.lua',
        '/a/b/c/d/e/f/?/init.lua'
      }
      local expected = {'test3', 'test7'}
      assert.are.same(expected, get_available_modules(search_pahts, paths[1]))
    end)

    it('should work with dynamic search paths using ?.lua and ?/init.lua', function ()
      local search_pahts = {
        '/a/b/c/?.lua',
        '/a/b/c/?/init.lua',
        '/a/b/c/d/?.lua',
        '/a/b/c/d/?/init.lua',
        '/a/b/c/d/e/f/?.lua',
        '/a/b/c/d/e/f/?/init.lua'
      }
      local expected = {'test1', 'test2', 'test3', 'test5', 'test6', 'test7'}
      assert.are.same(expected, get_available_modules(search_pahts, paths[1]))
    end)

    it("should work with paths with different roots", function ()
      local search_paths = {
        '/a/b/c/?.lua',
        '/a/b/c/?/init.lua',
        '/a/b/c/d/?.lua',
        '/a/b/c/d/?/init.lua',
        '/a/b/c/d/e/f/?.lua',
        '/a/b/c/d/e/f/?/init.lua',
        '/aa/b/c/?.lua',
        '/aa/b/c/?/init.lua',
        '/aa/b/c/d/?.lua',
        '/aa/b/c/d/?/init.lua',
        '/aa/b/c/d/e/f/?.lua',
        '/aa/b/c/d/e/f/?/init.lua'
      }
      local expected = {'test1', 'test2', 'test3', 'test5', 'test6', 'test7',
                        'test8', 'test9', 'test10', 'test12', 'test13', 
                        'test14'} 
      assert.are.same(expected, get_available_modules(search_paths, paths[1]))
    end)
  end)
end)
