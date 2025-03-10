/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
    Creates a list with valueable magazines or attachments.

    Parameter(s):
    NONE

    Returns:
    NONE
*/

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlCat = _dialog displayCtrl 75810;
private _ctrlWeapon = _dialog displayCtrl 75811;
private _ctrlEquipment = _dialog displayCtrl 75812;

// Clear the lists
lbClear _ctrlEquipment;

// Read controls
private _catIndex = lbCurSel _ctrlCat;
private _weaponIndex = lbCurSel _ctrlWeapon;

// Check for empty selection
if (_weaponIndex == -1) exitWith {
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Variables pour accessoires
private _selectedType = 0;
private _weaponType = "";

// Vérifier le type de sélection en fonction de ce qui est stocké dans lbData
if (_catIndex == 2) then {
    private _selection = _ctrlWeapon lbData _weaponIndex;
    
    // Si on a sélectionné une catégorie d'accessoires
    if (_selection == "CATEGORY") then {
        _selectedType = _ctrlWeapon lbValue _weaponIndex;
        
        // Chercher l'arme sélectionnée (en prenant la première arme si aucune n'est déjà sélectionnée)
        for "_i" from 0 to (lbSize _ctrlWeapon) - 1 do {
            if (_i != _weaponIndex && {_ctrlWeapon lbData _i != "CATEGORY"} && {_ctrlWeapon lbData _i != ""}) exitWith {
                _weaponType = _ctrlWeapon lbData _i;
            };
        };
        
        // Si aucune arme n'est trouvée, sortir
        if (_weaponType == "") exitWith {
            hint localize "STR_KPCF_HINTWEAPON";
            [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
        };
    } else {
        // Si on a sélectionné une arme
        _weaponType = _selection;
        
        // Chercher le type d'accessoire sélectionné (en prenant "Tous accessoires" par défaut)
        _selectedType = 0; // Par défaut: tous accessoires
        
        // Vérifier s'il y a un type d'accessoire déjà sélectionné
        for "_i" from 0 to (lbSize _ctrlWeapon) - 1 do {
            if (_ctrlWeapon lbData _i == "CATEGORY" && {_ctrlWeapon lbColor _i select 0 > 0.9}) exitWith {
                _selectedType = _ctrlWeapon lbValue _i;
            };
        };
    };
} else {
    // Pour les magazines, comportement standard
    _weaponType = _ctrlWeapon lbData _weaponIndex;
};

// Si l'arme n'est pas valide, sortir
if (_weaponType == "") exitWith {
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Fonction pour vérifier la compatibilité manuelle basée sur les modèles
private _fnc_checkManualCompatibility = {
    params ["_weapon", "_attachment"];
    
    // Vérifier si la variable de compatibilité manuelle est définie
    if (isNil "KPCF_manualCompatibility") exitWith {false};
    
    private _isCompatible = false;
    
    {
        _x params ["_weaponPattern", "_compatibleAttachments"];
        
        // Si le nom de l'arme contient le motif défini
        if (_weapon find _weaponPattern != -1) then {
            // Vérifier si l'accessoire est dans la liste des compatibles
            if (_attachment in _compatibleAttachments) then {
                _isCompatible = true;
            };
        };
    } forEach KPCF_manualCompatibility;
    
    _isCompatible
};

private _config = "";

switch (_catIndex) do {

    // Magazines
    case 1 : {
        // Get compatible magazines using standard method
        private _glType = "";
        private _muzzles = getArray (configfile >> "CfgWeapons" >> _weaponType >> "muzzles");
        if (count _muzzles > 1) then {
            _glType = _muzzles select 1;
        };
        
        private _magazines = [_weaponType] call CBA_fnc_compatibleMagazines;
        if (!isNil "_glType" && {_glType != ""}) then {
            _magazines append ([configfile >> "CfgWeapons" >> _weaponType >> _glType] call CBA_fnc_compatibleMagazines);
        };
        
        // Apply whitelist filter if defined
        if (!isNil "KPCF_allowedMagazines" && {count KPCF_allowedMagazines > 0}) then {
            _magazines = _magazines arrayIntersect KPCF_allowedMagazines;
        };
        
        // Apply blacklist
        _magazines = _magazines - KPCF_blacklistedItems;
        
        private _sortedMagazines = [_magazines] call KPCF_fnc_sortList;

        private _index = 0;

        // Fill controls
        {
            _index = _ctrlEquipment lbAdd (_x select 0);
            _ctrlEquipment lbSetData [_index , _x select 1];
            _config = [_x select 1] call KPCF_fnc_getConfigPath;
            _ctrlEquipment lbSetPicture [_index, getText (configFile >> _config >> (_x select 1) >> "picture")];
        } forEach _sortedMagazines;
    };

    // Attachments
    case 2 : {
        // Get compatible attachments using standard method
        private _attachments = [_weaponType] call BIS_fnc_compatibleItems;
        
        // Filtrer et ajouter les accessoires par catégorie
        private _filteredAttachments = [];
        private _typeSpecificAttachments = [];
        
        // Si aucun sous-type n'est sélectionné ou si c'est 0 (Tous accessoires), afficher tous les accessoires
        if (_selectedType == 0) then {
            // Apply whitelist filter if defined
            if (!isNil "KPCF_allowedAttachments" && {count KPCF_allowedAttachments > 0}) then {
                _filteredAttachments = _attachments arrayIntersect KPCF_allowedAttachments;
            } else {
                _filteredAttachments = _attachments;
            };
        } else {
            // Sélectionner les accessoires spécifiques au type, sans filtrer par compatibilité avec l'arme d'abord
            switch (_selectedType) do {
                // Muzzles (suppresseurs, compensateurs, etc.)
                case 1: {
                    if (!isNil "KPCF_allowedMuzzles" && {count KPCF_allowedMuzzles > 0}) then {
                        _typeSpecificAttachments = KPCF_allowedMuzzles;
                    } else {
                        _typeSpecificAttachments = (configProperties [configFile >> "CfgWeapons", "isClass _x && {getNumber (_x >> 'itemInfo' >> 'type') == 101}", true]) apply {configName _x};
                    };
                };
                
                // Optiques (viseurs, lunettes)
                case 2: {
                    if (!isNil "KPCF_allowedOptics" && {count KPCF_allowedOptics > 0}) then {
                        _typeSpecificAttachments = KPCF_allowedOptics;
                    } else {
                        _typeSpecificAttachments = (configProperties [configFile >> "CfgWeapons", "isClass _x && {getNumber (_x >> 'itemInfo' >> 'type') == 201}", true]) apply {configName _x};
                    };
                };
                
                // Rails d'accessoires (pointeurs laser, lampes)
                case 3: {
                    if (!isNil "KPCF_allowedRailAttachments" && {count KPCF_allowedRailAttachments > 0}) then {
                        _typeSpecificAttachments = KPCF_allowedRailAttachments;
                    } else {
                        _typeSpecificAttachments = (configProperties [configFile >> "CfgWeapons", "isClass _x && {getNumber (_x >> 'itemInfo' >> 'type') == 301}", true]) apply {configName _x};
                    };
                };
                
                // Bipods
                case 4: {
                    if (!isNil "KPCF_allowedBipods" && {count KPCF_allowedBipods > 0}) then {
                        _typeSpecificAttachments = KPCF_allowedBipods;
                    } else {
                        _typeSpecificAttachments = (configProperties [configFile >> "CfgWeapons", "isClass _x && {getNumber (_x >> 'itemInfo' >> 'type') == 302}", true]) apply {configName _x};
                    };
                };
            };
            
            // Appliquer les filtres de compatibilité
            _filteredAttachments = _typeSpecificAttachments;
            
            // Si vous souhaitez uniquement montrer les accessoires compatibles, décommentez la ligne ci-dessous
            // _filteredAttachments = _attachments arrayIntersect _typeSpecificAttachments;
        };
        
        // Apply blacklist
        _filteredAttachments = _filteredAttachments - KPCF_blacklistedItems;
        
        private _sortedAttachments = [_filteredAttachments] call KPCF_fnc_sortList;

        private _index = 0;

        // Si la liste est vide, ajouter un message informatif
        if (count _sortedAttachments == 0) then {
            _ctrlEquipment lbAdd "Aucun accessoire de ce type trouvé";
        } else {
            // Fill controls
            {
                _index = _ctrlEquipment lbAdd (_x select 0);
                _ctrlEquipment lbSetData [_index , _x select 1];
                _config = [_x select 1] call KPCF_fnc_getConfigPath;
                _ctrlEquipment lbSetPicture [_index, getText (configFile >> _config >> (_x select 1) >> "picture")];
                
                // Vérifier compatibilité standard ou manuelle
                private _isCompatible = (_x select 1) in _attachments;
                
                // Si non compatible par la méthode standard, vérifier par famille d'armes
                if (!_isCompatible) then {
                    _isCompatible = [_weaponType, _x select 1] call _fnc_checkManualCompatibility;
                };
                
                // Marquer en gris les accessoires incompatibles avec l'arme sélectionnée
                if (!_isCompatible) then {
                    _ctrlEquipment lbSetColor [_index, [0.5, 0.5, 0.5, 1]];
                    _ctrlEquipment lbSetTooltip [_index, "Non compatible avec l'arme sélectionnée"];
                };
            } forEach _sortedAttachments;
        };
    };
};
