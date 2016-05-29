local acutil = {};

function acutil.addThousandsSeparator(amount)
	local formatted = amount

	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
			break
		end
	end

	return formatted
end

function acutil.leftPad(str, len, char)
	if char == nil then
		char = ' '
	end

	return string.rep(char, len - #str) .. str
end

function acutil.rightPad(str, len, char)
	if char == nil then
		char = ' '
	end

	return str .. string.rep(char, len - #str)
end

function acutil.getStatPropertyFromPC(typeStr, statStr, pc)
    local errorText = "Param was nil";

    if typeStr ~= nil and statStr ~= nil and pc ~= nil then

        if typeStr == "JOB" then
            if statStr == "STR" then
                return pc.STR_JOB;
            elseif statStr == "DEX" then
                return pc.DEX_JOB;
            elseif statStr == "CON" then
                return pc.CON_JOB;
            elseif statStr == "INT" then
                return pc.INT_JOB;
            elseif statStr == "MNA" then
                return pc.MNA_JOB;
            elseif statStr == "LUCK" then
                return pc.LUCK_JOB;
            else
                errorText = "Could not find stat "..statStr.." for type "..typeStr;
            end

        elseif typeStr == "STAT" then
            if statStr == "STR" then
                return pc.STR_STAT;
            elseif statStr == "DEX" then
                return pc.DEX_STAT;
            elseif statStr == "CON" then
                return pc.CON_STAT;
            elseif statStr == "INT" then
                return pc.INT_STAT;
            elseif statStr == "MNA" then
                return pc.MNA_STAT;
            elseif statStr == "LUCK" then
                return pc.LUCK_STAT;
            else
                errorText = "Could not find stat "..statStr.." for type "..typeStr;
            end

        elseif typeStr == "BONUS" then
            if statStr == "STR" then
                return pc.STR_Bonus;
            elseif statStr == "DEX" then
                return pc.DEX_Bonus;
            elseif statStr == "CON" then
                return pc.CON_Bonus;
            elseif statStr == "INT" then
                return pc.INT_Bonus;
            elseif statStr == "MNA" then
                return pc.MNA_Bonus;
            else
                errorText = "Could not find stat "..statStr.." for type "..typeStr;
            end

        elseif typeStr == "ADD" then
            if statStr == "STR" then
                return pc.STR_ADD;
            elseif statStr == "DEX" then
                return pc.DEX_ADD;
            elseif statStr == "CON" then
                return pc.CON_ADD;
            elseif statStr == "INT" then
                return pc.INT_ADD;
            elseif statStr == "MNA" then
                return pc.MNA_ADD;
            elseif statStr == "LUCK" then
                return pc.LUCK_ADD;
            else
                errorText = "Could not find stat "..statStr.." for type "..typeStr;
            end

        elseif typeStr == "BM" then
            if statStr == "STR" then
                return pc.STR_BM;
            elseif statStr == "DEX" then
                return pc.DEX_BM;
            elseif statStr == "CON" then
                return pc.CON_BM;
            elseif statStr == "INT" then
                return pc.INT_BM;
            elseif statStr == "MNA" then
                return pc.MNA_BM;
            elseif statStr == "LUCK" then
                return pc.LUCK_BM;
            else
                errorText = "Could not find stat "..statStr.." for type "..typeStr;
            end

        else
            errorText = "Could not find a property for type "..typeStr;
        end
    end

    ui.SysMsg(errorText);
    return 0;
end

function acutil.isValidStat(statStr, includeLuck)
    if statStr == "LUCK" then
        return includeLuck;
    elseif statStr == "STR" or
           statStr == "DEX" or
           statStr == "CON" or
           statStr == "INT" or
           statStr == "MNA" then
        return true;
    end

    return false;
end

function acutil.textControlFactory(attributeName, isMainSection)
    local text = "";

    if attributeName == "MNA" then
        attributeName = "SPR"
    elseif attributeName == "MountDEF" then
        attributeName = "physical defense"
    elseif attributeName == "MountDR" then
        attributeName = "evasion"
    elseif attributeName == "MountMHP" then
        attributeName = "max HP"
    end

    if isMainSection then
        text = "Points invested in " .. attributeName;
    else
        text = "Mounted " .. attributeName .. " bonus";
    end
    return text;
end

function acutil.getItemRarityColor(itemObj)
    local itemProp = geItemTable.GetProp(itemObj.ClassID);
    local grade = itemObj.ItemGrade;

    if (itemObj.ItemType == "Recipe") then
        local recipeGrade = string.match(itemObj.Icon, "misc(%d)");
        if recipeGrade ~= nil then
            grade = tonumber(recipeGrade) - 1;
        end
    end

    if (itemProp.setInfo ~= nil) then return "00FF00"; -- set piece
    elseif (grade == 0) then return "FFBF33"; -- premium
    elseif (grade == 1) then return "FFFFFF"; -- common
    elseif (grade == 2) then return "108CFF"; -- rare
    elseif (grade == 3) then return "9F30FF"; -- epic
    elseif (grade == 4) then return "FF4F00"; -- legendary
    else then return "E1E1E1"; -- no grade (non-equipment items)
end

function acutil.setupHook(newFunction, hookedFunctionStr)
	local storeOldFunc = hookedFunctionStr .. "_OLD";
	if _G[storeOldFunc] == nil then
		_G[storeOldFunc] = _G[hookedFunctionStr];
		_G[hookedFunctionStr] = newFunction;
	else
		_G[hookedFunctionStr] = newFunction;
	end
end

_G['ADDONS'] = _G['ADDONS'] or {};
_G['ADDONS']['EVENTS'] = _G['ADDONS']['EVENTS'] or {};
_G['ADDONS']['EVENTS']['ARGS'] = _G['ADDONS']['EVENTS']['ARGS'] or {};

function acutil.setupEvent(myAddon, functionNameAbs, myFunctionName)
	local functionName = string.gsub(functionNameAbs, "%.", "");

	if _G['ADDONS']['EVENTS'][functionName .. "_OLD"] == nil then
		_G['ADDONS']['EVENTS'][functionName .. "_OLD"] = loadstring("return " .. functionNameAbs)();
	end

	local hookedFuncString = functionNameAbs ..[[ = function(...)
		local function pack2(...) return {n=select('#', ...), ...} end
		local thisFuncName = "]]..functionName..[[";
		local result = pack2(pcall(_G['ADDONS']['EVENTS'][thisFuncName .. '_OLD'], ...));
		_G['ADDONS']['EVENTS']['ARGS'][thisFuncName] = {...};
		imcAddOn.BroadMsg(thisFuncName);
		return unpack(result, 2, result.n);
	end
	]];

	pcall(loadstring(hookedFuncString));

	myAddon:RegisterMsg(functionName, myFunctionName);
end

function acutil.getEventArgs(eventMsg)
	return unpack(_G['ADDONS']['EVENTS']['ARGS'][eventMsg]);
end

--TODO: turn into addon popup menu
function SYSMENU_CHECK_HIDE_VAR_ICONS_HOOKED(frame)
	if false == VARICON_VISIBLE_STATE_CHANTED(frame, "necronomicon", "necronomicon")
	and false == VARICON_VISIBLE_STATE_CHANTED(frame, "grimoire", "grimoire")
	and false == VARICON_VISIBLE_STATE_CHANTED(frame, "guild", "guild")
	and false == VARICON_VISIBLE_STATE_CHANTED(frame, "poisonpot", "poisonpot")
	then
		return;
	end

	DESTROY_CHILD_BY_USERVALUE(frame, "IS_VAR_ICON", "YES");

	local status = frame:GetChild("status");
	local inven = frame:GetChild("inven");
	local offsetX = inven:GetX() - status:GetX();
	local startX = status:GetMargin().left - offsetX;

	startX = SYSMENU_CREATE_VARICON(frame, status, "guild", "guild", "sysmenu_guild", startX, offsetX, "Guild");
	startX = SYSMENU_CREATE_VARICON(frame, status, "necronomicon", "necronomicon", "sysmenu_card", startX, offsetX);
	startX = SYSMENU_CREATE_VARICON(frame, status, "grimoire", "grimoire", "sysmenu_neacro", startX, offsetX);
	startX = SYSMENU_CREATE_VARICON(frame, status, "poisonpot", "poisonpot", "sysmenu_wugushi", startX, offsetX);
	startX = SYSMENU_CREATE_VARICON(frame, status, "poisonpot", "poisonpot", "sysmenu_wugushi", startX, offsetX);
	startX = SYSMENU_CREATE_VARICON(frame, status, "expcardcalculator", "expcardcalculator", "addonmenu_expcard", startX, offsetX, "Experience Card Calculator");
	startX = SYSMENU_CREATE_VARICON(frame, status, "developerconsole", "developerconsole", "addonmenu_dev", startX, offsetX, "Developer Console");

	local expcardcalculatorButton = GET_CHILD(frame, "expcardcalculator", "ui::CButton");
	if expcardcalculatorButton ~= nil then
		expcardcalculatorButton:SetTextTooltip("{@st59}Experience Card Calculator");
	end

	local developerconsoleButton = GET_CHILD(frame, "developerconsole", "ui::CButton");
	if developerconsoleButton ~= nil then
		developerconsoleButton:SetTextTooltip("{@st59}Developer Console");
	end
end

acutil.setupHook(SYSMENU_CHECK_HIDE_VAR_ICONS_HOOKED, "SYSMENU_CHECK_HIDE_VAR_ICONS");

local sysmenuFrame = ui.GetFrame("sysmenu");
SYSMENU_CHECK_HIDE_VAR_ICONS(sysmenuFrame);

return acutil;
