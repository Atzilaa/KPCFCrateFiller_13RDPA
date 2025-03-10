/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Ajout de trois barres de progression (jaune, orange, rouge)
    - Modification des contrôles pour une meilleure ergonomie
    - Ajout de tooltips informatifs
    - Amélioration de l'interface utilisateur

    Description:
    Dialog definition for the cratefiller dialog.
*/

class KPCF_dialog {
    idd = 758067;
    movingEnable = 0;

    class controlsBackground {

        class KP_DialogTitle: KPGUI_PRE_DialogTitleS {
            text = "$STR_KPCF_TITLE";
        };

        class KP_DialogArea: KPGUI_PRE_DialogBackgroundS {};

        // Crates

        class KP_TransportTitle: KPGUI_PRE_InlineTitle {
            text = "$STR_KPCF_TITLETRANSPORT";
            x = safeZoneX+safeZoneW*(0.3+(0*0.4+(1-0)*0.002)/1);
            y = safeZoneY+safeZoneH*((0.05+0.035+0.004)+(0*(0.75-0.035-0.025-2*0.004)+(48-0)*0.004)/48);
            w = safeZoneW*((0.4-(1+1)*0.002)/1);
            h = safeZoneH*(((0.75-0.035-0.025-2*0.004)-(16+1)*0.004)/16);
        };

        // Equipment

        class KP_EquipmentTitle: KP_TransportTitle {
            text = "$STR_KPCF_TITLEEQUIPMENT";
            y = safeZoneY + safeZoneH * 0.19166667;
            w = safeZoneW * 0.196875;
        };

        // Inventory

        class KP_InventoryTitle: KP_TransportTitle {
            text = "$STR_KPCF_TITLEINVENTORY";
            x = safeZoneX + safeZoneW * 0.50104167;
            y = safeZoneY + safeZoneH * 0.19166667;
            w = safeZoneW * 0.196875;
        };

    };

    class controls {

        class KP_Help: KPGUI_PRE_DialogCrossS {
            text = "KPCFCratefiller\KPCF\img\icon_help.paa";
            x = safeZoneX + safeZoneW * (0.3 + 0.4 - 0.02);
            y = safeZoneY + safeZoneH *(0.05+0.005);
            tooltip = "$STR_KPCF_TOOLTIPHELP";
            action = "";
        };

        // Crates

        class KP_ComboCrate: KPGUI_PRE_Combo {
            idc = 75801;
            x = safeZoneX+safeZoneW*(0.3+(0*0.4+(1-0)*0.002)/1);
            y = safeZoneY+safeZoneH*((0.05+0.035+0.004)+(3*(0.75-0.035-0.025-2*0.004)+(48-3)*0.004)/48);
            w = safeZoneW*((0.4-(2+1)*0.002)/2);
            h = safeZoneH*(((0.75-0.035-0.025-2*0.004)-(24+1)*0.004)/24);
            tooltip = "$STR_KPCF_TOOLTIPCRATE";
        };

        class KP_ComboCargo: KP_ComboCrate {
            idc = 75802;
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            w = safeZoneW*((0.4-((24/11)+1)*0.002)/(24/11));
            tooltip = "$STR_KPCF_TOOLTIPINVENTORY";
            onLBSelChanged = "[] call KPCF_fnc_setActiveStorage";
        };

        class KP_RefreshCargo: KPGUI_PRE_CloseCross {
            text = "KPCFCratefiller\KPCF\img\icon_refresh.paa";
            x = safeZoneX+safeZoneW*(0.3+(23*0.4+(24-23)*0.002)/24);
            y = safeZoneY+safeZoneH*((0.05+0.035+0.004)+(3*(0.75-0.035-0.025-2*0.004)+(48-3)*0.004)/48);
            w = safeZoneW*((0.4-(24+1)*0.002)/24);
            h = safeZoneH*(((0.75-0.035-0.025-2*0.004)-(24+1)*0.004)/24);
            tooltip = "$STR_KPCF_TOOLTIPREFRESH";
            action = "[] call KPCF_fnc_getNearStorages";
        };

        class KP_ButtonSpawnCrate: KPGUI_PRE_InlineButton {
            idc = 75803;
            text = "$STR_KPCF_SPAWNCRATE";
            x = safeZoneX+safeZoneW*(0.3+(0*0.4+(1-0)*0.002)/1);
            y = safeZoneY+safeZoneH*((0.05+0.035+0.004)+(5*(0.75-0.035-0.025-2*0.004)+(48-5)*0.004)/48);
            w = safeZoneW*((0.4-(2+1)*0.002)/2);
            h = safeZoneH*(((0.75-0.035-0.025-2*0.004)-(24+1)*0.004)/24);
            onButtonClick = "[] call KPCF_fnc_spawnCrate";
        };

