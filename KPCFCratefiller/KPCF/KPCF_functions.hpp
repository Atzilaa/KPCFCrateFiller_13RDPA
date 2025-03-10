/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
    Function defines for the KP cratefiller.
*/

class KPCF {
    class main {
        file = "KPCFCratefiller\KPCF\fnc";
        
        // Fonctions principales
        class init {
            postInit = 1;
        };
        class getNearStorages {};
        class getInventory {};
        class setActiveStorage {};
        class showPresets {};
        class applyPreset {};
        class deletePreset {};
        class clearInventory {};
        
        // UI Functions
        class openDialog {};
        class createEquipmentList {};
        class createSubList {};
        class addEquipment {};
        class removeEquipment {};
        class getDroppedEquipment {};
        class deleteCrate {};
        class spawnCrate {};
        
        // Utility Functions
        class checkTranslations {};
        class export {};
        class import {};
        class getItemValues {};
        class getConfigPath {};
        class getWeaponMagazines {};
        class manageActions {};
        class manageAceActions {};
        class sortList {};
        class getItems {};
        class setInventory {};
        class showInventory {};
    };
};
