local acutil = {};
local json = require('json');

_G['ADDONS'] = _G['ADDONS'] or {};
_G['ADDONS']['EVENTS'] = _G['ADDONS']['EVENTS'] or {};
_G['ADDONS']['EVENTS']['ARGS'] = _G['ADDONS']['EVENTS']['ARGS'] or {};

-- ================================================================
-- Strings
-- ================================================================

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

function acutil.tostring(var) 
    if (var == nil) then return 'nil'; end  
    local tp = type(var); 
    if (tp == 'string' or tp == 'number') then 
        return var; 
    end
    if (tp == 'boolean') then 
        if (var) then 
            return 'true';
        else
            return 'false';
        end
    end
    return tp;
end

-- ================================================================
-- Player
-- ================================================================

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

-- ================================================================
-- Item
-- ================================================================

function acutil.getItemRarityColor(itemObj)
    local itemProp = geItemTable.GetProp(itemObj.ClassID);
    local grade = itemObj.ItemGrade;

    if (itemObj.ItemType == "Recipe") then
        local recipeGrade = tonumber(itemObj.Icon:match("misc(%d)")) - 1;
        if (recipeGrade <= 0) then recipeGrade = 1 end;
        grade = recipeGrade;
    end

    if (itemProp.setInfo ~= nil) then return "00FF00"; -- set piece
    elseif (grade == 0) then return "FFBF33"; -- premium
    elseif (grade == 1) then return "FFFFFF"; -- common
    elseif (grade == 2) then return "108CFF"; -- rare
    elseif (grade == 3) then return "9F30FF"; -- epic
    elseif (grade == 4) then return "FF4F00"; -- legendary
    else return "E1E1E1"; -- no grade (non-equipment items)
    end
end

-- ================================================================
-- Hooks/Events
-- ================================================================

function acutil.setupHook(newFunction, hookedFunctionStr)
	local storeOldFunc = hookedFunctionStr .. "_OLD";
	if _G[storeOldFunc] == nil then
		_G[storeOldFunc] = _G[hookedFunctionStr];
		_G[hookedFunctionStr] = newFunction;
	else
		_G[hookedFunctionStr] = newFunction;
	end
end

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

-- usage:
-- function myFunc(addonFrame, eventMsg)
--     local arg1, arg2, arg3 = acutils.getEventArgs(eventMsg);
-- end
function acutil.getEventArgs(eventMsg)
	return unpack(_G['ADDONS']['EVENTS']['ARGS'][eventMsg]);
end

-- ================================================================
-- Json
-- ================================================================

function acutil.saveJSON(path, tbl)
	file,err = io.open(path, "w")
	if err then return _,err end

	local s = json.encode(tbl);
	file:write(s);
	file:close();
end

-- tblMerge is optional, use this to merge new pairs from tblMerge while
-- preserving the pairs set in the pre-existing config file
function acutil.loadJSON(path, tblMerge, ignoreError)
    -- opening the file
	local file, err=io.open(path,"r");
    local t = nil;
    -- if a error happened 
	if (err) then 
        -- if the ignoreError is true
        if (ignoreError) then
            -- we simply set it as a empty json
            t = {};
        else 
            -- if it's not, the error is returned
            return _,err
        end
    else 
        -- if nothing wrong happened, the file is read
	    local content = file:read("*all");
        file:close();
        t = json.decode(content);
    end
    -- if there is another table to merge (like default options)
	if tblMerge then
        -- we merge it
		t = acutil.mergeLeft(tblMerge, t)
        -- and save it back to file
		acutil.saveJSON(path, t);
	end
    -- returning the table
	return t;
end

-- ================================================================
-- Tables
-- ================================================================

