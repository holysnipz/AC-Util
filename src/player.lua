local player = {};

function player.getFirstName()
	return info.GetName(session.GetMyHandle());
end

function player.getLastName()
	return info.GetFamilyName(session.GetMyHandle());
end

function player.getFullName()
	return player.getFirstName() .. " " .. player.getLastName();
end

function player.getCharacterLevel()
	return GETMYPCLEVEL();
end

function player.getCurrentHP()
	local stat = info.GetStat(session.GetMyHandle());

	return stat.HP;
end

function player.getMaxHP()
	local stat = info.GetStat(session.GetMyHandle());

	return stat.maxHP;
end

function player.getPercentHP()
	return player.getCurrentHP() / player.getMaxHP();
end

function player.getCurrentSP()
	local stat = info.GetStat(session.GetMyHandle());

	return stat.SP;
end

function player.getMaxSP()
	local stat = info.GetStat(session.GetMyHandle());

	return stat.maxSP;
end

function player.getPercentSP()
	return player.getCurrentSP() / player.getMaxSP();
end

function player.getCurrentStamina()
	local stat = info.GetStat(session.GetMyHandle());

	return stat.Stamina;
end

function player.getMaxStamina()
	local stat = info.GetStat(session.GetMyHandle());

	return stat.MaxStamina;
end

function player.getPercentStamina()
	return player.getCurrentStamina() / player.getMaxStamina();
end

function player.getClassName()
	local job = info.GetJob(session.GetMyHandle());
	local className = GetClassString("Job", job, "Name");

	return className;
end

function player.getCurrentMap()
	return session.GetMapName();
end

function player.getStrength()
	local pc = GetMyPCObject();

	return pc["STR"];
end

function player.getConstitution()
	local pc = GetMyPCObject();

	return pc["CON"];
end

function player.getIntelligence()
	local pc = GetMyPCObject();

	return pc["INT"];
end

function player.getSpirit()
	local pc = GetMyPCObject();

	return pc["MNA"];
end

function player.getDexterity()
	local pc = GetMyPCObject();

	return pc["DEX"];
end

function player.getSilver()
	return GET_TOTAL_MONEY();
end

function player.getFreeTP()
	local accountObj = GetMyAccountObj();

	return accountObj.Medal;
end

function player.getGiftTP()
	local accountObj = GetMyAccountObj();

	return accountObj.GiftMedal;
end

function player.getPremiumTP()
	local accountObj = GetMyAccountObj();

	return accountObj.PremiumMedal;
end

return player;
