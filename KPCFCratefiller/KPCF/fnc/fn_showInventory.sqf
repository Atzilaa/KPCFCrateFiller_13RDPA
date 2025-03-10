/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Ajout d'un système de barre de progression avec code couleur
    - Ajout d'un tooltip affichant le niveau de remplissage
    - Correction du calcul de la charge maximale
    - Amélioration de la gestion des erreurs et du débogage

    Description:
    Displays the items of the active crate.

    Parameter(s):
    NONE

    Returns:
    NONE
*/

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlInventory = _dialog displayCtrl 75822;
private _ctlrProgress = _dialog displayCtrl 75830;

// Débogage - Vérifier le contenu de KPCF_inventory
diag_log format ["KPCF DEBUG: fn_showInventory - KPCF_inventory contient %1 éléments", count KPCF_inventory];
if (count KPCF_inventory > 0) then {
    diag_log format ["KPCF DEBUG: Premier élément: %1", KPCF_inventory select 0];
} else {
    diag_log "KPCF DEBUG: KPCF_inventory est vide";
};

// Reset variables
lbClear _ctrlInventory;

private ["_config", "_type", "_itemMass", "_index"];

// Fill the controls
{
    try {
        // Nouveau format: [displayName, className, amount, type]
        private _displayName = _x select 0;
        private _className = _x select 1;
        private _amount = _x select 2;
        
        // Vérifier que toutes les valeurs sont définies
        if (isNil "_displayName") then {_displayName = "Inconnu";};
        if (isNil "_className") then {_className = "Inconnu";};
        if (isNil "_amount") then {_amount = 0;};
        
        _index = _ctrlInventory lbAdd (format ["%1x %2", str _amount, _displayName]);
        
        _config = [_className] call KPCF_fnc_getConfigPath;
        
        // Si la configuration est valide, ajouter l'image
        if (_config != "") then {
            private _picture = getText (configFile >> _config >> _className >> "picture");
            if (_picture != "") then {
                _ctrlInventory lbSetPicture [_index, _picture];
            };
        };
    } catch {
        diag_log format ["KPCF ERROR: Erreur dans fn_showInventory lors de l'ajout de l'élément: %1 - %2", _x, _exception];
    };
} forEach KPCF_inventory;

private _load = 0;

// Check for an active storage
if (isNull KPCF_activeStorage) exitWith {
    _ctlrProgress progressSetPosition 0;
};

// Get the mass of each item
{
    try {
        // Nouveau format: [displayName, className, amount, type]
        private _className = _x select 1;
        private _amount = _x select 2;
        
        if (isNil "_className" || isNil "_amount") then {
            continue;
        };
        
        _config = [_className] call KPCF_fnc_getConfigPath;
        
        if (_config == "") then {
            continue;
        };
        
        if (_config == "CfgWeapons") then {
            _itemMass = getNumber (configFile >> _config >> _className >> "WeaponSlotsInfo" >> "mass");
            if (_itemMass == 0) then {
                _itemMass = getNumber (configFile >> _config >> _className >> "ItemInfo" >> "mass");
            };
        } else {
            _itemMass = getNumber (configFile >> _config >> _className >> "mass");
        };
        
        if (isNil "_itemMass" || {_itemMass == 0}) then {
            _itemMass = 1; // Une valeur par défaut si la masse n'est pas trouvée
        };
        
        _load = _load + (_itemMass * _amount);
    } catch {
        diag_log format ["KPCF ERROR: Erreur dans fn_showInventory lors du calcul de la masse: %1 - %2", _x, _exception];
    };
} forEach KPCF_inventory;