        class KP_ButtonDeleteCrate: KP_ButtonSpawnCrate {
            idc = 75804;
            text = "$STR_KPCF_DELETECRATE";
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            y = safeZoneY+safeZoneH*((0.05+0.035+0.004)+(5*(0.75-0.035-0.025-2*0.004)+(48-5)*0.004)/48);
            onButtonClick = "[] call KPCF_fnc_deleteCrate";
        };

        // Presets
        class KP_ComboPresets: KPGUI_PRE_Combo {
            idc = 75805;
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            y = safeZoneY + safeZoneH * 0.23425926;
            w = safeZoneW*((0.4-(2+1)*0.002)/2);
            h = safeZoneH*(((0.75-0.035-0.025-2*0.004)-(24+1)*0.004)/24);
            tooltip = "Sélectionnez un préréglage";
        };
        
        class KP_ButtonApplyPreset: KPGUI_PRE_InlineButton {
            idc = 75806;
            text = "Remplacer";
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2) + safeZoneW * 0.07;
            y = safeZoneY + safeZoneH * 0.26296297;
            w = safeZoneW * 0.06458334;
            h = safeZoneH * 0.02407408;
            tooltip = "Remplace tout l'inventaire par le préréglage";
            onButtonClick = "[lbCurSel 75805, false] call KPCF_fnc_applyPreset";
        };
        
