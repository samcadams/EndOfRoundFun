--[[
EndRoundGame.IsActive - Set to true during the entire round
EndRoundGame.ActiveGamemode - Current gamemode if active, nil otherwise

---The two below are both linked to ULX commands and you have no need to modify them unless you're linking to another command lib---
EndRoundGame.NextRoundCustom - Bool determining if the next ingame round will be forced to custom
EndRoundGame.NextGamemode - Determines if the next custom round will be a specific gamemode

The 5 fields in the gamemode object are all required for the addon to function.
All are called on their respective TTT hooks
Make 100% sure you hook.Remove any hooks you add in roundEnd() so nothing remains.

The gamemode object is strictly serverside. Any communication will clients needs to be done through the net library



EndRoundGame.Gamemodes["gamemode_name"] = {
--Info
name = "Formatted Game Name",
description = "Formatted chat description, needs to be under 255bytes. use https://mothereff.in/byte-counter",
--Functions
--Prepare and calculate whats needed(roles and such if you so desire)
roundPreparing = function()
end,
--Put everything into effect
roundStart = function()
end,
--Dispose of everything, revert all settings to normal
roundEnd = function()
end,
--You can add custom fields to the gamemode and access them via `EndRoundGame.ActiveGamemode` if your gamemodes enabled
}

]]