// Vérifier que maximumLoad est bien défini
private _maxLoad = 1000; // Valeur par défaut
try {
    _type = typeOf KPCF_activeStorage;
    _config = [_type] call KPCF_fnc_getConfigPath;
    
    // NOUVELLE APPROCHE: Vérifier d'abord si une capacité personnalisée est définie
    private _customCapacity = -1;
    if (!isNil "KPCF_crateCapacities") then {
        {
            if (_x select 0 == _type) then {
                _customCapacity = _x select 1;
                diag_log format ["KPCF DEBUG: Capacité personnalisée trouvée pour %1: %2", _type, _customCapacity];
            };
        } forEach KPCF_crateCapacities;
    };
    
    // Utiliser la capacité personnalisée si elle existe
    if (_customCapacity > 0) then {
        _maxLoad = _customCapacity;
        diag_log format ["KPCF DEBUG: Utilisation de la capacité personnalisée pour %1: %2", _type, _maxLoad];
    } else {
        // Vérifier la variable de caisse si elle existe
        if (!isNil {KPCF_activeStorage getVariable "KPCF_customCapacity"}) then {
            _maxLoad = KPCF_activeStorage getVariable "KPCF_customCapacity";
            diag_log format ["KPCF DEBUG: Utilisation de la capacité de variable locale pour %1: %2", _type, _maxLoad];
        } else {
            // Enfin, utiliser la configuration par défaut
            if (_config != "") then {
                private _configMaxLoad = getNumber (configFile >> _config >> _type >> "maximumLoad");
                if (_configMaxLoad > 0) then {
                    _maxLoad = _configMaxLoad;
                    diag_log format ["KPCF DEBUG: Utilisation de la capacité par défaut pour %1: %2", _type, _maxLoad];
                } else {
                    // Si la capacité est 0 ou négative (illimitée), on utilise une estimation basée sur la masse actuelle
                    _maxLoad = (_load * 1.5) max 1000; 
                    diag_log format ["KPCF INFO: Capacité illimitée détectée, utilisation d'une capacité estimée de %1", _maxLoad];
                };
            } else {
                diag_log "KPCF ERROR: Capacité maximale non définie";
            };
        };
    };
} catch {
    diag_log format ["KPCF ERROR: Erreur dans fn_showInventory lors de la récupération de maximumLoad: %1", _exception];
};

// Déterminer si le conteneur est un véhicule, auquel cas il pourrait avoir une capacité différente
if (_maxLoad <= 0 || {_maxLoad > 100000}) then {
    // Pour les véhicules à très grande capacité, on utilise une approche progressive
    _maxLoad = (_load * 1.2) max 1000;
    diag_log format ["KPCF INFO: Grande capacité détectée (%1), ajustement à %2", getNumber (configFile >> _config >> _type >> "maximumLoad"), _maxLoad];
};

private _loadFactor = _load / _maxLoad;

// Afficher des informations de débogage pour le calcul de charge
diag_log format ["KPCF DEBUG: Charge actuelle: %1, Capacité max: %2, Facteur: %3", _load, _maxLoad, _loadFactor];

// Vérifier si la capacité est dépassée
private _capaciteDepassee = false;
if (_loadFactor > 1) then {
    _capaciteDepassee = true;
    diag_log format ["KPCF WARNING: Capacité dépassée! %1/%2 (%3%)", round _load, round _maxLoad, round(_loadFactor * 100)];
};

// Ne pas limiter le facteur pour montrer visuellement le dépassement
// _loadFactor = (_loadFactor min 1) max 0;

if (!isNull _dialog) then {
    // Récupérer les contrôles des barres de progression
    private _ctlrProgressYellow = _dialog displayCtrl 75830;
    private _ctlrProgressOrange = _dialog displayCtrl 75831;
    private _ctlrProgressRed = _dialog displayCtrl 75832;
    
    // Créer le texte avec le niveau de remplissage
    private _progressText = format ["Niveau de remplissage: %1%2 (%3/%4)", round(_loadFactor * 100), "%", round _load, round _maxLoad];
    
    // Masquer toutes les barres au début et mettre à jour les tooltips
    {
        _x ctrlShow false;
        _x ctrlSetTooltip _progressText;
    } forEach [_ctlrProgressYellow, _ctlrProgressOrange, _ctlrProgressRed];
    
    // Réinitialiser toutes les positions
    {
        _x progressSetPosition 0;
    } forEach [_ctlrProgressYellow, _ctlrProgressOrange, _ctlrProgressRed];
    
    // Si capacité dépassée ou supérieure à 80%, afficher la barre rouge
    if (_loadFactor >= 0.8) then {
        _ctlrProgressRed progressSetPosition _loadFactor;
        _ctlrProgressRed ctrlShow true;
        diag_log format ["KPCF DEBUG: Affichage de la barre rouge (>80%) à %1", _loadFactor];
    } else {
        // Sinon, afficher la barre orange ou jaune selon le niveau
        if (_loadFactor > 0.5) then {
            _ctlrProgressOrange progressSetPosition _loadFactor;
            _ctlrProgressOrange ctrlShow true;
            diag_log format ["KPCF DEBUG: Affichage de la barre orange (50-80%) à %1", _loadFactor];
        } else {
            _ctlrProgressYellow progressSetPosition _loadFactor;
            _ctlrProgressYellow ctrlShow true;
            diag_log format ["KPCF DEBUG: Affichage de la barre jaune (<50%) à %1", _loadFactor];
        };
    };
    
    // Code de débogage
    diag_log format ["KPCF DEBUG: Mise à jour de la barre de progression avec le texte: %1", _progressText];
} else {
    diag_log "KPCF ERROR: Dialogue non trouvé";
};

