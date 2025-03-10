/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
    Fills the preset listbox.

    Parameter(s):
    NONE

    Returns:
    NONE
*/

// Dialog controls
private _dialog = findDisplay 758067;
private _presetListbox = _dialog displayCtrl 75805;

// Clear the preset listbox
lbClear _presetListbox;

// Check if there are presets
if (isNil "KPCF_activePresets" || {count KPCF_activePresets == 0}) exitWith {
    hint "DEBUG: Aucun préréglage disponible dans KPCF_activePresets";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Process and insert the presets into the listbox
{
    _presetListbox lbAdd (_x select 0);
} forEach KPCF_activePresets;

// Select the first entry
_presetListbox lbSetCurSel 0;

hint format ["DEBUG: %1 préréglages chargés dans la liste", count KPCF_activePresets];
[{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
