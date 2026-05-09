map = "https://raw.githubusercontent.com/FORGOTTENJAKEY/Nex-UI/refs/heads/main/versions/%s.lua"
lat = "2.2"

local g = function(v)
	local fi=map:format(`v{tostring(v):gsub("%.", "_")}`);
	local s,f=pcall(function()return loadstring(game:HttpGet(fi))()end);
	if not s and v ~= lat then s,f = pcall(function()return loadstring(game:HttpGet(map:format(`v{tostring(lat):gsub("%.", "_")}`)))()end) end;
	if s then return f end; return nil
end

return g
