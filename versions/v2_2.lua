--!native

--[[
   eg, USAGE:
        local ModernUI = require(game.ReplicatedStorage.ModernUI)

        local Window = ModernUI.new({
            Title = "My App",
            Icon  = "⚙",
            Size  = UDim2.new(0, 620, 0, 460)
        })

        local Settings = Window:AddPage("Settings", "⚙")
        Settings:AddToggle("Enable Feature", false, function(v) print(v) end)

        -- Adds a built-in "Themes" page automatically
        Window:AddThemePage("🎨")

        Window:SelectPage("Settings")
        Window:Show()

        -- Or apply a theme from code:
        Window:ApplyTheme("Nord")
--]]

-- ───────────────────────────────────────────────────────────────────────────
--  Services
-- ───────────────────────────────────────────────────────────────────────────
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local T_FAST   = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local T_MED    = TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local T_THEME  = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local T_SPRING = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ── Live palette (mutated in-place by ApplyTheme) ────────────────────────
local C = {
	BG          = Color3.fromRGB(13,  14,  18),
	SURFACE     = Color3.fromRGB(20,  21,  28),
	ELEVATED    = Color3.fromRGB(26,  28,  38),
	SIDEBAR     = Color3.fromRGB(16,  17,  23),
	BORDER      = Color3.fromRGB(38,  40,  54),
	ACCENT      = Color3.fromRGB(99,  102, 241),
	ACCENT2     = Color3.fromRGB(139,  92, 246),
	DANGER      = Color3.fromRGB(239,  68,  68),
	TEXT        = Color3.fromRGB(240, 241, 248),
	TEXT_MUTED  = Color3.fromRGB(120, 124, 160),
	TEXT_SUBTLE = Color3.fromRGB( 72,  75, 106),
	HIGHLIGHT   = Color3.fromRGB( 40,  42,  62),
	SLIDER_BG   = Color3.fromRGB( 30,  32,  46),
	TOGGLE_OFF  = Color3.fromRGB( 45,  47,  65),
	WHITE       = Color3.fromRGB(255, 255, 255),
	TASKBAR_BG  = Color3.fromRGB(18,  19,  26),
}

