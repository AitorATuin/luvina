package.path = package.path .. ';' .. os.getenv('PWD') .. '/luvina/?.lua'
local _ = require('fun')

describe('fun unit tests', function ()
  it('fun.split can split empty strings', function()
    assert.are.same({''}, _.split('', ''))
    assert.are.same({''}, _.split('', ';'))
    assert.are.same({''}, _.split('', '/'))
    assert.are.same({''}, _.split('', '//'))
  end)
  it('fun.split returns the same string if we can not find any sep', function ()
    local str1 = '/uno/dos/tres'
    local str2 = ';uno;dos;tres'
    assert.are.same({str1}, _.split(str1, ';'))
    assert.are.same({str2}, _.split(str2, '/'))
  end)
  it("fun.split can split strings", function ()
    local str1 = '/uno/dos/tres/cuatro'
    local str2 = 'uno;dos;tres;cuatro'
    local str3 = 'uno@dos@tres@cuatro'
    local str4 = 'uno@@dos@@tres@@cuatro'
    local str5 = 'uno##dos@@tres##cuatro'
    assert.are.same(table.concat(_.split(str1, '/'), '/'), str1)
    assert.are.same(table.concat(_.split(str2, ';'), ';'), str2)
    assert.are.same(table.concat(_.split(str3, '@'), '@'), str3)
    assert.are.same(table.concat(_.split(str4, '@@'), '@@'), str4)
    assert.are.same(table.concat(_.split(str5, '##'), '##'), str5)
    assert.are.same(table.concat(_.split(str5, '@@'), '@@'), str5)
  end)
  it("fun.split is able to manage separators at the beginning/end", function ()
    local str1 = 'uno/dos/tres/cuatro/' 
    local str2 = '/uno/dos/tres/cuatro' 
    local str3 = 'uno/dos/tres/cuatro' 
    local str4 = '/uno/dos/tres/cuatro/' 
    assert.are.same(_.split(str1, '/'), {'uno', 'dos', 'tres', 'cuatro', ''})
    assert.are.same(_.split(str2, '/'), {'', 'uno', 'dos', 'tres', 'cuatro'})
    assert.are.same(_.split(str3, '/'), {'uno', 'dos', 'tres', 'cuatro'})
    assert.are.same(_.split(str4, '/'), {'', 'uno', 'dos', 'tres', 'cuatro', ''})
  end)
end)

