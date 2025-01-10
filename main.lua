local mod = RegisterMod("BROMITA", 1)

include("apioverride")

mod.Fortunes =
[==============================[
Marry and reproduce

Marry and reproduce

Marry and reproduce

Marry and reproduce

Marry and reproduce

Marry and reproduce

Marry and reproduce

rayo75.dev
/nasty
/marryandreproduce
]==============================]

local function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
      table.insert(Table,cap)
       end
       last_end = e+1
       s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
       cap = pString:sub(last_end)
       table.insert(Table, cap)
    end
    return Table
end

local function fortuneArray(array)
    Game():GetHUD():ShowFortuneText(
        array[1], 
        array[2] or nil, 
        array[3] or nil, 
        array[4] or nil, 
        array[5] or nil, 
        array[6] or nil, 
        array[7] or nil, 
        array[8] or nil, 
        array[9] or nil, 
        array[10] or nil
    )
end

function mod:ShowFortune(forcedtune)
    if forcedtune then
        local fortune = split(forcedtune, "\n")
        fortuneArray(fortune)
    else
        mod.FortuneTable = mod.FortuneTable or {}
        if #mod.FortuneTable <= 1 then
            local fortunelist = mod.Fortunes
            local fortunetablesetup = split(mod.Fortunes, "\n\n")
            for i = 1, #fortunetablesetup do
                table.insert(mod.FortuneTable, split(fortunetablesetup[i], "\n"))
            end
        end
        local choice = math.random(#mod.FortuneTable)
        local fortune = mod.FortuneTable[choice]
        fortuneArray(fortune)
    end
end

function mod:checkFortuneMachine()
	local totalFortune = Isaac.FindByType(EntityType.ENTITY_SLOT, 3)
	if #totalFortune > 0 then
		for _, fortuneMachine in ipairs(totalFortune) do
			local sprite = fortuneMachine:GetSprite()
			if sprite:IsPlaying("Prize") then
				if sprite:GetFrame() == 4 then
					local pickupFound
					for _, pickup in pairs(Isaac.FindByType(5, -1, -1)) do
						if pickup and pickup.Type == 5 and pickup.FrameCount <= 0 then
							pickupFound = true
						end
					end
					if not pickupFound then
						mod:ShowFortune()
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.checkFortuneMachine)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	local pickupFound
	for _, pickup in pairs(Isaac.FindByType(5, -1, -1)) do
		if pickup and pickup.Type == 5 and pickup.FrameCount <= 0 then
			pickupFound = true
		end
	end
	if not pickupFound then
		mod:ShowFortune()
	end
end, CollectibleType.COLLECTIBLE_FORTUNE_COOKIE)

APIOverride.OverrideClassFunction(Game, "ShowFortune", function()
	mod:ShowFortune()
	return
end)