-- ───────────────────────────────────────────────────────────────────────────
--  Theme definitions
-- ───────────────────────────────────────────────────────────────────────────
local THEMES = {
	Dark = {
		desc    = "Deep space dark",
		preview = { Color3.fromRGB(13,14,18), Color3.fromRGB(99,102,241) },
		palette = {
			BG=Color3.fromRGB(13,14,18), SURFACE=Color3.fromRGB(20,21,28),
			ELEVATED=Color3.fromRGB(26,28,38), SIDEBAR=Color3.fromRGB(16,17,23),
			BORDER=Color3.fromRGB(38,40,54), ACCENT=Color3.fromRGB(99,102,241),
			ACCENT2=Color3.fromRGB(139,92,246), DANGER=Color3.fromRGB(239,68,68),
			TEXT=Color3.fromRGB(240,241,248), TEXT_MUTED=Color3.fromRGB(120,124,160),
			TEXT_SUBTLE=Color3.fromRGB(72,75,106), HIGHLIGHT=Color3.fromRGB(40,42,62),
			SLIDER_BG=Color3.fromRGB(30,32,46), TOGGLE_OFF=Color3.fromRGB(45,47,65),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(18,19,26),
		},
	},
	Light = {
		desc    = "Clean & bright",
		preview = { Color3.fromRGB(245,246,252), Color3.fromRGB(79,70,229) },
		palette = {
			BG=Color3.fromRGB(245,246,252), SURFACE=Color3.fromRGB(255,255,255),
			ELEVATED=Color3.fromRGB(235,236,245), SIDEBAR=Color3.fromRGB(238,239,250),
			BORDER=Color3.fromRGB(210,212,230), ACCENT=Color3.fromRGB(79,70,229),
			ACCENT2=Color3.fromRGB(124,58,237), DANGER=Color3.fromRGB(220,38,38),
			TEXT=Color3.fromRGB(15,15,30), TEXT_MUTED=Color3.fromRGB(90,90,130),
			TEXT_SUBTLE=Color3.fromRGB(155,155,185), HIGHLIGHT=Color3.fromRGB(220,221,240),
			SLIDER_BG=Color3.fromRGB(210,212,232), TOGGLE_OFF=Color3.fromRGB(195,197,220),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(240,241,250),
		},
	},
	Midnight = {
		desc    = "Pure black OLED",
		preview = { Color3.fromRGB(0,0,0), Color3.fromRGB(6,182,212) },
		palette = {
			BG=Color3.fromRGB(0,0,0), SURFACE=Color3.fromRGB(8,8,12),
			ELEVATED=Color3.fromRGB(14,14,20), SIDEBAR=Color3.fromRGB(5,5,8),
			BORDER=Color3.fromRGB(28,28,40), ACCENT=Color3.fromRGB(6,182,212),
			ACCENT2=Color3.fromRGB(34,211,238), DANGER=Color3.fromRGB(239,68,68),
			TEXT=Color3.fromRGB(236,254,255), TEXT_MUTED=Color3.fromRGB(100,160,175),
			TEXT_SUBTLE=Color3.fromRGB(50,90,100), HIGHLIGHT=Color3.fromRGB(15,30,35),
			SLIDER_BG=Color3.fromRGB(10,20,25), TOGGLE_OFF=Color3.fromRGB(20,35,42),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(4,4,6),
		},
	},
	Dracula = {
		desc    = "Classic vampire",
		preview = { Color3.fromRGB(40,42,54), Color3.fromRGB(189,147,249) },
		palette = {
			BG=Color3.fromRGB(40,42,54), SURFACE=Color3.fromRGB(48,50,65),
			ELEVATED=Color3.fromRGB(58,60,76), SIDEBAR=Color3.fromRGB(33,34,44),
			BORDER=Color3.fromRGB(68,71,90), ACCENT=Color3.fromRGB(189,147,249),
			ACCENT2=Color3.fromRGB(255,121,198), DANGER=Color3.fromRGB(255,85,85),
			TEXT=Color3.fromRGB(248,248,242), TEXT_MUTED=Color3.fromRGB(190,190,200),
			TEXT_SUBTLE=Color3.fromRGB(110,112,130), HIGHLIGHT=Color3.fromRGB(68,71,90),
			SLIDER_BG=Color3.fromRGB(52,55,70), TOGGLE_OFF=Color3.fromRGB(65,68,86),
			WHITE=Color3.fromRGB(248,248,242), TASKBAR_BG=Color3.fromRGB(30,31,41),
		},
	},
	Nord = {
		desc    = "Arctic minimal",
		preview = { Color3.fromRGB(46,52,64), Color3.fromRGB(136,192,208) },
		palette = {
			BG=Color3.fromRGB(46,52,64), SURFACE=Color3.fromRGB(59,66,82),
			ELEVATED=Color3.fromRGB(67,76,94), SIDEBAR=Color3.fromRGB(36,41,51),
			BORDER=Color3.fromRGB(76,86,106), ACCENT=Color3.fromRGB(136,192,208),
			ACCENT2=Color3.fromRGB(129,161,193), DANGER=Color3.fromRGB(191,97,106),
			TEXT=Color3.fromRGB(236,239,244), TEXT_MUTED=Color3.fromRGB(162,174,190),
			TEXT_SUBTLE=Color3.fromRGB(100,112,130), HIGHLIGHT=Color3.fromRGB(76,86,106),
			SLIDER_BG=Color3.fromRGB(55,63,79), TOGGLE_OFF=Color3.fromRGB(70,80,99),
			WHITE=Color3.fromRGB(236,239,244), TASKBAR_BG=Color3.fromRGB(39,44,54),
		},
	},
	Mocha = {
		desc    = "Warm catppuccin",
		preview = { Color3.fromRGB(30,30,46), Color3.fromRGB(203,166,247) },
		palette = {
			BG=Color3.fromRGB(30,30,46), SURFACE=Color3.fromRGB(36,36,54),
			ELEVATED=Color3.fromRGB(49,50,68), SIDEBAR=Color3.fromRGB(24,24,37),
			BORDER=Color3.fromRGB(62,64,84), ACCENT=Color3.fromRGB(203,166,247),
			ACCENT2=Color3.fromRGB(245,194,231), DANGER=Color3.fromRGB(243,139,168),
			TEXT=Color3.fromRGB(205,214,244), TEXT_MUTED=Color3.fromRGB(148,152,186),
			TEXT_SUBTLE=Color3.fromRGB(88,91,112), HIGHLIGHT=Color3.fromRGB(62,64,84),
			SLIDER_BG=Color3.fromRGB(42,44,60), TOGGLE_OFF=Color3.fromRGB(58,60,80),
			WHITE=Color3.fromRGB(205,214,244), TASKBAR_BG=Color3.fromRGB(22,22,34),
		},
	},
	Aurora = {
		desc    = "Neon aurora glow",
		preview = { Color3.fromRGB(15,23,42), Color3.fromRGB(16,185,129) },
		palette = {
			BG=Color3.fromRGB(15,23,42), SURFACE=Color3.fromRGB(30,41,59),
			ELEVATED=Color3.fromRGB(51,65,85), SIDEBAR=Color3.fromRGB(10,15,30),
			BORDER=Color3.fromRGB(71,85,105), ACCENT=Color3.fromRGB(16,185,129),
			ACCENT2=Color3.fromRGB(59,130,246), DANGER=Color3.fromRGB(239,68,68),
			TEXT=Color3.fromRGB(226,232,240), TEXT_MUTED=Color3.fromRGB(148,163,184),
			TEXT_SUBTLE=Color3.fromRGB(100,116,139), HIGHLIGHT=Color3.fromRGB(45,55,72),
			SLIDER_BG=Color3.fromRGB(36,48,66), TOGGLE_OFF=Color3.fromRGB(55,65,81),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(12,18,32),
		},
	},

	Sunset = {
		desc    = "Warm orange dusk",
		preview = { Color3.fromRGB(45,24,16), Color3.fromRGB(249,115,22) },
		palette = {
			BG=Color3.fromRGB(45,24,16), SURFACE=Color3.fromRGB(60,32,20),
			ELEVATED=Color3.fromRGB(75,42,28), SIDEBAR=Color3.fromRGB(35,18,12),
			BORDER=Color3.fromRGB(110,60,40), ACCENT=Color3.fromRGB(249,115,22),
			ACCENT2=Color3.fromRGB(251,191,36), DANGER=Color3.fromRGB(239,68,68),
			TEXT=Color3.fromRGB(255,237,213), TEXT_MUTED=Color3.fromRGB(254,215,170),
			TEXT_SUBTLE=Color3.fromRGB(180,120,90), HIGHLIGHT=Color3.fromRGB(90,50,35),
			SLIDER_BG=Color3.fromRGB(70,38,25), TOGGLE_OFF=Color3.fromRGB(90,55,40),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(28,14,10),
		},
	},

	Forest = {
		desc    = "Earthy green tones",
		preview = { Color3.fromRGB(20,33,24), Color3.fromRGB(34,197,94) },
		palette = {
			BG=Color3.fromRGB(20,33,24), SURFACE=Color3.fromRGB(28,44,32),
			ELEVATED=Color3.fromRGB(36,56,40), SIDEBAR=Color3.fromRGB(15,25,18),
			BORDER=Color3.fromRGB(58,83,63), ACCENT=Color3.fromRGB(34,197,94),
			ACCENT2=Color3.fromRGB(132,204,22), DANGER=Color3.fromRGB(220,38,38),
			TEXT=Color3.fromRGB(220,252,231), TEXT_MUTED=Color3.fromRGB(167,243,208),
			TEXT_SUBTLE=Color3.fromRGB(100,140,110), HIGHLIGHT=Color3.fromRGB(45,68,50),
			SLIDER_BG=Color3.fromRGB(32,50,36), TOGGLE_OFF=Color3.fromRGB(52,74,57),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(16,27,19),
		},
	},

	Rose = {
		desc    = "Soft pink aesthetic",
		preview = { Color3.fromRGB(44,17,29), Color3.fromRGB(244,114,182) },
		palette = {
			BG=Color3.fromRGB(44,17,29), SURFACE=Color3.fromRGB(60,24,40),
			ELEVATED=Color3.fromRGB(78,32,52), SIDEBAR=Color3.fromRGB(35,12,22),
			BORDER=Color3.fromRGB(110,50,75), ACCENT=Color3.fromRGB(244,114,182),
			ACCENT2=Color3.fromRGB(251,146,60), DANGER=Color3.fromRGB(239,68,68),
			TEXT=Color3.fromRGB(255,228,236), TEXT_MUTED=Color3.fromRGB(253,164,175),
			TEXT_SUBTLE=Color3.fromRGB(180,100,125), HIGHLIGHT=Color3.fromRGB(90,40,60),
			SLIDER_BG=Color3.fromRGB(70,28,46), TOGGLE_OFF=Color3.fromRGB(92,42,60),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(28,10,18),
		},
	},

	Ocean = {
		desc    = "Deep blue waters",
		preview = { Color3.fromRGB(10,25,47), Color3.fromRGB(56,189,248) },
		palette = {
			BG=Color3.fromRGB(10,25,47), SURFACE=Color3.fromRGB(17,34,64),
			ELEVATED=Color3.fromRGB(24,48,85), SIDEBAR=Color3.fromRGB(8,18,35),
			BORDER=Color3.fromRGB(45,70,110), ACCENT=Color3.fromRGB(56,189,248),
			ACCENT2=Color3.fromRGB(14,165,233), DANGER=Color3.fromRGB(239,68,68),
			TEXT=Color3.fromRGB(224,242,254), TEXT_MUTED=Color3.fromRGB(125,211,252),
			TEXT_SUBTLE=Color3.fromRGB(90,140,180), HIGHLIGHT=Color3.fromRGB(22,44,76),
			SLIDER_BG=Color3.fromRGB(18,38,68), TOGGLE_OFF=Color3.fromRGB(35,58,95),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(6,14,28),
		},
	},
	Bloodmoon = {
		desc    = "Dark crimson energy",
		preview = { Color3.fromRGB(18,6,8), Color3.fromRGB(220,38,38) },
		palette = {
			BG=Color3.fromRGB(18,6,8), SURFACE=Color3.fromRGB(32,10,14),
			ELEVATED=Color3.fromRGB(48,14,20), SIDEBAR=Color3.fromRGB(12,3,5),
			BORDER=Color3.fromRGB(85,20,28), ACCENT=Color3.fromRGB(220,38,38),
			ACCENT2=Color3.fromRGB(248,113,113), DANGER=Color3.fromRGB(185,28,28),
			TEXT=Color3.fromRGB(254,226,226), TEXT_MUTED=Color3.fromRGB(252,165,165),
			TEXT_SUBTLE=Color3.fromRGB(140,80,80), HIGHLIGHT=Color3.fromRGB(55,15,20),
			SLIDER_BG=Color3.fromRGB(40,12,16), TOGGLE_OFF=Color3.fromRGB(60,18,24),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(10,2,4),
		},
	},
	Mono = {
		desc    = "Minimal black & white",
		preview = { Color3.fromRGB(245,245,245), Color3.fromRGB(20,20,20) },
		palette = {
			BG=Color3.fromRGB(245,245,245), SURFACE=Color3.fromRGB(255,255,255),
			ELEVATED=Color3.fromRGB(230,230,230), SIDEBAR=Color3.fromRGB(235,235,235),
			BORDER=Color3.fromRGB(200,200,200), ACCENT=Color3.fromRGB(20,20,20),
			ACCENT2=Color3.fromRGB(80,80,80), DANGER=Color3.fromRGB(120,120,120),
			TEXT=Color3.fromRGB(10,10,10), TEXT_MUTED=Color3.fromRGB(90,90,90),
			TEXT_SUBTLE=Color3.fromRGB(150,150,150), HIGHLIGHT=Color3.fromRGB(215,215,215),
			SLIDER_BG=Color3.fromRGB(210,210,210), TOGGLE_OFF=Color3.fromRGB(180,180,180),
			WHITE=Color3.fromRGB(255,255,255), TASKBAR_BG=Color3.fromRGB(225,225,225),
		},
	},
	MonoDark = {
		desc    = "Pure monochrome dark",
		preview = { Color3.fromRGB(10,10,10), Color3.fromRGB(235,235,235) },
		palette = {
			BG=Color3.fromRGB(10,10,10), SURFACE=Color3.fromRGB(18,18,18),
			ELEVATED=Color3.fromRGB(28,28,28), SIDEBAR=Color3.fromRGB(14,14,14),
			BORDER=Color3.fromRGB(45,45,45), ACCENT=Color3.fromRGB(235,235,235),
			ACCENT2=Color3.fromRGB(180,180,180), DANGER=Color3.fromRGB(140,140,140),
			TEXT=Color3.fromRGB(245,245,245), TEXT_MUTED=Color3.fromRGB(180,180,180),
			TEXT_SUBTLE=Color3.fromRGB(110,110,110), HIGHLIGHT=Color3.fromRGB(35,35,35),
			SLIDER_BG=Color3.fromRGB(24,24,24), TOGGLE_OFF=Color3.fromRGB(55,55,55),
			WHITE=Color3.fromRGB(27, 27, 27), TASKBAR_BG=Color3.fromRGB(12,12,12),
		},
	},
}

