/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Optimisation de la recherche des conteneurs proches
    - Ajout d'un filtre pour les types de conteneurs spécifiques
    - Amélioration de la détection des véhicules
    - Ajout de messages de débogage détaillés

    Description:
    Scans the spawn area for possible storages.

    Parameter(s):
    NONE

    Returns:
    ARRAY - Array with all near storages.
*/

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlStorage = _dialog displayCtrl 75802;

// Clear the lists
lbClear _ctrlStorage;
KPCF_nearStorage = [];

hint "DEBUG: Recherche des stockages à proximité...";

// Déterminer le point central de recherche (joueur ou base active)
private _centerPoint = if (!isNil "KPCF_activeBase" && {!isNull KPCF_activeBase}) then {
    getPos KPCF_activeBase
} else {
    getPos player
};

diag_log format ["KPCF DEBUG: Point central de recherche: %1", _centerPoint];
hint format ["DEBUG: Point central de recherche: %1", _centerPoint];

// Définir la distance de recherche (utiliser KPCF_spawnRadius au lieu de KPCF_spawnDistance)
private _searchDistance = if (!isNil "KPCF_spawnRadius") then {
    KPCF_spawnRadius
} else {
    10 // Valeur par défaut si KPCF_spawnRadius n'est pas défini
};

diag_log format ["KPCF DEBUG: Distance de recherche: %1m", _searchDistance];

// Get near objects - recherche autour du point central
// Modifié pour inclure les véhicules (LandVehicle, Air, Ship) et utiliser KPCF_cratefillerBase
private _objects = nearestObjects [_centerPoint, ["ReammoBox_F"] + KPCF_cratefillerBase + ["LandVehicle", "Air", "Ship"], _searchDistance];

// Check if objects are in the array
{
    // Vérifier si l'objet est un container de liberation (si oui, on l'ignore)
    if !((_x getVariable ["KP_liberation_crate_SR_amount", -1] == -1) && (_x getVariable ["KP_liberation_crate_medical_adjustment", -1] == -1) && (_x getVariable ["KP_liberation_crate_weapons_adjustment", -1] == -1)) then {
        continue;
    };

    // Vérifier si c'est un véhicule ou un container avec une capacité de stockage
    private _isValidStorage = false;
    private _type = typeOf _x;
    private _displayName = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
    private _picture = getText (configFile >> "CfgVehicles" >> _type >> "picture");
    
    // Pour les caisses traditionnelles
    if (getNumber (configFile >> "CfgVehicles" >> _type >> "maximumLoad") > 0) then {
        _isValidStorage = true;
    };
    
    // Pour les véhicules
    if (_x isKindOf "LandVehicle" || _x isKindOf "Air" || _x isKindOf "Ship") then {
        _isValidStorage = true;
        
        // Si le véhicule n'a pas d'image preview, on utilise une image standard
        if (_picture == "") then {
            diag_log format ["KPCF DEBUG: Image manquante pour %1 (%2), utilisation d'une image par défaut", _displayName, _type];
            
            if (_x isKindOf "LandVehicle") then {
                if (_x isKindOf "Tank") then {
                    _picture = "\A3\ui_f\data\map\vehicleicons\iconTank_ca.paa";
                } else {
                    if (_x isKindOf "Wheeled_APC_F") then {
                        _picture = "\A3\ui_f\data\map\vehicleicons\iconAPC_ca.paa";
                    } else {
                        _picture = "\A3\ui_f\data\map\vehicleicons\iconCar_ca.paa";
                    };
                };
            };
            if (_x isKindOf "Air") then {
                if (_x isKindOf "Plane") then {
                    _picture = "\A3\ui_f\data\map\vehicleicons\iconPlane_ca.paa";
                } else {
                    _picture = "\A3\ui_f\data\map\vehicleicons\iconHelicopter_ca.paa";
                };
            };
            if (_x isKindOf "Ship") then {
                _picture = "\A3\ui_f\data\map\vehicleicons\iconShip_ca.paa";
            };
            
            // Si toujours pas d'image, utiliser une image générique
            if (_picture == "") then {
                _picture = "\A3\ui_f\data\map\vehicleicons\iconVehicle_ca.paa";
                diag_log format ["KPCF DEBUG: Utilisation de l'image générique pour %1 (%2)", _displayName, _type];
            };
        };
    };
    
    // Si c'est un stockage valide, on l'ajoute à la liste
    if (_isValidStorage) then {
        KPCF_nearStorage pushBack _x;
        _ctrlStorage lbAdd format ["%1 (%2m)", _displayName, round (player distance _x)];
        
        // Définir l'image selon le type d'objet
        private _defaultPicture = "";
        
        // Pour les conteneurs
        if (_x isKindOf "ReammoBox_F" || {_type in KPCF_cratefillerBase}) then {
            _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconCrate_ca.paa";
            
            // Appliquer les capacités personnalisées si définies
            if (!isNil "KPCF_crateCapacities") then {
                private _container = _x; // Stocker l'objet courant pour éviter les conflits
                {
                    private _crateConfig = _x;
                    if (_crateConfig select 0 == _type) exitWith {
                        private _capacity = _crateConfig select 1;
                        private _currentCapacity = maxLoad _container;
                        
                        // Seulement appliquer si nécessaire
                        if (_currentCapacity != _capacity) then {
                            _container setMaxLoad _capacity;
                            diag_log format ["[KPCF][INFO] Capacité appliquée à %1 existant: %2", _type, _capacity];
                        };
                    };
                } forEach KPCF_crateCapacities;
            };
        } else {
            // Pour les véhicules
            if (_x isKindOf "LandVehicle") then {
                if (_x isKindOf "Tank") then {
                    _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconTank_ca.paa";
                } else {
                    if (_x isKindOf "Wheeled_APC_F") then {
                        _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconAPC_ca.paa";
                    } else {
                        if (_x isKindOf "Truck_F") then {
                            _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconTruck_ca.paa";
                        } else {
                            _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconCar_ca.paa";
                        };
                    };
                };
            } else {
                if (_x isKindOf "Air") then {
                    if (_x isKindOf "Plane") then {
                        _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconPlane_ca.paa";
                    } else {
                        _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconHelicopter_ca.paa";
                    };
                } else {
                    if (_x isKindOf "Ship") then {
                        _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconShip_ca.paa";
                    } else {
                        _defaultPicture = "\A3\ui_f\data\map\vehicleicons\iconVehicle_ca.paa";
                    };
                };
            };
        };
        
        _ctrlStorage lbSetPicture [lbSize _ctrlStorage - 1, _defaultPicture];
    };
} forEach _objects;

hint format ["DEBUG: %1 stockages valides trouvés sur %2 objets à proximité (rayon de %3m)", count KPCF_nearStorage, count _objects, _searchDistance];
[{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;

// Check if the storage list is empty
if (lbSize _ctrlStorage == 0) exitWith {
    _ctrlStorage lbAdd "AUCUN STOCKAGE DISPONIBLE";
    _ctrlStorage lbSetData [0, ""];
    KPCF_activeStorage = objNull;
    [] remoteExecCall ["KPCF_fnc_getInventory", (allPlayers - entities "HeadlessClient_F")];
};

// Select the first storage
_ctrlStorage lbSetCurSel 0;
