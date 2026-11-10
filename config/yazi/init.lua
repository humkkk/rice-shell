local emit = ya.emit or ya.mgr_emit or ya.manager_emit

-- Esta pasta e tudo dentro dela: ordenado por data de modificação (mais novos primeiro)
local MTIME_ROOT = os.getenv("HOME") .. "/Pictures/Xxx"

ps.sub("cd", function()
	local cwd = tostring(cx.active.current.cwd)
	local in_root = cwd == MTIME_ROOT or cwd:sub(1, #MTIME_ROOT + 1) == MTIME_ROOT .. "/"

	if in_root then
		emit("sort", { "mtime", reverse = true, dir_first = true })
	else
		emit("sort", { "natural", reverse = false, dir_first = true })
	end
end)