local THEME_ORDER = {
	"Dark", "Light", "Mono", "MonoDark", "Midnight", "Dracula", "Nord", "Mocha",
	"Aurora", "Sunset", "Forest", "Rose", "Ocean", "Bloodmoon"
}

-- ───────────────────────────────────────────────────────────────────────────
--  Skin registry  — { inst, prop, key }
-- ───────────────────────────────────────────────────────────────────────────
local _skinReg = {}

local function Skin(inst, prop, key, override)
	if not inst then return end

	local finalKey = typeof(override) == "string" and override or key
	
	if inst:IsA("UIGradient") and prop == "Color" then
		inst[prop] = ColorSequence.new(C[finalKey])
	else
		inst[prop] = C[finalKey]
	end

	-- true = skip theme updates entirely
	if override == true then
		return
	end

	table.insert(_skinReg, {
		inst = inst,
		prop = prop,
		key  = finalKey,
	})
end

-- ───────────────────────────────────────────────────────────────────────────
--  Helpers
-- ───────────────────────────────────────────────────────────────────────────

local _nextZIndex = 0
local _topZFrame = nil

local function GetNextZIndex()
	_nextZIndex = (_nextZIndex + 1) % 5
	return _nextZIndex
end

local function BringToFront(root)
	if _topZFrame == root then return end
	root.ZIndex = GetNextZIndex()
	_topZFrame = root
end

local function Tween(obj, props, info)
	local t = TweenService:Create(obj, info or T_FAST, props)
	t.Completed:Once(function() t:Destroy() end)
	t:Play()
end

local function New(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end
	if props.Parent then obj.Parent = props.Parent end
	return obj
end

local function Corner(p, r) New("UICorner",{CornerRadius=UDim.new(0,r or 8),Parent=p}) end

-- Raw stroke (no skin registration — for things whose colour must not be reset by theme)
local function StrokeRaw(p, col, t)
	return New("UIStroke",{Color=col or C.BORDER,Thickness=t or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=p})
end
-- Skinned stroke
local function Stroke(p, col, t)
	local s = StrokeRaw(p, col, t)
	Skin(s, "Color", "BORDER")
	return s
end

local function Pad(p, top, right, bottom, left)
	New("UIPadding",{PaddingTop=UDim.new(0,top or 8),PaddingRight=UDim.new(0,right or 8),
		PaddingBottom=UDim.new(0,bottom or 8),PaddingLeft=UDim.new(0,left or 8),Parent=p})
end

local function Grad(p, key0, key1, rot)
	local g = New("UIGradient", {
		Color = ColorSequence.new(C[key0], C[key1]),
		Rotation = rot or 0,
		Parent = p
	})

	table.insert(_skinReg, {
		inst = g,
		prop = "__GRADIENT",
		key0 = key0,
		key1 = key1,
	})

	return g
end

local function ListLayout(p, gap)
	New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,FillDirection=Enum.FillDirection.Vertical,
		HorizontalAlignment=Enum.HorizontalAlignment.Left,Padding=UDim.new(0,gap or 0),Parent=p})
end

local _sg, _overlay, _taskbar
local paddingX = NumberRange.new(-20,20)
local paddingY = NumberRange.new(0,20)

local function MakeDraggable(frame, handle, clampToParent)
	local dragging, dragInput, dragStart, startPos
	handle.InputBegan:Connect(function(inp)
		if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
		dragging=true; dragStart=inp.Position; startPos=frame.AbsolutePosition
		inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
		BringToFront(frame)
	end)
	handle.InputChanged:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseMovement then dragInput=inp end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if inp~=dragInput or not dragging then return end
		local d=inp.Position-dragStart
		local newX,newY=startPos.X+d.X, startPos.Y+d.Y
		if clampToParent then
			local ps,fs=_sg.AbsoluteSize,frame.AbsoluteSize
			newX=math.clamp(newX,paddingX.Min,(ps.X-fs.X)+paddingX.Max)
			newY=math.clamp(newY,paddingY.Min,(ps.Y-fs.Y)+paddingY.Max)
		end
		frame.Position=UDim2.fromOffset(newX,newY)
	end)