-- merge left
function acutil.mergeLeft(t1, t2)
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(t1[k] or false) == "table") then
			acutil.mergeLeft(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

-- table length (when #table doesn't works)
function acutil.tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- ================================================================
-- Logging
-- ================================================================

function acutil.log(msg)     
    CHAT_SYSTEM(acutil.tostring(msg));  
end

-- ================================================================
-- Slash Commands
-- ================================================================

-- credits to fiote for some code https://github.com/fiote/
acutil.slashCommands = acutil.slashCommands or {};

function acutil.slashCommand(cmd, fn)
	if cmd:sub(1,1) ~= "/" then cmd = "/" .. cmd end
	acutil.slashCommands[cmd] = fn;
end

function acutil.slashSet(set)
    if (not set.base) then return ui.SysMsg('[acutil.slashSet] missing "base" string.'); end
    if (set.title) then set.title = set.title..'{nl}-----------{nl}'; else set.title = ''; end

    local fnError = set.error;

    if (not fnError) then
        fnError = function(extraMsg)
            if (extraMsg) then extraMsg = '{nl}-----------{nl}'..extraMsg..'{nl}-----------{nl}'; else extraMsg = ''; end
            return 'Command not valid.{nl}'..extraMsg..'Type "'..set.base..'" for help.', '', 'Nope';
        end
    end

    local executeSetCmd = function(fn,params) 
        local p1, p2, p3;
        if (params) then
            p1,p2,p3 = fn(params);
        else
            p1,p2,p3 = fn(); 
        end         
        if (p1) then 
            local msg = set.title..p1;
            if (p2 and p3) then return ui.MsgBox(msg,p2,p3); end
            if (p2) then return ui.MsgBox(msg,p2); end
            return ui.MsgBox(msg);
        end
    end

    local mainFn = function(words)
        local word = table.remove(words,1);     
        if (word == 'help') then word = nil; end

        if (word) then
            for cmd,data in pairs(set.cmds) do
                if (cmd == word) then
                    local fn = data.fn;     
                    local qtexpected = data.nparams or 0;                   
                    local qtfound = acutil.tableLength(words);
                    if (qtfound ~= qtexpected) then
                        return executeSetCmd(fnError,set.base..' '..cmd..' expects '..qtexpected..' params, not '..qtfound..'.');
                    else
                        local params = {}; 
                        local n = 0;
                        while (acutil.tableLength(words) > 0) do
                            params[n] = table.remove(words,1);
                            n = n+1;
                        end
                        return executeSetCmd(fn,params);
                    end
                end
            end
            return executeSetCmd(fnError,word..' is not a valid call.');
        else
            if (set.empty) then
                return executeSetCmd(set.empty);
            end
            local lines = set.base..'{nl}Show addon help.{nl}-----------{nl}';
            for cmd,data in pairs(set.cmds) do
                local params = ' ';
                local qtparams = data.nparams or 0;
                for i = 1, qtparams do 
                    params = params .. '$param'..i..' '; 
                end
                lines = lines .. set.base..' '..cmd..params..'{nl}-----------{nl}';
            end
            return ui.MsgBox(set.title..lines,'','Nope');
        end
    end
   
    acutil.slashCommand(set.base,mainFn);
end

function acutil.onUIChat(msg)
	acutil.uiChat_OLD(msg);

	local words = {};
	for word in msg:gmatch('%S+') do
		table.insert(words, word)
	end

	local cmd = table.remove(words,1);
	for i,v in ipairs({"/r","/w","/p","/y","/s","/g"}) do
		if (tostring(cmd) == tostring(v)) then
			cmd = table.remove(words,1);
			break;
		end
	end

	local fn = acutil.slashCommands[cmd];
	if (fn ~= nil) then
		acutil.closeChat();
		return fn(words);
	end
end

function acutil.closeChat()
	local chatFrame = GET_CHATFRAME();
	local edit = chatFrame:GetChild('mainchat');

	chatFrame:ShowWindow(0);
	edit:ShowWindow(0);

	ui.CloseFrame("chat_option");
	ui.CloseFrame("chat_emoticon");
end

-- alternate chat hook to avoid conflict with cwapi and lkchat
if not acutil.uiChat_OLD then
	acutil.uiChat_OLD = ui.Chat;
end

ui.Chat = acutil.onUIChat;

-- ================================================================
-- Return
-- ================================================================

return acutil;
