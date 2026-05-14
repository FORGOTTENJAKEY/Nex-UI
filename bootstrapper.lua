b = {104,116,116,112,115,58,47,47,114,97,119,46,
	103,105,116,104,117,98,117,115,101,114,99,111,
	110,116,101,110,116,46,99,111,109,47,70,79,
	82,71,79,84,84,69,78,74,65,75,69,89,47,
	78,101,120,45,85,73,47,114,101,102,115,47,
	104,101,97,100,115,47,109,97,105,110,47,118,
	101,114,115,105,111,110,115,47,37,115,46,108,
	117,97};lat = "2.2"

return function(v)
	v=v or lat
	local s,r=pcall(function()
		local map="";for _,kv in ipairs(b) do map ..= string.char(kv) end
		local fi=map:format(`v{tostring(v):gsub("%.", "_")}`);
		local s,f=pcall(function()return loadstring(game:HttpGet(fi))()end);
		if not s and v ~= lat then s,f = pcall(function()return loadstring(game:HttpGet(map:format(`v{tostring(lat):gsub("%.", "_")}`)))()end) end;
		if not s then
			warn(`[NexUI: Bootstrapper]: Failed to fetch, please retry again..`)
			return nil
		end
		if s then return f end; return nil
	end)
	if not s then
		warn(`[NexUI: Bootstrapper]: Internal issue occurred. ({r})`)
		return nil
	end
	return r
end