end

local function IsImageId(str: string): boolean
	return (str:find("rbxassetid://") or str:find("rbxasset://") or str:find("http://www.roblox.com/asset/?id=")) ~= nil
end

-- ───────────────────────────────────────────────────────────────────────────
--  Shared ScreenGui / Overlay / Taskbar
-- ───────────────────────────────────────────────────────────────────────────
local _dropdowns = {}
local encryptedName = nil

local function encrypt(str: string, key: string): string
	local keyLen = #key
	local keyIndex = 1
	local result = ""
	for i = 1, #str do
		result=result..string.char((string.byte(str,i)+string.byte(key,keyIndex))-128)
		keyIndex = (keyIndex % keyLen) + 1
	end
	return result
end

local function GetSG()
	if _sg and _sg.Parent then return _sg end
	if not encryptedName then encryptedName = encrypt("NexUIRoot", "nex") end
	local pg=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	_sg=pg:FindFirstChild(encryptedName) or New("ScreenGui",{Name=encryptedName,ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder = 99999,Parent=pg})
	return _sg
end

local function GetOverlay()
	if _overlay and _overlay.Parent then return _overlay end
	_overlay=New("Frame",{Name="_DropdownOverlay",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=500,Parent=GetSG()})
	return _overlay
end

local TASKBAR_BTN_W,TASKBAR_BTN_H,TASKBAR_MARGIN=160,32,6
local _taskbarCount=0

local function GetTaskbar()
	if _taskbar and _taskbar.Parent then return _taskbar end
	_taskbar=New("Frame",{Name="_Taskbar",AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,4),
		Size=UDim2.new(1,-16,0,40),BackgroundTransparency=1,ZIndex=300,Parent=GetSG()})
	New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,
		VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,
		Padding=UDim.new(0,TASKBAR_MARGIN),Parent=_taskbar})
	return _taskbar
end

local function CreateTaskbarButton(title, icon, onClickFn)
	_taskbarCount+=1
	local taskbar=GetTaskbar()
	local btn=New("TextButton",{Size=UDim2.new(0,0,0,TASKBAR_BTN_H),BackgroundColor3=C.ELEVATED,
		AutoButtonColor=false,Text="",ClipsDescendants=true,ZIndex=301,LayoutOrder=_taskbarCount,Parent=taskbar})
	Corner(btn,7); Skin(StrokeRaw(btn,C.BORDER,1), "Color", "ELEVATED")
	local isImg=type(icon)=="string" and IsImageId(icon)
	if isImg then
		Skin(New("ImageLabel",{BackgroundTransparency=1,Position=UDim2.new(0,8,0.5,0),AnchorPoint=Vector2.new(0,0.5),
			Size=UDim2.new(0,18,0,18),Image=icon,ZIndex=302,Parent=btn}), "ImageColor3", "ACCENT")
	elseif icon and icon~="" then
		New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,8,0.5,0),AnchorPoint=Vector2.new(0,0.5),
			Size=UDim2.new(0,18,0,18),Font=Enum.Font.GothamBold,Text=icon,TextSize=14,
			TextColor3=C.ACCENT,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=302,Parent=btn})
	end
	local ioff=(icon and icon~="") and 30 or 10
	local txtl=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,ioff,0,0),Size=UDim2.new(1,-(ioff+8),1,0),
		Font=Enum.Font.GothamSemibold,Text=title,TextSize=12,TextColor3=C.TEXT,
		TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=302,Parent=btn})
	Skin(txtl, "TextColor3", "TEXT")
	Skin(btn, "BackgroundColor3", "ELEVATED")
	
	btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=C.HIGHLIGHT}) end)
	btn.MouseLeave:Connect(function()  Tween(btn,{BackgroundColor3=C.ELEVATED})  end)
	task.defer(function() Tween(btn,{Size=UDim2.new(0,TASKBAR_BTN_W,0,TASKBAR_BTN_H)},T_SPRING) end)
	btn.Activated:Connect(function()
		Tween(btn,{Size=UDim2.new(0,0,0,TASKBAR_BTN_H)},T_MED)
		task.delay(0.32,function() btn:Destroy(); onClickFn() end)
	end)
	return btn
end

local function CloseAllDropdowns(except)
	for _,dd in ipairs(_dropdowns) do if dd~=except and dd.open then dd.closeFn() end end
end

UserInputService.InputBegan:Connect(function(inp)
	if inp.UserInputType~=Enum.UserInputType.MouseButton1 then return end
	local pos=UserInputService:GetMouseLocation()
	local shut=true
	for _,dd in ipairs(_dropdowns) do
		if dd.open and dd.listFrame then
			local ap,as=dd.listFrame.AbsolutePosition,dd.listFrame.AbsoluteSize
			if pos.X>=ap.X and pos.X<=ap.X+as.X and pos.Y>=ap.Y and pos.Y<=ap.Y+as.Y then shut=false;break end
		end
	end
	if shut then task.defer(function() CloseAllDropdowns(nil) end) end
end)

-- ───────────────────────────────────────────────────────────────────────────
--  Page
-- ───────────────────────────────────────────────────────────────────────────
local Page={}; Page.__index=Page

function Page.new(scroll)
	local self=setmetatable({},Page); self._frame=scroll; self._order=0
	ListLayout(scroll,6); return self
end

function Page:_Row(h)
	self._order+=1
	return New("Frame",{
		BackgroundTransparency=1,Size=UDim2.new(1,0,0,h or 0),LayoutOrder=self._order,
		AutomaticSize = h and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
		Parent=self._frame})
end

-- Label
function Page:AddLabel(text,style)
	style=style or "header"
	local sz=({header=15,body=13,caption=11})[style] or 13
	local ck=({header="TEXT",body="TEXT_MUTED",caption="TEXT_SUBTLE"})[style] or "TEXT"
	local row=self:_Row(style=="header" and 24 or style == "normal" and 18 or nil)
	local lbl=New("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),
		Font=style=="header" and Enum.Font.GothamBold or Enum.Font.Gotham, AutomaticSize=Enum.AutomaticSize.Y,
		Text=text,TextSize=sz,TextColor3=C[ck],TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true,Parent=row})
	Skin(lbl,"TextColor3",ck); return self
end

-- Divider
function Page:AddDivider()
	local row=self:_Row(1)
	local f=New("Frame",{BackgroundColor3=C.BORDER,Size=UDim2.new(1,0,1,0),Parent=row})
	Skin(f,"BackgroundColor3","BORDER"); return self
end

-- Spacer
function Page:AddSpacer(h) self:_Row(h or 8); return self end

