/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Amélioration de la validation des noms de préréglages
    - Optimisation du stockage des données
    - Ajout de la gestion des doublons
    - Intégration avec le nouveau système de préréglages
    - Amélioration des messages utilisateur

    Description:
    Exports the current inventory as a named preset.
    Handles duplicate names and validates input.

    Parameter(s):
    NONE

    Returns:
    NONE

    Dependencies:
    * KPCF_fnc_showPresets
*/

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlExport = _dialog displayCtrl 75820;

// Read the presets from profileNamespace
private _preset = profileNamespace getVariable ["KPCF_preset", []];

// Read the export name
private _exportName = ctrlText _ctrlExport;
_ctrlExport ctrlSetText "";

if (_exportName == "") exitWith {
    hint localize "STR_KPCF_HINTNAME";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Check if the variable is empty
if !(_preset isEqualTo []) then {
    // Check if the exportname already exists
    _preset deleteAt (_preset findIf {(_x select 0) isEqualTo _exportName});
};

// Save the inventory into profileNamespace
_preset pushBack [_exportName, +KPCF_inventory];

profileNamespace setVariable ["KPCF_preset", _preset];
saveProfileNamespace;

[] call KPCF_fnc_showPresets;
