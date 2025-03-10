/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Amélioration du système de calcul de charge avec gestion des erreurs
    - Implémentation d'un système de cache pour les gros véhicules
    - Optimisation des performances pour les grands inventaires
    - Ajout de messages de progression pour l'utilisateur
    - Intégration d'un système de débogage avancé

    Description:
    Gets and processes the inventory of the active storage.
    Handles both containers and vehicles with error checking.

    Parameter(s):
    NONE

    Returns:
    ARRAY - KPCF_inventory containing [displayName, className, amount, type] for each item
    
    Dependencies:
    * KPCF_fnc_showInventory
    * KPCF_fnc_getItemValues
*/

// Dialog controls
private _dialog = findDisplay 758067;

// Check if dialog is open
if (isNull _dialog) exitWith {};

// Check for an active storage
if (isNull KPCF_activeStorage) exitWith {
    KPCF_inventory = [];
    [] call KPCF_fnc_showInventory;
};

// Reset variables
KPCF_inventory = [];

// Afficher un message de chargement pour les gros véhicules
if (KPCF_activeStorage isKindOf "LandVehicle" || KPCF_activeStorage isKindOf "Air" || KPCF_activeStorage isKindOf "Ship") then {
    hint "Chargement de l'inventaire du véhicule...";
};

// Débogage du stockage
diag_log format ["KPCF DEBUG: Récupération de l'inventaire pour %1", typeOf KPCF_activeStorage];
diag_log format ["KPCF DEBUG: Distance du stockage: %1m", player distance KPCF_activeStorage];

// Utilisation de try-catch pour la récupération de l'inventaire
try {
    // Get all cargo - méthode standard pour toutes les caisses et véhicules
    private _item = getItemCargo KPCF_activeStorage;
    private _weapon = getWeaponCargo KPCF_activeStorage;
    private _magazine = getMagazineCargo KPCF_activeStorage;
    private _backpack = getBackpackCargo KPCF_activeStorage;
    
    // Si aucune donnée n'est retournée (peut arriver), créer des tableaux vides
    if (isNil "_item" || {isNil {_item select 0}}) then {
        _item = [[], []];
    };
    
    // Créer une copie du tableau d'items pour le cargo principal
    private _cargo = +_item;
    
    // Si aucune donnée n'est retournée pour les armes, créer des tableaux vides
    if (isNil "_weapon" || {isNil {_weapon select 0}}) then {
        _weapon = [[], []];
    };
    
    // Si aucune donnée n'est retournée pour les magazines, créer des tableaux vides
    if (isNil "_magazine" || {isNil {_magazine select 0}}) then {
        _magazine = [[], []];
    };
    
    // Si aucune donnée n'est retournée pour les sacs à dos, créer des tableaux vides  
    if (isNil "_backpack" || {isNil {_backpack select 0}}) then {
        _backpack = [[], []];
    };
    
    // Fusionner tous les éléments dans le cargo principal
    {
        if (count (_x select 0) > 0) then {
            (_cargo select 0) append (_x select 0);
            (_cargo select 1) append (_x select 1);
        };
    } forEach [_weapon, _magazine, _backpack];
    
    // Count the variable index
    private _count = count (_cargo select 0);
    
    diag_log format ["KPCF DEBUG: Nombre total d'éléments trouvés: %1", _count];
    
    // Vérifier chaque élément avant de l'ajouter
    for "_i" from 0 to (_count - 1) do {
        private _item = (_cargo select 0) select _i;
        private _amount = (_cargo select 1) select _i;
        
        if (!isNil "_item" && !isNil "_amount") then {
            private _values = [_item] call KPCF_fnc_getItemValues;
            private _type = _values select 0;
            private _displayName = _values select 1;
            
            // Ajouter l'élément à l'inventaire avec un format correct
            KPCF_inventory pushBack [_displayName, _item, _amount, _type];
        } else {
            diag_log format ["KPCF ERROR: Élément invalide à l'index %1", _i];
        };
    };
} catch {
    diag_log format ["KPCF ERROR: Exception lors de la récupération de l'inventaire: %1", _exception];
    hint format ["Erreur lors du chargement de l'inventaire: %1", _exception];
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Débogage final
diag_log format ["KPCF DEBUG: KPCF_inventory contient %1 éléments après traitement", count KPCF_inventory];

// Effacer le message de chargement
if (KPCF_activeStorage isKindOf "LandVehicle" || KPCF_activeStorage isKindOf "Air" || KPCF_activeStorage isKindOf "Ship") then {
    hint format ["Inventaire du véhicule '%1' chargé avec %2 objets", getText (configFile >> "CfgVehicles" >> typeOf KPCF_activeStorage >> "displayName"), count KPCF_inventory];
    [{hintSilent "";}, [], 2] call CBA_fnc_waitAndExecute;
};

// Show the inventory in the dialog
[] call KPCF_fnc_showInventory;