-- Button
function Page:AddButton(text,callback,style)
	style=style or "primary"
	local bgKey=({primary="ACCENT",secondary="ELEVATED",danger="DANGER"})[style] or "ACCENT"
	local row=self:_Row(38)
	local btn=New("TextButton",{BackgroundColor3=C[bgKey],Size=UDim2.new(1,0,1,0),
		Font=Enum.Font.GothamSemibold,Text=text,TextSize=13,TextColor3=C.WHITE,AutoButtonColor=false,Parent=row})
	Corner(btn,8); Skin(btn,"BackgroundColor3",bgKey); Skin(btn,"TextColor3","WHITE")
	if style=="secondary" then StrokeRaw(btn,C.BORDER,1); btn.TextColor3=C.TEXT; Skin(btn,"TextColor3","TEXT") end
	btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=style=="secondary" and C.HIGHLIGHT or C[bgKey]:Lerp(C.WHITE,0.12)}) end)
	btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=C[bgKey]}) end)
	btn.MouseButton1Down:Connect(function() Tween(btn,{Size=UDim2.new(0.98,0,0.92,0),Position=UDim2.new(0.01,0,0.04,0)},T_FAST) end)
	btn.MouseButton1Up:Connect(function()
		Tween(btn,{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0)},T_SPRING)
		if callback then task.spawn(callback) end
	end); return self
end

-- Toggle
function Page:AddToggle(text,default,callback)
	local state=default==true; local row=self:_Row(38)
	local lbl=New("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-58,1,0),Font=Enum.Font.Gotham,
		Text=text,TextSize=13,TextColor3=C.TEXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
	Skin(lbl,"TextColor3","TEXT")
	local track=New("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.new(0,46,0,24),
		BackgroundColor3=state and C.ACCENT or C.TOGGLE_OFF,Parent=row})
	Corner(track,12); Skin(track,"BackgroundColor3",state and "ACCENT" or "TOGGLE_OFF")
	local knob=New("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=state and UDim2.new(0,24,0.5,0) or UDim2.new(0,3,0.5,0),
		Size=UDim2.new(0,18,0,18),BackgroundColor3=C.WHITE,Parent=track})
	Corner(knob,9); Skin(knob,"BackgroundColor3","WHITE")
	New("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",Parent=row}).MouseButton1Click:Connect(function()
		state=not state
		Tween(track,{BackgroundColor3=state and C.ACCENT or C.TOGGLE_OFF})
		Tween(knob,{Position=state and UDim2.new(0,24,0.5,0) or UDim2.new(0,3,0.5,0)},T_MED)
		if callback then task.spawn(callback,state) end
	end); return self
end

-- Slider
function Page:AddSlider(text,min,max,default,callback)
	min=min or 0; max=max or 100; local v=math.clamp(default or min,min,max); local row=self:_Row(52)
	local tl=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0.65,0,0,20),
		Font=Enum.Font.Gotham,Text=text,TextSize=13,TextColor3=C.TEXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
	Skin(tl,"TextColor3","TEXT")
	local vl=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0.65,0,0,0),Size=UDim2.new(0.35,0,0,20),
		Font=Enum.Font.GothamBold,Text=tostring(math.floor(v)),TextSize=13,TextColor3=C.ACCENT,
		TextXAlignment=Enum.TextXAlignment.Right,Parent=row}); Skin(vl,"TextColor3","ACCENT")
	local tbg=New("Frame",{Position=UDim2.new(0,0,0,30),Size=UDim2.new(1,0,0,6),BackgroundColor3=C.SLIDER_BG,Parent=row})
	Corner(tbg,3); Skin(tbg,"BackgroundColor3","SLIDER_BG")
	local p0=(v-min)/(max-min)
	local fill=New("Frame",{Size=UDim2.new(p0,0,1,0),BackgroundColor3=C.ACCENT,Parent=tbg})
	Corner(fill,3); Skin(fill,"BackgroundColor3","ACCENT")
	local thumb=New("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(p0,0,0.5,0),
		Size=UDim2.new(0,16,0,16),BackgroundColor3=C.WHITE,Parent=tbg})
	Corner(thumb,8); Skin(thumb,"BackgroundColor3","WHITE")
	local ts=New("UIStroke",{Color=C.ACCENT,Thickness=2,Parent=thumb}); Skin(ts,"Color","ACCENT")
	local function setVal(x)
		local p=math.clamp((x-tbg.AbsolutePosition.X)/tbg.AbsoluteSize.X,0,1)
		v=math.floor(min+p*(max-min)); vl.Text=tostring(v)
		Tween(fill,{Size=UDim2.new(p,0,1,0)}); Tween(thumb,{Position=UDim2.new(p,0,0.5,0)})
		if callback then callback(v) end
	end
	local sliding=false
	New("TextButton",{BackgroundTransparency=1,Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,0,32),Text="",Parent=row}).MouseButton1Down:Connect(function()
		sliding=true; setVal(UserInputService:GetMouseLocation().X)
	end)
	UserInputService.InputChanged:Connect(function(inp) if sliding and inp.UserInputType==Enum.UserInputType.MouseMovement then setVal(inp.Position.X) end end)
	UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end end)
	return self
end

