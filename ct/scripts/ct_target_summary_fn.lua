--  	Author: Ryan Hagelstrom
--	  	Copyright © 2022
--	  	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--	  	https://creativecommons.org/licenses/by-sa/4.0/
function onInit()
    if super.onInit then
        super.onInit();
    end
    onTargetsChanged();
    local node = window.getDatabaseNode();
    DB.addHandler(DB.getPath(node, 'targets'), 'onChildAdded', onTargetsChanged);
    DB.addHandler(DB.getPath(node, 'targets.*'), 'onChildUpdate', onTargetsChanged);
    DB.addHandler(DB.getPath(node, 'targets'), 'onChildDeleted', onTargetsChanged);
    DB.addHandler(DB.getPath(node, 'friendfoe'), 'onUpdate', onTargetsChanged);
    if window.label.isLong() then
        window.label.makeLong();
    else
        window.label.makeShort();
    end
end

function onClose()
    if super.onClose then
        super.onClose();
    end
    local node = window.getDatabaseNode();
    DB.removeHandler(DB.getPath(node, 'targets'), 'onChildAdded', onTargetsChanged);
    DB.removeHandler(DB.getPath(node, 'targets.*'), 'onChildUpdate', onTargetsChanged);
    DB.removeHandler(DB.getPath(node, 'targets'), 'onChildDeleted', onTargetsChanged);
    DB.removeHandler(DB.getPath(node, 'friendfoe'), 'onUpdate', onTargetsChanged);
end

function onTargetsChanged()
    if super.onTargetsChanged then
        super.onTargetsChanged();
    end
    if window.label.isLong() then
        window.label.makeLong();
    else
        window.label.makeShort();
    end
end
