/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Intégration du nouveau système de préréglages
    - Amélioration de l'initialisation du dialogue
    - Optimisation du chargement des contrôles
    - Ajout de messages de débogage
    - Gestion améliorée des erreurs d'initialisation

    Description:
    Opens and initializes the cratefiller dialog.
    Sets up all controls and loads presets.

    Parameter(s):
    0: ARRAY - Gets all data from the used base object

    Returns:
    NONE

    Dependencies:
    * KPCF_fnc_getDroppedEquipment
    * KPCF_fnc_getNearStorages
    * KPCF_fnc_showPresets
*/

params ["_data"];

KPCF_activeBase = _data select 0;

KPCF_activeSpawn = nearestObject [getPos KPCF_activeBase, KPCF_cratefillerSpawn];

if (isNull KPCF_activeSpawn) then {
    hint localize "STR_KPCF_HINTNOSPAWN";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
    KPCF_activeSpawn = KPCF_activeBase;
};

// Create dialog
createDialog "KPCF_dialog";
disableSerialization;

// Get the active storage
[] call KPCF_fnc_getDroppedEquipment;
[] call KPCF_fnc_getNearStorages;

// Reset the placement pos for the next crate
KPCF_pos = [];

// DEBUG: Afficher le contenu des préréglages
hint format ["DEBUG: KPCF_presets contient %1 préréglages", count KPCF_presets];
if (!isNil "KPCF_presets" && {count KPCF_presets > 0}) then {
    private _firstPreset = KPCF_presets select 0;
    hint format ["DEBUG: Premier préréglage: %1 avec %2 items", _firstPreset select 0, count (_firstPreset select 1)];
} else {
    hint "DEBUG: KPCF_presets est vide ou non défini";
};

// Preset initialization
private _ctrl = (findDisplay 758067) displayCtrl 75805;
lbClear _ctrl;

// Fill the list with presets
{
    _x params ["_name"];
    _ctrl lbAdd _name;
} forEach KPCF_presets;

// LIGNE CRUCIALE: On copie les préréglages pour les rendre accessibles
KPCF_activePresets = KPCF_presets;
hint format ["DEBUG: KPCF_activePresets défini avec %1 préréglages", count KPCF_activePresets];

// Dialog controls
private _dialog = findDisplay 758067;
private _ctrlCrate = _dialog displayCtrl 75801;
private _ctrlSpawn = _dialog displayCtrl 75803;
private _ctrlDelete = _dialog displayCtrl 75804;
private _ctrlCat = _dialog displayCtrl 75810;
private _ctrlWeapon = _dialog displayCtrl 75811;

private _index = 0;

if (!KPCF_canSpawnAndDelete) then {
    _ctrlCrate ctrlShow false;
    _ctrlSpawn ctrlShow false;
    _ctrlDelete ctrlShow false;
} else {
    // Fill the controls
    {
        _index = _ctrlCrate lbAdd (_x select 0);
        _ctrlCrate lbSetData [_index , _x select 1];
    } forEach KPCF_sortedCrates;
};

// Hide controls
_ctrlWeapon ctrlShow false;

// Reset variables
KPCF_activeStorage = objNull;

_ctrlCat lbAdd localize "STR_KPCF_LISTWEAPONS";
_ctrlCat lbAdd localize "STR_KPCF_LISTMAGAZINES";
_ctrlCat lbAdd localize "STR_KPCF_LISTATTACHMENTS";
_ctrlCat lbAdd localize "STR_KPCF_LISTGRENADES";
_ctrlCat lbAdd localize "STR_KPCF_LISTEXPLOSIVES";
_ctrlCat lbAdd localize "STR_KPCF_LISTVARIOUS";
_ctrlCat lbAdd localize "STR_KPCF_LISTBACKPACKS";

// Ajouter un gestionnaire d'événements pour le contrôle des armes qui mettra à jour les catégories d'accessoires
_ctrlWeapon ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_selectedIndex"];
    
    // Obtenir les données de l'élément sélectionné
    private _data = _control lbData _selectedIndex;
    private _dialog = findDisplay 758067;
    private _ctrlCat = _dialog displayCtrl 75810;
    
    // Si nous sommes dans la catégorie des accessoires (index 2)
    if ((lbCurSel _ctrlCat) == 2) then {
        // Réinitialiser les couleurs de toutes les catégories
        for "_i" from 0 to (lbSize _control) - 1 do {
            if (_control lbData _i == "CATEGORY") then {
                _control lbSetColor [_i, [0.8, 0.8, 0, 1]]; // Jaune pour les catégories non sélectionnées
            };
        };
        
        // Si une catégorie est sélectionnée, la mettre en surbrillance
        if (_data == "CATEGORY") then {
            _control lbSetColor [_selectedIndex, [1, 0.5, 0, 1]]; // Orange pour la catégorie sélectionnée
            
            // Sauvegarder le type sélectionné pour une utilisation ultérieure
            KPCF_selectedAttachmentType = _control lbValue _selectedIndex;
            
            // Mettre à jour immédiatement la liste des accessoires
            [] call KPCF_fnc_createSubList;
        } else {
            // Si une arme est sélectionnée, trouver le type d'accessoire actuellement surligné
            private _selectedType = 0;
            for "_i" from 0 to (lbSize _control) - 1 do {
                if (_control lbData _i == "CATEGORY" && {_control lbColor _i select 0 > 0.9}) exitWith {
                    _selectedType = _control lbValue _i;
                };
            };
            
            // Si aucun type n'est sélectionné et qu'une variable est déjà définie, utiliser cette valeur
            if (_selectedType == 0 && {!isNil "KPCF_selectedAttachmentType"}) then {
                for "_i" from 0 to (lbSize _control) - 1 do {
                    if (_control lbData _i == "CATEGORY" && {_control lbValue _i == KPCF_selectedAttachmentType}) exitWith {
                        _control lbSetColor [_i, [1, 0.5, 0, 1]]; // Orange pour la catégorie sélectionnée
                    };
                };
            };
            
            // Mettre à jour la liste des accessoires
            [] call KPCF_fnc_createSubList;
        };
    };
}];

[] call KPCF_fnc_showPresets;
[] call KPCF_fnc_getNearStorages;