-- TextInput
function Page:AddTextInput(label,placeholder,callback)
	local row=self:_Row(56)
	local lbl=New("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,18),Font=Enum.Font.GothamSemibold,
		Text=label,TextSize=11,TextColor3=C.TEXT_MUTED,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
	Skin(lbl,"TextColor3","TEXT_MUTED")
	local frame=New("Frame",{Position=UDim2.new(0,0,0,22),Size=UDim2.new(1,0,0,34),BackgroundColor3=C.ELEVATED,Parent=row})
	Corner(frame,7); Skin(frame,"BackgroundColor3","ELEVATED")
	local sk=StrokeRaw(frame,C.BORDER,1); Skin(sk,"Color","BORDER")
	local box=New("TextBox",{BackgroundTransparency=1,Position=UDim2.new(0,10,0,0),Size=UDim2.new(1,-20,1,0),
		Font=Enum.Font.Gotham,PlaceholderText=placeholder or "",Text="",TextSize=13,TextColor3=C.TEXT,
		PlaceholderColor3=C.TEXT_SUBTLE,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,Parent=frame})
	Skin(box,"TextColor3","TEXT"); Skin(box,"PlaceholderColor3","TEXT_SUBTLE")
	box.Focused:Connect(function() Tween(sk,{Color=C.ACCENT}); Tween(frame,{BackgroundColor3=C.HIGHLIGHT}) end)
	box.FocusLost:Connect(function(enter)
		Tween(sk,{Color=C.BORDER}); Tween(frame,{BackgroundColor3=C.ELEVATED})
		if callback then callback(box.Text,enter) end
	end); return self
end

-- Dropdown
function Page:AddDropdown(label, options, callback)
	local selected = options[1] or ""
	local ITEM_H = 32
	local totalH = #options * ITEM_H + 8  -- added small padding

	local overlay = GetOverlay()
	local row = self:_Row(56)

	local lbl = New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		Font = Enum.Font.GothamSemibold,
		Text = label,
		TextSize = 11,
		TextColor3 = C.TEXT_MUTED,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row
	})
	Skin(lbl, "TextColor3", "TEXT_MUTED")

	local header = New("ImageButton", {
		Position = UDim2.new(0, 0, 0, 22),
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = C.ELEVATED,
		AutoButtonColor = false,
		Parent = row
	})
	Corner(header, 7)
	Skin(header, "BackgroundColor3", "ELEVATED")
	Stroke(header, C.BORDER, 1)

	local selLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -40, 1, 0),
		Font = Enum.Font.Gotham,
		Text = selected,
		TextSize = 13,
		TextColor3 = C.TEXT,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header
	})
	Skin(selLabel, "TextColor3", "TEXT")

	local arrow = New("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		Image = "http://www.roblox.com/asset/?id=6031091004",
		ImageColor3 = C.TEXT_MUTED,
		Parent = header
	})
	Skin(arrow, "ImageColor3", "TEXT_MUTED")

	local listFrame = New("Frame", {
		Size = UDim2.new(0, 1, 0, 0),
		BackgroundColor3 = C.ELEVATED,
		ZIndex = 501,
		ClipsDescendants = true,
		Visible = false,
		Parent = overlay
	})
	Corner(listFrame, 7)
	Skin(listFrame, "BackgroundColor3", "ELEVATED")
	Stroke(listFrame, C.BORDER, 1)
	ListLayout(listFrame, 0)
	local dd = {open = false, listFrame = listFrame}
	dd.closeFn = function()
		if not dd.open then return end
		dd.open = false
		local w = listFrame.AbsoluteSize.X
		Tween(listFrame, {Size = UDim2.new(0, w, 0, 0)}, T_MED)
		Tween(arrow, {Rotation = 0}, T_MED)
		task.delay(0.32, function()
			if not dd.open then listFrame.Visible = false end
		end)
	end
	for i, opt in ipairs(options) do
		local ob = New("TextButton", {
			BackgroundColor3 = C.ELEVATED,
			Size = UDim2.new(1, 0, 0, ITEM_H),
			Font = Enum.Font.Gotham,
			Text = opt,
			TextSize = 13,
			TextColor3 = C.TEXT,
			AutoButtonColor = false,
			ZIndex = 502,
			LayoutOrder = i,
			Parent = listFrame
		})
		Pad(ob, 0, 10, 0, 10)
		Skin(ob, "BackgroundColor3", "ELEVATED")
		Skin(ob, "TextColor3", "TEXT")

		ob.MouseEnter:Connect(function() Tween(ob, {BackgroundColor3 = C.HIGHLIGHT}) end)
		ob.MouseLeave:Connect(function() Tween(ob, {BackgroundColor3 = C.ELEVATED}) end)
		
		ob.Activated:Connect(function()
			selected = opt
			selLabel.Text = opt
			if callback then task.spawn(callback, opt) end
			dd.closeFn()
		end)
	end
	table.insert(_dropdowns, dd)
	-- Header Click
	header.MouseButton1Click:Connect(function()
		if dd.open then 
			dd.closeFn()
			return 
		end
		BringToFront(header.Parent.Parent)
		CloseAllDropdowns(dd)
		local ap, as = header.AbsolutePosition, header.AbsoluteSize
		listFrame.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 4)
		listFrame.Size = UDim2.new(0, as.X, 0, 0)
		listFrame.Visible = true
		dd.open = true
		
		Tween(listFrame, {Size = UDim2.new(0, as.X, 0, totalH)}, T_MED)
		Tween(arrow, {Rotation = 180}, T_MED)
	end)
	
	game.RunService.RenderStepped:Connect(function()
		if not dd.open then return end
		local ap,as=header.AbsolutePosition,header.AbsoluteSize
		listFrame.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 4)
	end)
	return self
end

-- ColorPicker
function Page:AddColorPicker(label,default,callback)
	default=default or Color3.fromRGB(99,102,241); local row=self:_Row(48)
	local lbl=New("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(0.6,0,1,0),Font=Enum.Font.Gotham,
		Text=label,TextSize=13,TextColor3=C.TEXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
	Skin(lbl,"TextColor3","TEXT")
	local preview=New("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),
		Size=UDim2.new(0,30,0,30),BackgroundColor3=default,Parent=row}); Corner(preview,6); StrokeRaw(preview,C.BORDER,1)
	local strip=New("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-38,0.5,0),
		Size=UDim2.new(0,100,0,10),BackgroundColor3=C.WHITE,Parent=row}); Corner(strip,5)
	local kps={}; for i=0,6 do table.insert(kps,ColorSequenceKeypoint.new(i/6,Color3.fromHSV(i/6,1,1))) end
	New("UIGradient",{Color=ColorSequence.new(kps),Parent=strip})
	local ind=New("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),
		Size=UDim2.new(0,10,0,10),BackgroundColor3=C.WHITE,Parent=strip}); Corner(ind,5); StrokeRaw(ind,C.BORDER,1)
	local sliding=false
	local function updateHue(x)
		local p=math.clamp((x-strip.AbsolutePosition.X)/strip.AbsoluteSize.X,0,1)
		local col=Color3.fromHSV(p,1,1); Tween(preview,{BackgroundColor3=col}); Tween(ind,{Position=UDim2.new(p,0,0.5,0)})
		if callback then callback(col) end
	end
	New("TextButton",{BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-38,0.5,0),
		Size=UDim2.new(0,100,0,24),Text="",Parent=row}).MouseButton1Down:Connect(function()
		sliding=true; updateHue(UserInputService:GetMouseLocation().X)
	end)
	UserInputService.InputChanged:Connect(function(inp) if sliding and inp.UserInputType==Enum.UserInputType.MouseMovement then updateHue(inp.Position.X) end end)
	UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end end)
	return self
end

-- ───────────────────────────────────────────────────────────────────────────
--  Window
-- ───────────────────────────────────────────────────────────────────────────
local Window={}; Window.__index=Window