        class KP_ButtonClearInventory: KPGUI_PRE_InlineButton {
            idc = 75834;
            text = "Vider";
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2) + safeZoneW * 0.14;
            y = safeZoneY + safeZoneH * 0.26296297;
            w = safeZoneW * 0.05458334;
            h = safeZoneH * 0.02407408;
            tooltip = "Vide complètement l'inventaire de la caisse";
            onButtonClick = "[] call KPCF_fnc_clearInventory";
        };

        class KP_ButtonAddPreset: KPGUI_PRE_InlineButton {
            idc = 75807;
            text = "Ajouter";
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            y = safeZoneY + safeZoneH * 0.26296297;
            w = safeZoneW * 0.06458334;
            h = safeZoneH * 0.02407408;
            tooltip = "Ajoute le préréglage à l'inventaire existant";
            onButtonClick = "[lbCurSel 75805, true] call KPCF_fnc_applyPreset";
        };

        // Equipment

        class KP_ComboEquipment: KPGUI_PRE_Combo {
            idc = 75810;
            x = safeZoneX + safeZoneW * 0.30208334;
            y = safeZoneY + safeZoneH * 0.23425926;
            w = safeZoneW * 0.196875;
            h = safeZoneH * 0.02407408;
            tooltip = "$STR_KPCF_TOOLTIPCATEGORY";
            onLBSelChanged = "[] call KPCF_fnc_createEquipmentList";
        };

        class KP_ComboWeapons: KP_ComboEquipment {
            idc = 75811;
            y = safeZoneY + safeZoneH * 0.26296297;
            tooltip = "$STR_KPCF_TOOLTIPWEAPONSELECTION";
            onLBSelChanged = "[] call KPCF_fnc_createSubList";
        };

        class KP_EquipmentList: KPGUI_PRE_ListBox {
            idc = 75812;
            x = safeZoneX + safeZoneW * 0.30208334;
            y = safeZoneY + safeZoneH * 0.29074075;
            w = safeZoneW * 0.171875;
            h = safeZoneH * 0.44814815;
        };

        class KP_ButtonAddEquipment: KPGUI_PRE_InlineButton {
            idc = 75813;
            text = "+ 1";
            x = safeZoneX + safeZoneW * 0.47604167;
            y = safeZoneY + safeZoneH * 0.29074075;
            w = safeZoneW * 0.02291667;
            h = safeZoneH * 0.10925926;
            onButtonClick = "[1] call KPCF_fnc_addEquipment";
        };

        class KP_ButtonAddEquipment5: KP_ButtonAddEquipment {
            idc = 75814;
            text = "+ 5";
            y = safeZoneY + safeZoneH * 0.40370371;
            onButtonClick = "[5] call KPCF_fnc_addEquipment";
        };

        class KP_ButtonAddEquipment10: KP_ButtonAddEquipment {
            idc = 75815;
            text = "+ 10";
            y = safeZoneY + safeZoneH * 0.51666667;
            onButtonClick = "[10] call KPCF_fnc_addEquipment";
        };

        class KP_ButtonAddEquipment20: KP_ButtonAddEquipment {
            idc = 75816;
            text = "+ 20";
            y = safeZoneY + safeZoneH * 0.62962963;
            onButtonClick = "[20] call KPCF_fnc_addEquipment";
        };

        // Inventory

        /*class KP_ExportName: KPGUI_PRE_EditBox {
            idc = 75820;
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            y = safeZoneY + safeZoneH * 0.29074075;
            w = safeZoneW * 0.196875;
            h = safeZoneH * 0.02407408;
            tooltip = "$STR_KPCF_TOOLTIPEXPORT";
        };

        class KP_ImportName: KPGUI_PRE_Combo {
            idc = 75821;
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            y = safeZoneY + safeZoneH * 0.33333334;
            w = safeZoneW * 0.196875;
            h = safeZoneH * 0.02407408;
            tooltip = "$STR_KPCF_TOOLTIPIMPORT";
        };

        class KP_ButtonExport: KPGUI_PRE_InlineButton {
            idc = 75824;
            text = "$STR_KPCF_EXPORT";
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            y = safeZoneY + safeZoneH * 0.31481481;
            w = safeZoneW * 0.196875;
            h = safeZoneH * 0.02407408;
            onButtonClick = "[] call KPCF_fnc_export";
        };

        class KP_ButtonImport: KP_ButtonExport {
            idc = 75825;
            text = "$STR_KPCF_IMPORT";
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            y = safeZoneY + safeZoneH * 0.35740741;
            w = safeZoneW * 0.16510417;
            onButtonClick = "[] call KPCF_fnc_import";
        };

        class KP_DeletePreset: KPGUI_PRE_CloseCross {
            idc = 75826;
            text = "KPCFCratefiller\KPCF\img\icon_recyclebin.paa";
            x = safeZoneX + safeZoneW * 0.68229167;
            y = safeZoneY + safeZoneH * 0.35740741;
            w = safeZoneW * 0.01979167;
            h = safeZoneH * 0.02407408;
            tooltip = "$STR_KPCF_TOOLTIPDELETE";
            action = "[] call KPCF_fnc_deletePreset";
        };*/

        class KP_InventoryList: KPGUI_PRE_ListBox {
            idc = 75822;
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2);
            y = safeZoneY + safeZoneH * 0.29074075;  // Même position y que A
            w = safeZoneW * 0.171875;
            h = safeZoneH * 0.44814815;              // Même hauteur que A
        };

        class KP_ButtonRemoveEquipment: KPGUI_PRE_InlineButton {
            idc = 75823;
            text = "- 1";
            // Déplacez le bouton plus près de la liste F
            x = safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2) + safeZoneW * 0.171875 + safeZoneW * 0.00208333;
            y = safeZoneY + safeZoneH * 0.29074075; // Aligné avec le bouton +1
            w = safeZoneW * 0.02291667;
            h = safeZoneH * 0.10925926; // Même hauteur que +1
            onButtonClick = "[1] call KPCF_fnc_removeEquipment";
        };
        class KP_ButtonRemoveEquipment5: KP_ButtonRemoveEquipment {
            idc = 75827;
            text = "- 5";
            y = safeZoneY + safeZoneH * 0.40370371; // Aligné avec le bouton +5
            onButtonClick = "[5] call KPCF_fnc_removeEquipment";
        };

        class KP_ButtonRemoveEquipment10: KP_ButtonRemoveEquipment {
            idc = 75828;
            text = "- 10";
            y = safeZoneY + safeZoneH * 0.51666667; // Aligné avec le bouton +10
            onButtonClick = "[10] call KPCF_fnc_removeEquipment";
        };

        class KP_ButtonRemoveEquipment20: KP_ButtonRemoveEquipment {
            idc = 75829;
            text = "- 20";
            y = safeZoneY + safeZoneH * 0.62962963; // Aligné avec le bouton +20
            onButtonClick = "[20] call KPCF_fnc_removeEquipment";
        };

        // Texte pour le niveau de remplissage (caché mais gardé pour compatibilité)
        class KP_ProgressText: KPGUI_PRE_Text {
            idc = 75833;
            text = "";
            x = 0;
            y = 0;
            w = 0;
            h = 0;
            show = 0;
        };

        // Barre de progression jaune (standard)
        class KP_ProgressBar_Yellow : KPGUI_PRE_ProgressBar {
            idc = 75830;
            x = safeZoneX + safeZoneW * 0.30208334;
            y = safeZoneY + safeZoneH * 0.739; // Déplace la barre plus haut
            w = (safeZoneX+safeZoneW*(0.3+(1*0.4+(2-1)*0.002)/2) + safeZoneW * 0.171875 + safeZoneW * 0.00208333 + safeZoneW * 0.02291667) - (safeZoneX + safeZoneW * 0.30208334);
            h = safeZoneH * 0.030;
            colorFrame[] = {0.2, 0.2, 0.2, 1};
            colorBar[] = {0.9294, 0.8392, 0.0471, 1}; // Jaune KP standard
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            textureBackground = "#(argb,8,8,3)color(0,0,0,0.5)";
            type = 8;
            style = 0;
            colorBackground[] = {0.2, 0.2, 0.2, 0.8};
        };

        // Barre de progression orange (>80%)
        class KP_ProgressBar_Orange : KP_ProgressBar_Yellow {
            idc = 75831;
            colorBar[] = {0.9, 0.65, 0.2, 1}; // Orange
        };

        // Barre de progression rouge (>100%)
        class KP_ProgressBar_Red : KP_ProgressBar_Yellow {
            idc = 75832;
            colorBar[] = {0.9, 0.2, 0.2, 1}; // Rouge
        };

    };

};
