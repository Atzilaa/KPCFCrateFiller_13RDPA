/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Amélioration de la gestion des erreurs
    - Optimisation du processus de mise à jour
    - Ajout de logs détaillés pour le débogage
    - Intégration avec le système de barre de progression
    - Vérification améliorée de la capacité

    Description:
    Updates the inventory of the active storage with the current KPCF_inventory.
    Includes capacity checks and error handling.

    Parameter(s):
    NONE

    Returns:
    NONE

    Dependencies:
    * KPCF_fnc_getInventory
*/

// Debug message
diag_log format ["[KPCF][DEBUG] fn_setInventory - Début de la fonction, inventaire: %1 éléments", count KPCF_inventory];

// Vérifier si l'objet de stockage existe
if (isNull KPCF_activeStorage) exitWith {
    hint localize "STR_KPCF_HINTNOTCRATE";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Check if the storage is in range
if ((KPCF_activeStorage distance2D KPCF_activeSpawn) > KPCF_spawnRadius) exitWith {
    hint localize "STR_KPCF_HINTRANGE";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
    [] remoteExecCall ["KPCF_fnc_getNearStorages", (allPlayers - entities "HeadlessClient_F")];
};

// Check if the storage will be empty
if (count KPCF_inventory == 0) exitWith {
    diag_log "[KPCF][DEBUG] fn_setInventory - Inventaire vide, nettoyage du stockage";
    clearWeaponCargoGlobal KPCF_activeStorage;
    clearMagazineCargoGlobal KPCF_activeStorage;
    clearItemCargoGlobal KPCF_activeStorage;
    clearBackpackCargoGlobal KPCF_activeStorage;
    [] remoteExecCall ["KPCF_fnc_getInventory", (allPlayers - entities "HeadlessClient_F")];
};

// Clear the storage
clearWeaponCargoGlobal KPCF_activeStorage;
clearMagazineCargoGlobal KPCF_activeStorage;
clearItemCargoGlobal KPCF_activeStorage;
clearBackpackCargoGlobal KPCF_activeStorage;

// Count the variable index
private _count = count KPCF_inventory;
private _abort = false;
private _item = "";
private _amount = 0;
private _addedItems = 0;

// Adapt the cargo into KPCF variable
for "_i" from 0 to (_count-1) do {
    try {
        _item = (KPCF_inventory select _i) select 1;
        _amount = (KPCF_inventory select _i) select 2;
        
        // Vérifier si l'objet est valide
        if (isNil "_item" || _item == "") then {
            throw "Item invalid";
        };
        
        // Vérifier si la caisse peut contenir l'objet
        if (!(KPCF_activeStorage canAdd [_item, _amount])) then {
            throw "Not enough space";
        };
        
        // Ajouter l'objet selon son type
        if (_item isKindOf "Bag_Base") then {
            KPCF_activeStorage addBackpackCargoGlobal [_item, _amount];
        } else {
            KPCF_activeStorage addItemCargoGlobal [_item, _amount];
        };
        
        _addedItems = _addedItems + 1;
    } catch {
        diag_log format ["[KPCF][DEBUG] fn_setInventory - Erreur lors de l'ajout de l'objet: %1, Raison: %2", _item, _exception];
        if (_exception == "Not enough space") then {
            _abort = true;
        };
    };
};

diag_log format ["[KPCF][DEBUG] fn_setInventory - %1 objets ajoutés sur %2 total", _addedItems, _count];

// Check for enough inventory capacity
if (_abort) exitWith {
    [] remoteExecCall ["KPCF_fnc_getInventory", (allPlayers - entities "HeadlessClient_F")];
    hint format [localize "STR_KPCF_HINTFULL"];
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

[] remoteExecCall ["KPCF_fnc_getInventory", (allPlayers - entities "HeadlessClient_F")];
