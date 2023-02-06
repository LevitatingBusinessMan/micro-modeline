VERSION = "0.0.1"

local util = import("micro/util")
local config = import("micro/config")
local buffer = import("micro/buffer")
local micro = import("micro")
local ft = {}

ft["apacheconf"] = "# %s"
ft["bat"] = ":: %s"
ft["c"] = "// %s"
ft["c++"] = "// %s"
ft["cmake"] = "# %s"
ft["conf"] = "# %s"
ft["crystal"] = "# %s"
ft["css"] = "/* %s */"
ft["d"] = "// %s"
ft["dart"] = "// %s"
ft["dockerfile"] = "# %s"
ft["elm"] = "-- %s"
ft["fish"] = "# %s"
ft["gdscript"] = "# %s"
ft["glsl"] = "// %s"
ft["go"] = "// %s"
ft["haskell"] = "-- %s"
ft["html"] = "<!-- %s -->"
ft["ini"] = "; %s"
ft["java"] = "// %s"
ft["javascript"] = "// %s"
ft["jinja2"] = "{# %s #}"
ft["julia"] = "# %s"
ft["kotlin"] = "// %s"
ft["lua"] = "-- %s"
ft["markdown"] = "<!-- %s -->"
ft["nginx"] = "# %s"
ft["nim"] = "# %s"
ft["objc"] = "// %s"
ft["ocaml"] = "(* %s *)"
ft["pascal"] = "{ %s }"
ft["perl"] = "# %s"
ft["php"] = "// %s"
ft["pony"] = "// %s"
ft["powershell"] = "# %s"
ft["proto"] = "// %s"
ft["python"] = "# %s"
ft["python3"] = "# %s"
ft["ruby"] = "# %s"
ft["rust"] = "// %s"
ft["scala"] = "// %s"
ft["shell"] = "# %s"
ft["sql"] = "-- %s"
ft["swift"] = "// %s"
ft["tex"] = "% %s"
ft["toml"] = "# %s"
ft["twig"] = "{# %s #}"
ft["v"] = "// %s"
ft["xml"] = "<!-- %s -->"
ft["yaml"] = "# %s"
ft["zig"] = "// %s"
ft["zscript"] = "// %s"
ft["zsh"] = "# %s"

local last_ft

function updateCommentType(buf)
	if buf.Settings["commenttype"] == nil or last_ft ~= buf.Settings["filetype"] then
		if ft[buf.Settings["filetype"]] ~= nil then
			buf.Settings["commenttype"] = ft[buf.Settings["filetype"]]
		else
			buf.Settings["commenttype"] = "# %s"
		end

	last_ft = buf.Settings["filetype"]
	end
end

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

function findModeline(buf)
	updateCommentType(buf)

	local commenttype = buf.Settings["commenttype"]

	for i=1,buf:LinesNum() do
		line = buf:Line(i)

		-- This should be done via a regex instead
		-- Not all types work right now
		if line.starts(line, string.format(commenttype, "micro:")) then
			return line
		end
	end
end

-- https://vimdoc.sourceforge.net/htmldoc/options.html#modeline
function parseModeline(line)
	if line == nil then
		return
	end

	for i=1,#line do
		local c = line:sub(i,i)
		micro.TermMessage(c)
	end
end

-- function onBufferOpen(buf)
	-- parseModeline(findModeline(buf))
-- end

function onSave(bp)
	parseModeline(findModeline(bp.Buf))
	return false
end

function init()
	config.AddRuntimeFile("modeline", config.RTHelp, "help/modeline.md")
end
