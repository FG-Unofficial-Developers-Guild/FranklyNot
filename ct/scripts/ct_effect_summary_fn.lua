--  	Author: Ryan Hagelstrom
--	  	Copyright © 2022
--	  	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--	  	https://creativecommons.org/licenses/by-sa/4.0/
--
-- luacheck: globals onInit onClose onEffectsChanged setValue setVisible
function onInit()
    if super.onInit then
        super.onInit();
    end
    onEffectsChanged();
    local node = window.getDatabaseNode();
    OptionsManager.registerCallback('FRANKLY_NOT_PLAYER', onEffectsChanged);
    DB.addHandler(DB.getPath(node, 'effects'), 'onChildUpdate', onEffectsChanged);
end

function onClose()
    if super.onClose then
        super.onClose();
    end

    local node = window.getDatabaseNode();
    OptionsManager.unregisterCallback('FRANKLY_NOT_PLAYER', onEffectsChanged);
    DB.removeHandler(DB.getPath(node, 'effects'), 'onChildUpdate', onEffectsChanged);
end

function onEffectsChanged()
    if OptionsManager.isOption('FRANKLY_NOT_PLAYER', 'on') then
        -- Set the effect summary string
        local sEffects = EffectManager.getEffectsString(window.getDatabaseNode());
        local aEffects = StringManager.split(sEffects, '|', true);
        sEffects = '';
        for _, sEffect in pairs(aEffects) do
            sEffect = StringManager.trim(sEffect);
            local sDur = sEffect:match('%[D:[^%]]*%]$');
            sEffect = sEffect:gsub('%[D:[^%]]*%]$', '');
            local rEffect = EffectManager.parseEffect(sEffect);
            if next(rEffect) and rEffect[1] ~= '' then
                sEffects = sEffects .. rEffect[1];
                if sDur then
                    sEffects = sEffects .. ' ' .. sDur;
                end
                sEffects = sEffects .. ' | ';
            end
        end
        if sEffects ~= '' then
            sEffects = sEffects:gsub('%s|%s$', '');
        end
        if sEffects ~= '' then
            setValue(Interface.getString('ct_label_effects') .. ' ' .. sEffects);
        else
            setValue(nil);
        end

        -- Update visibility
        local bSectionToggle = (window.activateeffects and (window.activateeffects.getValue() == 1)) or
                                   (window.getSectionToggle and (window.getSectionToggle('effects') == true));
        local bShow = (sEffects ~= '') and not bSectionToggle;
        setVisible(bShow);
    else
        if super.onEffectsChanged then
            super.onEffectsChanged();
        end
    end

end
