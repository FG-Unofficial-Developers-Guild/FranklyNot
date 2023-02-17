--  	Author: Ryan Hagelstrom
--	  	Copyright © 2022
--	  	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--	  	https://creativecommons.org/licenses/by-sa/4.0/
function onInit()
    if super.onInit then
        super.onInit();
    end
    OptionsManager.registerCallback('FRANKLY_NOT_PLAYER', isFranklyNot);
    onShowLongOptionChange();
end

function onClose()
    if super.onClose then
        super.onClose();
    end
    OptionsManager.unregisterCallback('FRANKLY_NOT_PLAYER', isFranklyNot);
end

function isFranklyNot()
    onShowLongOptionChange()
end

function onShowLongOptionChange()
    if OptionsManager.isOption('FRANKLY_NOT_PLAYER', 'on') then
        onValueChanged();
        onLoseFocus();
    else
        makeDefault();
    end
end

function onValueChanged()
    if super.onValueChanged then
        super.onValueChanged();
    end
    window.shortlabel.setTooltipText(DB.getValue(window.getDatabaseNode(), 'label', ''));

    local sEffect = DB.getValue(window.getDatabaseNode(), 'label', '');
    local rEffect = EffectManager.parseEffect(sEffect);
    if next(rEffect) and rEffect[1] ~= '' then
        if rEffect[1]:match('^FROMAURA') and rEffect[2] then
            window.shortlabel.setValue(rEffect[1] .. '; ' .. rEffect[2]);
        else
            window.shortlabel.setValue(rEffect[1]);
        end
    end
end

function isLong()
    return window.label.isVisible();
end

function makeDefault()
    if Session.IsHost then
        if window.source.getValue() == '' then
            window.source.setVisible(false);
        else
            window.source.setVisible(true);
        end
        window.shortsource.setVisible(false);

        if window.target_summary.getValue() == '' then
            window.target_summary.setVisible(false);
        else
            window.target_summary.setVisible(true);
        end

        window.shorttarget_summary.setVisible(false);
    end

    window.shortlabel.setVisible(false);
    window.label.setVisible(true);
end

function makeShort()
    if OptionsManager.isOption('FRANKLY_NOT_PLAYER', 'on') then
        if Session.IsHost then
            window.source.setVisible(false);
            window.shortsource.setVisible(true);
            if window.source.getValue() == '' then
                window.source.setVisible(false);
                window.shortsource.setVisible(false);
            end

            window.target_summary.setVisible(false);
            window.shorttarget_summary.setVisible(true);
            if window.target_summary.getValue() == '' then
                window.target_summary.setVisible(false);
                window.shorttarget_summary.setVisible(false);
            end
        end

        window.shortlabel.setVisible(true);
        window.label.setVisible(false);
    else
        makeDefault();
    end
end

function makeLong()
    if OptionsManager.isOption('FRANKLY_NOT_PLAYER', 'on') then

        if Session.IsHost then
            window.source.setVisible(true);
            window.shortsource.setVisible(false);
            if window.source.getValue() == '' then
                window.source.setVisible(false);
                window.shortsource.setVisible(false);
            end

            window.target_summary.setVisible(true);
            window.shorttarget_summary.setVisible(false);
            if window.target_summary.getValue() == '' then
                window.target_summary.setVisible(false);
                window.shorttarget_summary.setVisible(false);
            end
        end

        window.label.setVisible(true);
        window.shortlabel.setVisible(false);
    else
        makeDefault();
    end
end

function onGainFocus()
    if super.gainFocus then
        super.onGainFocus();
    end
    makeLong();
end

function onLoseFocus()
    if super.onLoseFocus then
        super.onLoseFocus();
    end
    makeShort();
end
