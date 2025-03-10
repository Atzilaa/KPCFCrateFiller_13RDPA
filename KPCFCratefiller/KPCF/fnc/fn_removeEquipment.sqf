/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Amélioration de la gestion des quantités négatives
    - Optimisation de la mise à jour de l'inventaire
    - Ajout de vérifications de validité des objets
    - Intégration avec le système de barre de progression
    - Messages de confirmation améliorés

    Description:
    Removes the specified amount of the selected item from the active storage.
    Includes validation and error handling.

    Parameter(s):
    0: NUMBER - Amount of items to remove

    Returns:
    NONE

    Dependencies:
    * KPCF_fnc_setInventory
*/

params [
    "_amount"
];

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlInventory = _dialog displayCtrl 75822;

// Check if the storage is in range
if ((KPCF_activeStorage distance2D KPCF_activeSpawn) > KPCF_spawnRadius) exitWith {
    hint localize "STR_KPCF_HINTRANGE";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
    [] remoteExecCall ["KPCF_fnc_getNearStorages", (allPlayers - entities "HeadlessClient_F")];
};

// Check for inventory clear
if (_amount == 0) exitWith {
    KPCF_inventory = [];
    [] call KPCF_fnc_setInventory;
    hint localize "STR_KPCF_HINTCLEARFULL";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Read controls
private _index = lbCurSel _ctrlInventory;

// Check for empty selection
if (_index == -1) exitWith {
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Vérifier si l'inventaire contient des éléments
if (count KPCF_inventory == 0) exitWith {
    hint "L'inventaire est vide";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Vérifier si l'index est valide
if (_index >= count KPCF_inventory) exitWith {
    hint "Erreur: sélection invalide";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Format attendu: [displayName, className, amount, type]
private _displayName = KPCF_inventory select _index select 0;
private _className = KPCF_inventory select _index select 1;
private _currentAmount = KPCF_inventory select _index select 2;

// Nouvelle quantité après retrait
private _newAmount = _currentAmount - _amount;

// Si la nouvelle quantité est négative ou nulle, on la limite à 0
if (_newAmount < 0) then {
    _newAmount = 0;
};

// Mettre à jour la quantité dans l'inventaire
(KPCF_inventory select _index) set [2, _newAmount];

// Enregistrer les modifications
[] call KPCF_fnc_setInventory;

// Afficher un message de confirmation
hint format ["Retiré: %1x %2", _amount, _displayName];
[{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
