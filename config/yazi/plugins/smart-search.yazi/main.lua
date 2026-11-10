--- @since 25.5.31

local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function esc(s)
	return (s:gsub("[%.%+%*%?%(%)%|%[%]%{%}%^%$\\]", "\\%0"))
end

local function parse(q)
	local pos, neg, todo = {}, {}, false
	for w in q:gmatch("%S+") do
		local l = w:lower()
		if l == "/todo" then
			todo = true
		elseif l:sub(1, 1) == "-" and #l > 1 then
			neg[#neg + 1] = l:sub(2)
		else
			pos[#pos + 1] = l
		end
	end
	return pos, neg, todo
end

local function list_names(cwd)
	local out = Command("find"):arg(cwd):arg("-mindepth"):arg("1"):arg("-maxdepth"):arg("1")
		:arg("-printf"):arg("%f\\n"):stdout(Command.PIPED):output()
	local names = {}
	if out then
		for n in out.stdout:gmatch("[^\n]+") do
			names[#names + 1] = n
		end
	end
	return names
end

local function match(name, pos, neg)
	local n = name:lower()
	for _, t in ipairs(pos) do
		if not n:find(t, 1, true) then return false end
	end
	for _, t in ipairs(neg) do
		if n:find(t, 1, true) then return false end
	end
	return true
end

local function apply_local(names, pos, neg)
	if #pos == 0 and #neg == 0 then
		ya.emit("escape", { filter = true })
		return
	end
	local keep = {}
	for _, n in ipairs(names) do
		if match(n, pos, neg) then keep[#keep + 1] = esc(n) end
	end
	if #keep == 0 then
		ya.emit("filter_do", { "^$" })
	else
		ya.emit("filter_do", { "^(?:" .. table.concat(keep, "|") .. ")$" })
	end
end

local function nocase_glob(t)
	return (t:gsub("%a", function(c) return "[" .. c:lower() .. c:upper() .. "]" end))
end

local function apply_todo(pos, neg)
	local args = { "-i", "-t", "f", "-t", "l" }
	for i = 2, #pos do
		args[#args + 1] = "--and"
		args[#args + 1] = esc(pos[i])
	end
	for _, t in ipairs(neg) do
		local g = nocase_glob(t:gsub("[%*%?%[%]\\]", "\\%0"))
		if t:find(".", 1, true) then
			args[#args + 1] = "-E"; args[#args + 1] = "*" .. g .. "*"
		else
			args[#args + 1] = "-E"; args[#args + 1] = "*" .. g .. "*.*"
			args[#args + 1] = "-E"; args[#args + 1] = "*.*" .. g .. "*"
		end
	end
	for i, a in ipairs(args) do args[i] = ya.quote(a) end
	ya.emit("escape", { filter = true })
	ya.emit("search_do", { pos[1] and esc(pos[1]) or ".", via = "fd", args = table.concat(args, " ") })
end

return {
	entry = function()
		local cwd = get_cwd()
		if cwd:find("^search://") then
			ya.notify { title = "Busca", content = "Saia da busca atual (Esc) antes de buscar de novo.", timeout = 4, level = "warn" }
			return
		end
		local names = list_names(cwd)
		local input = ya.input {
			title = "Busca: termos, -excluir, /todo (subpastas)",
			pos = { "top-center", y = 3, w = 60 },
			realtime = true,
			debounce = 0.1,
		}
		local value, event
		while true do
			value, event = input:recv()
			if event ~= 3 then break end
			local pos, neg, todo = parse(value)
			if not todo then apply_local(names, pos, neg) end
		end
		if event ~= 1 then
			ya.emit("escape", { filter = true })
			return
		end
		local pos, neg, todo = parse(value)
		if todo then apply_todo(pos, neg) else apply_local(names, pos, neg) end
	end,
}
