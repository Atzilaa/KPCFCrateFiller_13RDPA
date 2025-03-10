/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Ajout du mode d'ajout à l'inventaire existant
    - Implémentation de la vérification de capacité maximale
    - Amélioration des messages de débogage
    - Ajout de statistiques détaillées par type d'objet
    - Optimisation du calcul de charge

    Description:
    Applies the selected preset to the active storage.
    Can either replace the existing inventory or add to it.

    Parameter(s):
    0: NUMBER - Index of the selected preset
    1: BOOLEAN - (Optional) True to add to existing inventory, false to replace (default)

    Returns:
    NONE

    Dependencies:
    * KPCF_fnc_getItemValues
    * KPCF_fnc_getInventory
*/

params [
    ["_index", -1, [0]],
    ["_addToExisting", false, [true]]
];

// Dialog controls
private _dialog = findDisplay 758067;

// Check if dialog is open
if (isNull _dialog) exitWith {
    hint "DEBUG: Le dialogue n'est pas ouvert";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Check if a preset was selected
if (_index == -1) exitWith {
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Check for an active storage
if (isNull KPCF_activeStorage) exitWith {
    hint format ["DEBUG: KPCF_activeStorage est null. KPCF_nearStorage: %1", str KPCF_nearStorage];
    [{hint localize "STR_KPCF_HINTNOSTORAGE";}, [], 0.5] call CBA_fnc_waitAndExecute;
    [{hintSilent "";}, [], 3.5] call CBA_fnc_waitAndExecute;
};

private _preset = KPCF_activePresets select _index;
private _presetName = _preset select 0;

// Get the inventory items
private _inventory = _preset select 1;

// Calculer la charge totale du préréglage
private _presetLoad = 0;
{
    private _className = _x select 0;
    private _amount = _x select 1;
    
    private _config = [_className] call KPCF_fnc_getConfigPath;
    private _itemMass = 0;
    
    if (_config == "CfgWeapons") then {
        _itemMass = getNumber (configFile >> _config >> _className >> "WeaponSlotsInfo" >> "mass");
        if (_itemMass == 0) then {
            _itemMass = getNumber (configFile >> _config >> _className >> "ItemInfo" >> "mass");
        };
    } else {
        _itemMass = getNumber (configFile >> _config >> _className >> "mass");
    };
    
    if (isNil "_itemMass" || {_itemMass == 0}) then { _itemMass = 1; };
    _presetLoad = _presetLoad + (_itemMass * _amount);
} forEach _inventory;

// Calculer la charge actuelle si on ajoute à l'existant
private _currentLoad = 0;
if (_addToExisting) then {
    {
        private _className = _x select 1;
        private _amount = _x select 2;
        
        private _config = [_className] call KPCF_fnc_getConfigPath;
        private _itemMass = 0;
        
        if (_config == "CfgWeapons") then {
            _itemMass = getNumber (configFile >> _config >> _className >> "WeaponSlotsInfo" >> "mass");
            if (_itemMass == 0) then {
                _itemMass = getNumber (configFile >> _config >> _className >> "ItemInfo" >> "mass");
            };
        } else {
            _itemMass = getNumber (configFile >> _config >> _className >> "mass");
        };
        
        if (isNil "_itemMass" || {_itemMass == 0}) then { _itemMass = 1; };
        _currentLoad = _currentLoad + (_itemMass * _amount);
    } forEach KPCF_inventory;
};

// Obtenir la capacité maximale
private _maxLoad = 1000; // Valeur par défaut
private _type = typeOf KPCF_activeStorage;
private _config = [_type] call KPCF_fnc_getConfigPath;

// NOUVEAU: Vérifier d'abord si une capacité personnalisée est définie
private _customCapacity = -1;
if (!isNil "KPCF_crateCapacities") then {
    {
        if (_x select 0 == _type) then {
            _customCapacity = _x select 1;
            diag_log format ["KPCF DEBUG: fn_applyPreset - Capacité personnalisée trouvée pour %1: %2", _type, _customCapacity];
        };
    } forEach KPCF_crateCapacities;
};

// Utiliser la capacité personnalisée si elle existe
if (_customCapacity > 0) then {
    _maxLoad = _customCapacity;
    diag_log format ["KPCF DEBUG: fn_applyPreset - Utilisation de la capacité personnalisée pour %1: %2", _type, _maxLoad];
} else {
    // Vérifier la variable de caisse si elle existe
    if (!isNil {KPCF_activeStorage getVariable "KPCF_customCapacity"}) then {
        _maxLoad = KPCF_activeStorage getVariable "KPCF_customCapacity";
        diag_log format ["KPCF DEBUG: fn_applyPreset - Utilisation de la capacité de variable locale pour %1: %2", _type, _maxLoad];
    } else {
        // Enfin, utiliser la configuration par défaut
        if (_config != "") then {
            _maxLoad = getNumber (configFile >> _config >> _type >> "maximumLoad");
            if (_maxLoad <= 0) then {
                _maxLoad = 1000; // Valeur par défaut si la capacité est illimitée
            };
            diag_log format ["KPCF DEBUG: fn_applyPreset - Utilisation de la capacité par défaut pour %1: %2", _type, _maxLoad];
        };
    };
};

// Vérifier la capacité
private _totalLoad = if (_addToExisting) then {_currentLoad + _presetLoad} else {_presetLoad};
if (_maxLoad > 0 && {_totalLoad > _maxLoad}) exitWith {
    private _message = if (_addToExisting) then {
        format ["Impossible d'ajouter le préréglage. La capacité maximale serait dépassée (%1/%2)", round _totalLoad, round _maxLoad]
    } else {
        format ["Impossible d'appliquer le préréglage. Il dépasse la capacité maximale (%1/%2)", round _totalLoad, round _maxLoad]
    };
    hint _message;
    playSound "FD_CP_Not_Clear_F"; // Son d'erreur
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Déterminer si on clear l'inventaire ou non
if (!_addToExisting) then {
    // Clear the storage
    clearMagazineCargoGlobal KPCF_activeStorage;
    clearWeaponCargoGlobal KPCF_activeStorage;
    clearItemCargoGlobal KPCF_activeStorage;
    clearBackpackCargoGlobal KPCF_activeStorage;
    
    hint format ["DEBUG: Application du préréglage '%1' avec %2 objets (remplacement de l'inventaire)...", _presetName, count _inventory];
} else {
    hint format ["DEBUG: Ajout du préréglage '%1' avec %2 objets à l'inventaire existant...", _presetName, count _inventory];
};

// Variables pour compter les types d'objets
private _countMags = 0;
private _countWeapons = 0;
private _countItems = 0;
private _countBackpacks = 0;
private _countUnknown = 0;

// Add the items from the preset
{
    // Item values
    private _values = [_x select 0] call KPCF_fnc_getItemValues;
    private _type = _values select 0;
    private _amount = _x select 1;
    
    // Add the item
    switch (_type) do {
        case 0: {
            KPCF_activeStorage addMagazineCargoGlobal [_x select 0, _amount];
            _countMags = _countMags + 1;
        };
        case 1: {
            KPCF_activeStorage addWeaponCargoGlobal [_x select 0, _amount];
            _countWeapons = _countWeapons + 1;
        };
        case 2: {
            KPCF_activeStorage addItemCargoGlobal [_x select 0, _amount];
            _countItems = _countItems + 1;
        };
        case 3: {
            KPCF_activeStorage addBackpackCargoGlobal [_x select 0, _amount];
            _countBackpacks = _countBackpacks + 1;
        };
        default {
            _countUnknown = _countUnknown + 1;
            diag_log format ["KPCF ERROR: Type inconnu: %1 pour l'item %2", _type, _x select 0];
        };
    };
} forEach _inventory;

// Message selon le mode d'application
if (!_addToExisting) then {
    hint format ["DEBUG: Préréglage '%1' appliqué avec succès (remplacement). Stats: %2 magazines, %3 armes, %4 objets, %5 sacs à dos", 
        _presetName, _countMags, _countWeapons, _countItems, _countBackpacks];
} else {
    hint format ["DEBUG: Préréglage '%1' ajouté avec succès. Stats: %2 magazines, %3 armes, %4 objets, %5 sacs à dos", 
        _presetName, _countMags, _countWeapons, _countItems, _countBackpacks];
};
[{hintSilent "";}, [], 4] call CBA_fnc_waitAndExecute;

// Update the inventory dialog
[] call KPCF_fnc_getInventory; 