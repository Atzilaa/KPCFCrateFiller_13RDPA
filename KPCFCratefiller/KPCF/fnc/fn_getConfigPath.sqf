/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
    Gets the config path for the given classname.

    Parameter(s):
    0: STRING - Classname for which the config path is getting searched

    Returns:
    STRING - The config path or empty string
*/

params [
    ["_class", "", [""]]
];

// Si la classe est vide, retourner une chaîne vide
if (_class isEqualTo "") exitWith {
    diag_log "KPCF ERROR: fn_getConfigPath appelé avec une classe vide";
    ""
};

// Initialisation des variables
private _return = "";
private _config = "";

// Bloc try-catch pour protéger contre les erreurs
try {
    // Vérifier les différentes classes possibles
    if (isClass (configFile >> "CfgMagazines" >> _class)) then {
        _return = "CfgMagazines";
    } else {
        if (isClass (configFile >> "CfgWeapons" >> _class)) then {
            _return = "CfgWeapons";
        } else {
            if (isClass (configFile >> "CfgVehicles" >> _class)) then {
                _return = "CfgVehicles"; 
            } else {
                if (isClass (configFile >> "CfgGlasses" >> _class)) then {
                    _return = "CfgGlasses";
                };
            };
        };
    };
} catch {
    diag_log format ["KPCF ERROR: fn_getConfigPath a rencontré une erreur avec la classe '%1': %2", _class, _exception];
    _return = "";
};

// Journaliser si aucune classe correspondante n'a été trouvée
if (_return isEqualTo "") then {
    diag_log format ["KPCF WARNING: Aucune classe de configuration trouvée pour '%1'", _class];
};

// Retourner le résultat
_return
