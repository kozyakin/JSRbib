filecss = arg[1]
filehtml = arg[2]

local function readFile(filename)
    local f = io.open(filename, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return content
end

local function writeFile(file, data)
    local f = io.open(file, "w")
    if not f then return nil end
    f:write(data)
    f:close()
end

html = readFile(filehtml)
css = readFile(filecss)
css = css:gsub('%%', '%%%%')

spattern = "<link .*href='" .. filecss .. "'.-/>"
rpattern = "<style type='text/css'>\n\n<!--\n" .. css .. "\n\n-->\n</style>"

injectedHtml = html:gsub(spattern, rpattern)
injectedHtml = injectedHtml:gsub('%%%%','%%')

if injectedHtml then
    writeFile(filehtml, injectedHtml)
    print("\n\x1b[94mInject-CSS: done!\x1b[0m")
else
    print("\n\x1b[91mInject-CSS: Sorry! Something went wrong!\x1b[0m")
end
