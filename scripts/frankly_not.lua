--  	Author: Ryan Hagelstrom
--	  	Copyright © 2022
--	  	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--	  	https://creativecommons.org/licenses/by-sa/4.0/

local addChatMessage = nil;
local deliverChatMessage = nil;

function onInit()
	addChatMessage = Comm.addChatMessage;
	deliverChatMessage = Comm.deliverChatMessage;

	Comm.addChatMessage = customAddChatMessage;
	Comm.deliverChatMessage = customDeliverChatMessage;

	OptionsManager.registerOption2("FRANKLY_NOT_PLAYER", true, "option_header_client",
	"option_Frankly_Not_Player", "option_entry_cycler",
	{ labels = "option_val_off", values = "off",
		baselabel = "option_val_on", baseval = "on", default = "on" });
end

function onClose()
	Comm.addChatMessage = addChatMessage;
	Comm.deliverChatMessage = deliverChatMessage;
end

function replaceEffectShortNameinMessage(sMsg)
	local sReturn = sMsg;
	if OptionsManager.isOption("FRANKLY_NOT_PLAYER", "on") then
		local sEffect = (sMsg:match("^%s*Effect%s*%[[^%]]*%]"));
		if sEffect then
			sEffect = sEffect:gsub("^%s*Effect%s*%['", ""):gsub("'%]$", "");
			local rEffect = EffectManager.parseEffect(sEffect);
			if next(rEffect) and rEffect[1] ~= "" then
				if rEffect[1]:match("^FROMAURA") and rEffect[2] then
					sEffect = rEffect[1] .. "; " ..rEffect[2];
				else
					sEffect = rEffect[1];
				end
				sReturn = sMsg:gsub("^%s*Effect%s*%[[^%]]*%]", "Effect ['" .. sEffect .. "']");
			end
		end
	end
	return sReturn;
end

function customAddChatMessage(rMsg)
	if OptionsManager.isOption("FRANKLY_NOT_PLAYER", "on") then
		rMsg.text = replaceEffectShortNameinMessage(rMsg.text);
	end
	addChatMessage(rMsg);
end

function customDeliverChatMessage(rMsg, sUser)
	if OptionsManager.isOption("FRANKLY_NOT_PLAYER", "on") then
		rMsg.text = replaceEffectShortNameinMessage(rMsg.text);
	end
	deliverChatMessage(rMsg, sUser);
end

