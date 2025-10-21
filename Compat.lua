BigDebuffsAddonName = "BigDebuffs"
BigDebuffsAddon = BigDebuffsAddon or {}

WOW_PROJECT_ID = 2
WOW_PROJECT_ID_RCE = 2
WOW_PROJECT_CLASSIC = 2

function C_GetSpellInfo(spellId)
    local name = SpellInfo(spellId)
    return name or "spell " .. spellId
end

function C_GetSpellTexture(spellId)
    local _, _, texture = SpellInfo(spellId)
    return texture
end

function C_IsUsableSpell(name)
    return false
end

C_Spell = {}
C_Spell.cache = {}

function C_Spell:CreateFromSpellID(spellId)
    if not self.cache[spellId] then
        local spell = {}
        setmetatable(spell, { __index = C_Spell })
        self.cache[spellId] = spell
    end
    
    return self.cache[spellId]
end

function C_Spell:GetSpellDescription()
    return ""
end

function C_InCombatLockdown()
    return false
end

function C_UnitGUID(unit)
    local _, GUID = UnitExists(unit)
    return GUID
end

function C_UnitDebuff(unit, index, showDispellable)
    local texture, applications, type, id = UnitDebuff(unit, index, showDispellable)
    local name, rank, _, minrange, maxrange = SpellInfo(id)
    local duration, expire = 0, 0
    local caster, steal, consolidate = nil, nil, nil

    return name, texture, applications, type, duration, expire, caster, steal, consolidate, id
end

function C_UnitBuff(unit, index, showCastable)
    local texture, applications, id = UnitBuff(unit, index, showCastable)
    local name, rank, _, minrange, maxrange = SpellInfo(id)
    local duration, expire = 0, 0
    local type, caster, steal, consolidate = nil, nil, nil, nil

    return name, texture, applications, type, duration, expire, caster, steal, consolidate, id
end

function C_UnitAura(a1, a2, a3, a4)
    print("C_UnitAura", a1, a2, a3, a4)
end

function C_IsPlayerSpell(spellId)
     print("C_IsPlayerSpell", spellId)
    return false -- TODO
end

function C_IsMouseOver(frame)
    local x, y = GetCursorPosition()
    local scale = frame:GetEffectiveScale()
    local left = frame:GetLeft()
    local right = frame:GetRight()
    local top = frame:GetTop()
    local bottom = frame:GetBottom()

    x, y = x / scale, y / scale
    
    return x >= left and x <= right and y >= bottom and y <= top
end

function C_CooldownFrame_Set(frame, start, duration, enable)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
        frame.startReversed = start
        frame.durationReversed = duration
        frame:Show()
	else
		frame:Hide()
	end
end

function C_CooldownFrame_Clear(frame)
	frame:Hide()
end

function C_CooldownFrame_OnUpdateModelReversed()
    local finished = (GetTime() - this.startReversed) / this.durationReversed
    if finished < 1.0 then
        local time = (1 - finished) * 1000
        this:SetSequenceTime(0, time)
        return
    end
    this:Hide()
end

-- Timer
local _G = _G

local C_Timer = TimerFrame or CreateFrame("Frame", "TimerFrame")

function C_Timer.After(arg1, arg2, arg3)
end
function C_Timer.NewTimer(arg1, arg2, arg3)
end
function C_Timer.NewTicker(arg1, arg2, arg3)
end

_G.C_Timer = C_Timer

COMBATLOG_OBJECT_AFFILIATION_MINE = tonumber("00000001", 16)
COMBATLOG_OBJECT_REACTION_FRIENDLY = tonumber("00000010", 16)
COMBATLOG_OBJECT_CONTROL_PLAYER = tonumber("00000100", 16)
COMBATLOG_OBJECT_TYPE_PLAYER = tonumber("00000400", 16)
