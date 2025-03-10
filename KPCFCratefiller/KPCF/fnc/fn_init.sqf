/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Intégration du système de barres de progression
    - Amélioration de l'initialisation des presets
    - Optimisation du chargement des configurations
    - Ajout de vérifications de sécurité supplémentaires

    Description:
    Initializes the cratefiller functionalities.

    Parameter(s):
    NONE

    Returns:
    BOOL - True when initialization is complete.

    Dependencies:
        * KPGUI
*/

// Only run, when we've a real player
if (hasInterface) then {

    // Read the config file
    [] call compile preprocessFileLineNumbers "KPCFCratefiller\KPCF_config.sqf";

    // Read the presets file
    [] call compile preprocessFileLineNumbers "KPCFCratefiller\KPCF_presets.sqf";

    // Read the variables
    [] call compile preprocessFileLineNumbers "KPCFCratefiller\KPCF\variables.sqf";

    // Fix variables
    // KPCF_cratefiller_spawn doit être la version minuscule de KPCF_cratefillerSpawn pour maintenir la compatibilité
    if (!isNil "KPCF_cratefillerSpawn") then {
        KPCF_cratefiller_spawn = KPCF_cratefillerSpawn;
        diag_log "KPCF DEBUG: KPCF_cratefiller_spawn défini à partir de KPCF_cratefillerSpawn";
    } else {
        diag_log "KPCF ERROR: KPCF_cratefillerSpawn n'est pas défini dans le fichier de configuration";
    };

    // Check for ACE
    KPCF_ace = isClass (configfile >> "CfgPatches" >> "ace_common");

    // Add CBA event handler to the base objects
    {
        [_x, "init", {[_this select 0] call KPCF_fnc_manageActions;}, nil, nil, true] call CBA_fnc_addClassEventHandler;
    } forEach KPCF_cratefillerBase;

    // Generate the lists if enabled
    if (KPCF_generateLists) then {
        [] call KPCF_fnc_getItems;
    };

    // Sort the item lists
    KPCF_sortedCrates = [KPCF_crates] call KPCF_fnc_sortList;
    KPCF_sortedWeapons = [KPCF_weapons] call KPCF_fnc_sortList;
    KPCF_sortedGrenades = [KPCF_grenades] call KPCF_fnc_sortList;
    KPCF_sortedExplosives = [KPCF_explosives] call KPCF_fnc_sortList;
    KPCF_sortedItems = [KPCF_items] call KPCF_fnc_sortList;
    KPCF_sortedBackpacks = [KPCF_backpacks] call KPCF_fnc_sortList;

    // Vérification des traductions (debug)
    [] spawn {
        sleep 5;
        [] call KPCF_fnc_checkTranslations;
    };

    // Ajouter des event handlers pour appliquer automatiquement les capacités personnalisées
    if (!isNil "KPCF_crateCapacities") then {
        {
            private _crateType = _x select 0;
            private _capacity = _x select 1;
            private _initScript = _x select 2;
            
            // Ajouter un eventHandler d'initialisation pour les caisses
            [_crateType, "init", {
                params ["_crate"];
                
                // Rechercher la configuration pour ce type de caisse
                private _crateConfig = [];
                {
                    if ((_x select 0) == typeOf _crate) exitWith {
                        _crateConfig = _x;
                    };
                } forEach KPCF_crateCapacities;
                
                if (count _crateConfig > 0) then {
                    private _capacity = _crateConfig select 1;
                    private _initScript = _crateConfig select 2;
                    
                    // Appliquer la capacité
                    _crate setMaxLoad _capacity;
                    
                    // Exécuter le script d'initialisation personnalisé
                    private _code = compile _initScript;
                    _crate call _code;
                    
                    diag_log format ["[KPCF][HOOK] Capacité forcée sur caisse %1 via hook d'init: %2", typeOf _crate, _capacity];
                };
            }, true, [], true] call CBA_fnc_addClassEventHandler;
            
            diag_log format ["[KPCF][INFO] Hook d'initialisation ajouté pour %1", _crateType];
        } forEach KPCF_crateCapacities;
    };

};