function Window.new(config)
	config=config or {}
	local W=config.Size and config.Size.X.Offset or 620
	local H=config.Size and config.Size.Y.Offset or 460
	local sg=GetSG()
	local self=setmetatable({_W=W,_H=H,_pages={},_activePage=nil,_minimized=false,
		_title=config.Title or "Modern UI",_icon=config.Icon or "",_taskbarBtn=nil,_activeTheme="Dark"},Window)

	local root=New("Frame",{Position=UDim2.fromOffset(sg.AbsoluteSize.X/2-W/2,sg.AbsoluteSize.Y/2-H/2),
		Size=UDim2.new(0,W,0,H),BackgroundColor3=C.BG,ZIndex=2,ClipsDescendants=true,Parent=sg})
	root.ZIndex = GetNextZIndex()
	Corner(root,12); Skin(StrokeRaw(root,C.BORDER,1), "Color", "BORDER"); Skin(root,"BackgroundColor3","BG"); self._root=root

	-- Titlebar
	local tb=New("Frame",{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1,ZIndex=10,Parent=root})
	local titleX=14
	local ic=self._icon
	if ic and ic~="" then
		if IsImageId(ic) then
			Skin(New("ImageLabel",{BackgroundTransparency=1,Position=UDim2.new(0,14,0.5,0),AnchorPoint=Vector2.new(0,0.5),
				Size=UDim2.new(0,20,0,20),Image=ic,ZIndex=11,Parent=tb}), "ImageColor3", "ACCENT")
		else
			local il=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,14,0.5,0),AnchorPoint=Vector2.new(0,0.5),
				Size=UDim2.new(0,22,0,22),Font=Enum.Font.GothamBold,Text=ic,TextSize=16,TextColor3=C.ACCENT,
				TextXAlignment=Enum.TextXAlignment.Center,ZIndex=11,Parent=tb}); Skin(il,"TextColor3","ACCENT")
		end; titleX=42
	end
	local tl=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,titleX,0,2),Size=UDim2.new(0.65,0,1,0),
		Font=Enum.Font.GothamBold,Text=self._title,TextSize=15,TextColor3=C.TEXT,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11,Parent=tb})
	Skin(tl,"TextColor3","TEXT")

	local function WinBtn(xOff,bg,lbl)
		local b
		if IsImageId(lbl) then
			b=New("ImageButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,xOff,0.5,1),Size=UDim2.new(0,28,0,28),
				BackgroundColor3=bg,Image=lbl,AutoButtonColor=false,ZIndex=11,Parent=tb})
		else
			b=New("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,xOff,0.5,1),Size=UDim2.new(0,28,0,28),
				BackgroundColor3=bg,Font=Enum.Font.GothamBold,Text=lbl,TextSize=12,TextColor3=C.WHITE,AutoButtonColor=false,ZIndex=11,Parent=tb})
		end
		Corner(b,6)
		return b
	end

	local closeBtn=WinBtn(-12,Color3.fromRGB(239,68,68),"rbxassetid://6031094678"); local minBtn=WinBtn(-46,Color3.fromRGB(115,115,115),"rbxassetid://6034925610")
	Skin(closeBtn, "BackgroundColor3", "ACCENT")
	Skin(closeBtn, "ImageColor3", "WHITE")
	
	Skin(minBtn, "BackgroundColor3", "ACCENT2")
	Skin(minBtn, "ImageColor3", "WHITE")
	
	closeBtn.MouseEnter:Connect(function()
		Tween(closeBtn,{BackgroundColor3=C.ACCENT:Lerp(C.WHITE, 0.5)})
	end)
	closeBtn.MouseLeave:Connect(function()
		local c = C.ACCENT
		Tween(closeBtn,{BackgroundColor3=c})
	end)
	closeBtn.MouseButton1Click:Connect(function() self:Hide() end)

	minBtn.MouseEnter:Connect(function()
		Tween(minBtn,{BackgroundColor3=C.ACCENT2:Lerp(C.WHITE, 0.5)})
	end)
	minBtn.MouseLeave:Connect(function()
		Tween(minBtn,{BackgroundColor3=C.ACCENT2})
	end)
	minBtn.MouseButton1Click:Connect(function() self:Minimize() end)
	
	MakeDraggable(root,tb,true)

	local SW=164
	local sidebar=New("Frame",{Position=UDim2.new(0,0,0,44),Size=UDim2.new(0,SW,1,-44),
		BackgroundTransparency=1,ZIndex=3,Parent=root})
	Skin(StrokeRaw(sidebar,C.BORDER,1), "Color", "BORDER"); ListLayout(sidebar,2); Pad(sidebar,8,6,8,6)
	self._sidebar=sidebar; self._SW=SW
	self._contentArea=New("Frame",{Position=UDim2.new(0,SW,0,44),Size=UDim2.new(1,-SW,1,-44),
		BackgroundTransparency=1,ZIndex=3,Parent=root})
	Skin(StrokeRaw(self._contentArea,C.BORDER,1), "Color", "BORDER")
	
	self:Hide()
	return self
end

-- ── ApplyTheme ──────────────────────────────────────────────────────────────
function Window:ApplyTheme(name)
	local theme=THEMES[name]
	if not theme then warn("ModernUI: unknown theme '"..tostring(name).."'") return end
	self._activeTheme=name
	for key,col in pairs(theme.palette) do C[key]=col end
	local dead={}
	for i,e in ipairs(_skinReg) do
		local ok = pcall(function()
			if e.inst and e.inst.Parent then
				if e.prop == "__GRADIENT" then
					Tween(e.inst, {
						Color = ColorSequence.new(C[e.key0], C[e.key1])
					}, T_THEME)
				else
					Tween(e.inst, {
						[e.prop] = C[e.key]
					}, T_THEME)
				end
			else
				table.insert(dead, i)
			end
		end)

		if not ok then
			table.insert(dead, i)
		end
	end
	for i=#dead,1,-1 do table.remove(_skinReg,dead[i]) end
end

-- ── AddThemePage ────────────────────────────────────────────────────────────
function Window:AddThemePage(iconText, overrideText)
	local page=self:AddPage(overrideText or "Themes", iconText or "rbxassetid://6031572320", #self._pages < 98 and 98)
	page:AddLabel("Choose a Theme")
	page:AddDivider()
	page:AddSpacer(6)

	local cards={}  -- [name] = { card, stroke, badge }

	for _, name in ipairs(THEME_ORDER) do
		local theme   = THEMES[name]
		local isActive = (name == self._activeTheme)
		local row      = page:_Row(72)

		local card=New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=C.ELEVATED,ZIndex=5,ClipsDescendants=true,Parent=row})
		Corner(card,10); Skin(card,"BackgroundColor3","ELEVATED")

		local cardStroke=New("UIStroke",{Color=isActive and C.ACCENT or C.BORDER,
			Thickness=isActive and 2 or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=card})
		-- Don't register stroke in skin reg — we manage it manually per card state

		-- Two-tone swatch
		local swatch=New("Frame",{Position=UDim2.new(0,10,0.5,0),AnchorPoint=Vector2.new(0,0.5),
			Size=UDim2.new(0,44,0,44),BackgroundColor3=theme.preview[1],ZIndex=6,ClipsDescendants=true,Parent=card})
		Corner(swatch,9)
		New("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,0),Size=UDim2.new(0.5,0,1,0),
			BackgroundColor3=theme.preview[2],ZIndex=7,Parent=swatch})

		-- Name
		local nameLbl=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,64,0,12),Size=UDim2.new(1,-130,0,20),
			Font=Enum.Font.GothamBold,Text=name,TextSize=14,TextColor3=C.TEXT,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=card})
		Skin(nameLbl,"TextColor3","TEXT")

		-- Desc
		local descLbl=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,64,0,34),Size=UDim2.new(1,-130,0,16),
			Font=Enum.Font.Gotham,Text=theme.desc,TextSize=11,TextColor3=C.TEXT_MUTED,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=card})
		Skin(descLbl,"TextColor3","TEXT_MUTED")

		-- Active badge
		local badge=New("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),
			Size=isActive and UDim2.new(0,56,0,22) or UDim2.new(0,0,0,22),
			BackgroundColor3=C.ACCENT,ZIndex=6,ClipsDescendants=true,Parent=card})
		Corner(badge,11); Skin(badge,"BackgroundColor3","ACCENT")
		Skin(New("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Font=Enum.Font.GothamBold,
			Text="Active",TextSize=11,TextColor3=C.WHITE,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=7,Parent=badge}),
			"TextColor3","WHITE")

		card.MouseEnter:Connect(function()
			if name~=self._activeTheme then Tween(card,{BackgroundColor3=C.HIGHLIGHT}) end
		end)
		card.MouseLeave:Connect(function()
			if name~=self._activeTheme then Tween(card,{BackgroundColor3=C.ELEVATED}) end
		end)

		local hitBtn=New("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",ZIndex=8,Parent=card})
		cards[name]={card=card,stroke=cardStroke,badge=badge}

		hitBtn.MouseButton1Click:Connect(function()
			if name==self._activeTheme then return end
			-- Deactivate previous
			local prev=cards[self._activeTheme]
			if prev then
				Tween(prev.badge,{Size=UDim2.new(0,0,0,22)},T_MED)
				Tween(prev.stroke,{Color=C.BORDER},T_MED)
				prev.stroke.Thickness=1
			end
			-- Apply (mutates C)
			self:ApplyTheme(name)
			-- Activate this card
			Tween(badge,{Size=UDim2.new(0,56,0,22)},T_SPRING)
			Tween(cardStroke,{Color=C.ACCENT},T_MED)
			cardStroke.Thickness=2
		end)
	end

	return page
