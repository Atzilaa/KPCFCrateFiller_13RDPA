/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
    Reads and defines the active inventory from the Dialog.

    Parameter(s):
    NONE

    Returns:
    NONE
*/

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlStorage = _dialog displayCtrl 75802;

// Read controls
private _storageIndex = lbCurSel _ctrlStorage;

// Check for empty selection
if (_storageIndex == -1) exitWith {
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

hint format ["DEBUG: Sélection du stockage à l'index %1. KPCF_nearStorage contient %2 éléments", _storageIndex, count KPCF_nearStorage];

// Define active Storage
KPCF_activeStorage = KPCF_nearStorage select _storageIndex;

// Message personnalisé selon le type de stockage
private _typeMessage = "";
if (KPCF_activeStorage isKindOf "LandVehicle") then {
    _typeMessage = "véhicule terrestre";
} else {
    if (KPCF_activeStorage isKindOf "Air") then {
        _typeMessage = "véhicule aérien";
    } else {
        if (KPCF_activeStorage isKindOf "Ship") then {
            _typeMessage = "véhicule naval";
        } else {
            _typeMessage = "caisse";
        };
    };
};

hint format ["DEBUG: %1 '%2' sélectionné comme stockage actif", _typeMessage, getText (configFile >> "CfgVehicles" >> typeOf KPCF_activeStorage >> "displayName")];
[{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;

[] remoteExecCall ["KPCF_fnc_getInventory", (allPlayers - entities "HeadlessClient_F")];
