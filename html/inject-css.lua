filecss = arg[1]
filehtml = arg[2]

local function readfile(name)
  local f = assert(io.open(name, "r"))
  local s = f:read("*a")
  f:close()
  return s
end

local function writefile(name, sum)
  local f = assert(io.open(name, "w"))
  f:write(sum)
  f:close()
end

html = readfile(filehtml)
css = readfile(filecss)
css = css:gsub('%%', '%%%%')

spattern = "<link .*href='" .. filecss .. "'.-/>"
rpattern = "<style type='text/css'>\n\n<!--\n" .. css .. "\n\n-->\n</style>"

injectedHtml = html:gsub(spattern, rpattern)
injectedHtml = injectedHtml:gsub('%%%%','%%')

if injectedHtml then
    writefile(filehtml, injectedHtml)
    print("\n\x1b[94mInject-CSS: done!\x1b[0m")
else
    print("\n\x1b[91mInject-CSS: Sorry! Something went wrong!\x1b[0m")
end