end

-- ── AddInfoPage ────────────────────────────────────────────────────────────
function Window:AddInfoPage(iconText, overrideText)
	local p = self:AddPage(overrideText or "About", iconText or "rbxassetid://6026568210", #self._pages < 99 and 99)
	
	p:AddSpacer(4)

	p:AddLabel("NexUI", "header")
	p:AddLabel("A sleek modular Roblox interface framework designed for modern experiences.", "body")

	p:AddSpacer(10)
	p:AddDivider()
	p:AddSpacer(10)

	p:AddLabel("Framework Information", "header")

	p:AddLabel("Version: v2.2-stable", "body")
	p:AddLabel("Release: 2026/5", "body")
	p:AddLabel("Author: @F0rgott3nJakey", "body")

	p:AddSpacer(8)

	p:AddLabel(
		"NexUI includes live theme switching, animated components, taskbar support, draggable windows, dropdown overlays, and a scalable skin registry system.",
		"caption"
	)

	p:AddSpacer(14)
	p:AddDivider()
	p:AddSpacer(10)

	p:AddLabel("Features", "header")

	p:AddLabel("• Live theme engine", "body")
	p:AddLabel("• Smooth tweens & animations", "body")
	p:AddLabel("• Modular page system", "body")
	p:AddLabel("• Dropdown & color picker support", "body")
	p:AddLabel("• Responsive taskbar windows", "body")
	p:AddLabel("• Mono / OLED / Catppuccin themes", "body")

	p:AddSpacer(14)
	p:AddDivider()
	p:AddSpacer(10)

	p:AddLabel("Credits", "header")

	p:AddLabel("UI Framework & Design", "body")
	p:AddLabel("Made with Luau & Roblox Studio", "caption")
end

-- ── AddPage ─────────────────────────────────────────────────────────────────
function Window:AddPage(name, iconText, layoutOverride)
	local btn=New("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=C.SIDEBAR,AutoButtonColor=false,
		Text="",ZIndex=4,LayoutOrder=layoutOverride or #self._pages+1,Parent=self._sidebar})
	Corner(btn,7); Skin(btn,"BackgroundColor3","SIDEBAR")
	local pill=New("Frame",{Size=UDim2.new(0,3,0.7,0),Position=UDim2.new(0,0,0.15,0),BackgroundColor3=C.ACCENT,
		Visible=false,ZIndex=5,Parent=btn}); Corner(pill,2); Skin(pill,"BackgroundColor3","ACCENT")
	
	iconText = tostring(iconText or "rbxassetid://6023426962")
	local iconLbl
	
	if IsImageId(iconText) then
		iconLbl=New("ImageLabel",{BackgroundTransparency=1,Position=UDim2.new(0,8,0.5,0),Size=UDim2.new(0,26,1,0),
			Image=iconText,AnchorPoint=Vector2.new(0,0.5),ZIndex=5,Parent=btn})
		Skin(iconLbl, "ImageColor3", "ACCENT")
		New("UIAspectRatioConstraint", {Parent = iconLbl})
	else
		iconLbl=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,8,0,0),Size=UDim2.new(0,26,1,0),
			Font=Enum.Font.GothamBold,Text=iconText,TextSize=14,TextColor3=C.TEXT_MUTED,ZIndex=5,Parent=btn})
		Skin(iconLbl,"TextColor3","TEXT_MUTED")
	end
	
	local nameLabel=New("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,36,0,0),Size=UDim2.new(1,-42,1,0),
		Font=Enum.Font.GothamSemibold,Text=name,TextSize=13,TextColor3=C.TEXT_MUTED,
		TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,Parent=btn}); Skin(nameLabel,"TextColor3","TEXT_MUTED")
	local scroll=New("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ScrollBarThickness=0,
		BorderSizePixel=0,Visible=false,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
		ZIndex=4,Parent=self._contentArea}); Pad(scroll,14,14,14,14)
	local pageObj=Page.new(scroll)
	local entry={button=btn,nameLabel=nameLabel,pill=pill,frame=scroll,pageObj=pageObj}
	table.insert(self._pages,entry); self._pages[name]=entry
	btn.MouseEnter:Connect(function()
		if self._activePage~=name then Tween(btn,{BackgroundColor3=C.HIGHLIGHT}); Tween(nameLabel,{TextColor3=C.TEXT}) end
	end)
	btn.MouseLeave:Connect(function()
		if self._activePage~=name then Tween(btn,{BackgroundColor3=C.SIDEBAR}); Tween(nameLabel,{TextColor3=C.TEXT_MUTED}) end
	end)
	btn.MouseButton1Click:Connect(function() self:SelectPage(name) end)
	return pageObj
end

function Window:SelectPage(name)
	task.defer(function() CloseAllDropdowns(nil) end)
	for pn,entry in pairs(self._pages) do
		if type(pn)=="string" then
			local active=pn==name; entry.frame.Visible=active; entry.pill.Visible=active
			if active then
				Tween(entry.button,{BackgroundColor3=C.HIGHLIGHT}); Tween(entry.nameLabel,{TextColor3=C.TEXT})
			else
				Tween(entry.button,{BackgroundColor3=C.SIDEBAR}); Tween(entry.nameLabel,{TextColor3=C.TEXT_MUTED})
			end
		end
	end; self._activePage=name
end

function Window:Show()
	self._root.Visible=true; self._root.Size=UDim2.new(0,0,0,0)
	self._sidebar.Visible=true
	Tween(self._root,{Size=UDim2.new(0,self._W,0,self._H)},T_SPRING)
end

function Window:Hide()
	task.defer(function() CloseAllDropdowns(nil) end)
	Tween(self._root,{Size=UDim2.new(0,0,0,0)},T_MED)
	task.delay(0.32,function() self._root.Visible=false end)
	if self._taskbarBtn and self._taskbarBtn.Parent then self._taskbarBtn:Destroy(); self._taskbarBtn=nil end
	self._taskbarBtn=CreateTaskbarButton(self._title,self._icon,function()
		self._taskbarBtn=nil; self:Show()
	end)
end

function Window:Minimize()
	local v0=self._minimized
	if self._minimized then
		Tween(self._root,{Size=UDim2.new(0,self._W,0,self._H)},T_SPRING); self._minimized=false
	else
		Tween(self._root,{Size=UDim2.new(0,220,0,44)},T_MED); self._minimized=true
	end
	task.delay(0.15,function() self._sidebar.Visible=v0 end)
end

function Window:Destroy()
	task.defer(function() CloseAllDropdowns(nil) end)
	if self._taskbarBtn and self._taskbarBtn.Parent then self._taskbarBtn:Destroy() end
	self._root:Destroy()
end

-- ───────────────────────────────────────────────────────────────────────────
return { new = function(cfg) return Window.new(cfg) end }
