/*
    Killah Potatoes Cratefiller

    Author: [13RDPA] Dylan - https://github.com/DylannD3
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
    Vide complètement l'inventaire de la caisse active.

    Parameter(s):
    NONE

    Returns:
    NONE
*/

// Vérification que le stockage actif est valide
if (isNull KPCF_activeStorage) exitWith {
    hint localize "STR_KPCF_HINTSELECTION";
    [{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;
};

// Vider l'inventaire de la caisse
clearItemCargoGlobal KPCF_activeStorage;
clearMagazineCargoGlobal KPCF_activeStorage;
clearWeaponCargoGlobal KPCF_activeStorage;
clearBackpackCargoGlobal KPCF_activeStorage;

// Message de confirmation
hint "L'inventaire de la caisse a été vidé avec succès.";
[{hintSilent "";}, [], 3] call CBA_fnc_waitAndExecute;

// Rafraîchir l'affichage de l'inventaire
[] call KPCF_fnc_getInventory; 