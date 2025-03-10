/*
    Killah Potatoes Cratefiller

    Description:
    Récupère les valeurs d'un objet (type, nom d'affichage).

    Parameter(s):
        0: STRING - Classe de l'objet

    Returns:
    ARRAY - [type, nom d'affichage]
        type: 0 = magazine, 1 = arme, 2 = item, 3 = sac à dos
*/

params [
    ["_class", "", [""]]
];

// Si aucune classe n'est fournie, retourner un tableau vide
if (_class isEqualTo "") exitWith {
    diag_log "KPCF WARNING: fn_getItemValues appelé avec une classe vide";
    [0, ""]
};

// Variables pour stocker le résultat
private _type = 2; // Par défaut, on considère que c'est un item
private _displayName = "";

// Utiliser un bloc try-catch pour éviter les erreurs
try {
    // On vérifie le type d'objet en fonction de sa config
    if (isClass (configFile >> "CfgMagazines" >> _class)) then {
        // C'est un magazine
        _type = 0;
        _displayName = getText (configFile >> "CfgMagazines" >> _class >> "displayName");
    } else {
        if (isClass (configFile >> "CfgWeapons" >> _class)) then {
            // C'est une arme ou un item
            private _itemInfo = getNumber (configFile >> "CfgWeapons" >> _class >> "type");
            
            // Si type 1 ou 2 ou 4, c'est une arme
            if (_itemInfo == 1 || _itemInfo == 2 || _itemInfo == 4) then {
                _type = 1; // Arme
            } else {
                _type = 2; // Item
            };
            
            _displayName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
        } else {
            if (isClass (configFile >> "CfgVehicles" >> _class)) then {
                // Si c'est un sac à dos
                if (getNumber (configFile >> "CfgVehicles" >> _class >> "isBackpack") == 1) then {
                    _type = 3; // Sac à dos
                };
                
                _displayName = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
            } else {
                if (isClass (configFile >> "CfgGlasses" >> _class)) then {
                    _type = 2; // Item
                    _displayName = getText (configFile >> "CfgGlasses" >> _class >> "displayName");
                };
            };
        };
    };
} catch {
    diag_log format ["KPCF ERROR: fn_getItemValues a rencontré une erreur avec '%1': %2", _class, _exception];
    _type = 2; // Par défaut, on considère que c'est un item
};

// Si on n'a pas pu déterminer le nom d'affichage, on utilise la classe
if (_displayName isEqualTo "") then {
    _displayName = _class;
    diag_log format ["KPCF WARNING: Impossible de déterminer le nom d'affichage pour '%1', utilisation de la classe comme nom", _class];
};

// Retourner le type et le nom d'affichage
[_type, _displayName] 