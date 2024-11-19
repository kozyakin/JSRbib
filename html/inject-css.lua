filecss = arg[1]
filehtml = arg[2]

lfs = require('lfs')
function readFile(filename)
    local file = io.open(filename, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

html = readFile(filehtml)
css = readFile(filecss)
css = css:gsub('%%', '%%%%')

spattern = "<link .*href='" .. filecss .. "'.-/>"
rpattern = "<style type='text/css'>\n\n<!--\n" .. css .. "\n\n-->\n</style>"

injectedHtml = html:gsub(spattern, rpattern)
injectedHtml = injectedHtml:gsub('%%%%','%%')

if injectedHtml then
    local file = io.open(filehtml, "w")
    file:write(injectedHtml)
    file:close()
    print("\n\x1b[94mInject-CSS: done!\x1b[0m")
else
    print("\n\x1b[91mInject-CSS: Sorry! Something went wrong!\x1b[0m")
end
