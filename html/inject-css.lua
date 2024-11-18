local filecss = arg[1]
local filehtml = arg[2]

local lfs = require('lfs')
local function readFile(filename)
    local file = io.open(filename, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

local html = readFile(filehtml)
local csstmp = readFile(filecss)
local css = csstmp:gsub('%%', '%%%%')

local spattern = "<link .*href='" .. filecss .. "'.-/>"
local rpattern = "<style type='text/css'>\n\n<!--\n" .. css .. "\n\n-->\n</style>"

local htmltmp = html:gsub(spattern, rpattern)
local injectedHtml = htmltmp:gsub('%%%%','%%')

if injectedHtml then
    local file = io.open(filehtml, "w")
    file:write(injectedHtml)
    file:close()
    print("\n\x1b[94mInject-CSS: done!\x1b[0m")
else
    print("\n\x1b[91mInject-CSS: Sorry! Something went wrong!\x1b[0m")
end

