/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Ajout de la vérification de la capacité maximale
    - Ajout de messages d'erreur détaillés
    - Ajout de sons d'erreur lors du dépassement de capacité
    - Amélioration du système de débogage

    Description:
    Adds the given amount of the selected item to the crate.

    Parameter(s):
    0 : SCALAR - Amount of the added item.

    Returns:
    NONE
*/

params [
    "_amount"
];

// Debug message
diag_log format ["[KPCF][DEBUG] fn_addEquipment - Tentative d'ajout de %1 d'un objet", _amount];

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlEquipment = _dialog displayCtrl 75812;

// Read controls
private _index = lbCurSel _ctrlEquipment;

// Check for empty variable
if (isNull KPCF_activeStorage) exitWith {
    diag_log "[KPCF][DEBUG] fn_addEquipment - Pas de stockage actif sélectionné";
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Check for empty selection
if (_index == -1) exitWith {
    diag_log "[KPCF][DEBUG] fn_addEquipment - Aucun objet sélectionné dans la liste";
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Check if the storage is in range
if ((KPCF_activeStorage distance2D KPCF_activeSpawn) > KPCF_spawnRadius) exitWith {
    diag_log "[KPCF][DEBUG] fn_addEquipment - Stockage hors de portée";
    hint localize "STR_KPCF_HINTRANGE";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
    [] remoteExecCall ["KPCF_fnc_getNearStorages", (allPlayers - entities "HeadlessClient_F")];
};

// Item selection
private _item = _ctrlEquipment lbData _index;

// Vérifier que l'objet est valide
if (_item == "") exitWith {
    diag_log "[KPCF][DEBUG] fn_addEquipment - Sélection d'objet invalide (chaîne vide)";
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

diag_log format ["[KPCF][DEBUG] fn_addEquipment - Tentative d'ajout de %1 x %2", _amount, _item];

// Check for enough inventory capacity
if (!(KPCF_activeStorage canAdd [_item, _amount])) exitWith {
    diag_log "[KPCF][DEBUG] fn_addEquipment - Pas assez d'espace de stockage";
    hint format [localize "STR_KPCF_HINTFULL"];
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Vérification de capacité maximale
private _load = 0;
private _maxLoad = 0;
private _itemMass = 0;

// Calculer la charge actuelle
{
    private _className = _x select 1;
    private _amount = _x select 2;
    
    if (isNil "_className" || isNil "_amount") then { continue; };
    
    private _config = [_className] call KPCF_fnc_getConfigPath;
    if (_config == "") then { continue; };
    
    if (_config == "CfgWeapons") then {
        _itemMass = getNumber (configFile >> _config >> _className >> "WeaponSlotsInfo" >> "mass");
        if (_itemMass == 0) then {
            _itemMass = getNumber (configFile >> _config >> _className >> "ItemInfo" >> "mass");
        };
    } else {
        _itemMass = getNumber (configFile >> _config >> _className >> "mass");
    };
    
    if (isNil "_itemMass" || {_itemMass == 0}) then { _itemMass = 1; };
    
    _load = _load + (_itemMass * _amount);
} forEach KPCF_inventory;

// Calculer la masse de l'objet à ajouter
private _config = [_item] call KPCF_fnc_getConfigPath;
if (_config == "CfgWeapons") then {
    _itemMass = getNumber (configFile >> _config >> _item >> "WeaponSlotsInfo" >> "mass");
    if (_itemMass == 0) then {
        _itemMass = getNumber (configFile >> _config >> _item >> "ItemInfo" >> "mass");
    };
} else {
    _itemMass = getNumber (configFile >> _config >> _item >> "mass");
};

if (isNil "_itemMass" || {_itemMass == 0}) then { _itemMass = 1; };

// Calculer la nouvelle charge et la charge maximale
private _newLoad = _load + (_itemMass * _amount);
private _type = typeOf KPCF_activeStorage;
_config = [_type] call KPCF_fnc_getConfigPath;

// NOUVELLE APPROCHE: Vérifier d'abord si une capacité personnalisée est définie
private _customCapacity = -1;
if (!isNil "KPCF_crateCapacities") then {
    {
        if (_x select 0 == _type) then {
            _customCapacity = _x select 1;
            diag_log format ["KPCF DEBUG: fn_addEquipment - Capacité personnalisée trouvée pour %1: %2", _type, _customCapacity];
        };
    } forEach KPCF_crateCapacities;
};

// Utiliser la capacité personnalisée si elle existe
if (_customCapacity > 0) then {
    _maxLoad = _customCapacity;
    diag_log format ["KPCF DEBUG: fn_addEquipment - Utilisation de la capacité personnalisée pour %1: %2", _type, _maxLoad];
} else {
    // Vérifier la variable de caisse si elle existe
    if (!isNil {KPCF_activeStorage getVariable "KPCF_customCapacity"}) then {
        _maxLoad = KPCF_activeStorage getVariable "KPCF_customCapacity";
        diag_log format ["KPCF DEBUG: fn_addEquipment - Utilisation de la capacité de variable locale pour %1: %2", _type, _maxLoad];
    } else {
        // Enfin, utiliser la configuration par défaut
        if (_config != "") then {
            _maxLoad = getNumber (configFile >> _config >> _type >> "maximumLoad");
            if (_maxLoad <= 0) then {
                _maxLoad = 1000; // Valeur par défaut si la capacité est illimitée
            };
            diag_log format ["KPCF DEBUG: fn_addEquipment - Utilisation de la capacité par défaut pour %1: %2", _type, _maxLoad];
        };
    };
};

// Vérifier si la capacité actuelle est déjà dépassée
if (_maxLoad > 0 && {_load >= _maxLoad}) exitWith {
    diag_log format ["[KPCF][DEBUG] fn_addEquipment - Capacité déjà dépassée: %1 >= %2", _load, _maxLoad];
    hint format ["Impossible d'ajouter l'équipement. Capacité maximale déjà dépassée (%1/%2)", round _load, round _maxLoad];
    playSound "FD_CP_Not_Clear_F"; // Son d'erreur
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Vérifier si la nouvelle charge dépasse la capacité maximale
if (_maxLoad > 0 && {_newLoad > _maxLoad}) exitWith {
    diag_log format ["[KPCF][DEBUG] fn_addEquipment - Capacité maximale dépassée: %1 > %2", _newLoad, _maxLoad];
    hint format ["Impossible d'ajouter l'équipement. La capacité maximale serait dépassée (%1/%2)", round _newLoad, round _maxLoad];
    playSound "FD_CP_Not_Clear_F"; // Son d'erreur
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Vérifier si l'objet peut être ajouté physiquement
if (!(KPCF_activeStorage canAdd [_item, _amount])) exitWith {
    diag_log "[KPCF][DEBUG] fn_addEquipment - Pas assez d'espace de stockage";
    hint format [localize "STR_KPCF_HINTFULL"];
    playSound "FD_CP_Not_Clear_F"; // Son d'erreur
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Add the given item
try {
    if (_item isKindOf "Bag_Base") then {
        KPCF_activeStorage addBackpackCargoGlobal [_item, _amount];
        diag_log format ["[KPCF][DEBUG] fn_addEquipment - Sac à dos ajouté: %1 x %2", _amount, _item];
    } else {
        KPCF_activeStorage addItemCargoGlobal [_item, _amount];
        diag_log format ["[KPCF][DEBUG] fn_addEquipment - Objet ajouté: %1 x %2", _amount, _item];
    };
} catch {
    diag_log format ["[KPCF][DEBUG] fn_addEquipment - Erreur lors de l'ajout de l'objet: %1", _exception];
    hint format ["Erreur lors de l'ajout de l'objet. Veuillez réessayer."];
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

[] remoteExecCall ["KPCF_fnc_getInventory", (allPlayers - entities "HeadlessClient_F")];

private _config = [_item] call KPCF_fnc_getConfigPath;
if (_config != "") then {
    private _name = (getText (configFile >> _config >> _item >> "displayName"));
    hint format [localize "STR_KPCF_HINTADDED", _name, _amount];
} else {
    hint format ["Ajouté: %1 x %2", _amount, _item];
};
[{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
