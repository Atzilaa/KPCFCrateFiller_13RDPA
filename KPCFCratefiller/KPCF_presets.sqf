/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Ajout de nouveaux presets personnalisés (Médicale, Munitions, Explosifs)
    - Ajustement des quantités pour optimiser le chargement
    - Ajout de presets spécifiques pour le ravitaillement
    - Intégration avec le nouveau système de gestion de charge
    - Ajout de commentaires détaillés pour chaque preset

    Description:
    Configuration file for the cratefiller presets.
    Defines all available presets and their contents.

    Parameter(s):
    NONE

    Returns:
    ARRAY - Array of all available presets with their items.
*/

// Tableau des préréglages disponibles
// Format: [Nom du préréglage, [items]]
// Format des items: [[classe, quantité], [classe, quantité], ...]

KPCF_presets = [
    // Sierra
    ["Sierra", [
["CUP_5Rnd_127x108_KSVK_M", 50], 
["CUP_10Rnd_762x51_CZ750", 30], 
["ACE_SpareBarrel", 2], 
["CUP_10Rnd_762x51_CZ750_Tracer", 30], 
["ACE_ATragMX", 1], 
["ACE_IR_Strobe_Item", 2], 
["ACE_Kestrel4500", 2], 
["ACE_Tripod", 2], 
["ACE_microDAGR", 2], 
["ACE_MapTools", 2], 
["ACE_Vector", 2], 
["ACE_Sandbag_empty", 5], 
["tfw_rf3080Item", 2], 
["ACE_RangeCard", 2], 
["ToolKit", 2]
    ]],
    
    // Caisse de munitions standard
    ["Medical", [
["ACE_painkillers", 20], 
["ACE_splint", 20], 
["ACE_epinephrine", 45], 
["ACE_adenosine", 45], 
["ACE_morphine", 45], 
["ACE_packingBandage", 100], 
["ACE_elasticBandage", 100], 
["ACE_bloodIV", 30], 
["ACE_bloodIV_250", 50], 
["ACE_bloodIV_500", 50], 
["FSGm_ItemMedicBagMil", 2], 
["ACE_tourniquet", 40], 
["ACE_quikclot", 100], 
["ACE_bodyBag", 10], 
["ACE_surgicalKit", 1], 
["ACE_personalAidKit", 1] 
    ]],
    
    // Munitions
    ["Munitions", [
       ["CUP_12Rnd_B_Saiga12_Buck_0", 5], 
["CUP_12Rnd_B_Saiga12_Slug", 5], 
["CUP_50Rnd_B_765x17_Ball_M", 4], 
["CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M", 20], 
["CUP_30Rnd_TE1_Green_Tracer_762x39_AK103_bakelite_M", 50], 
["CUP_30Rnd_762x39_AK15_Desert_M", 50], 
["CUP_30Rnd_TE1_Green_Tracer_762x39_AK15_Desert_M", 50], 
["CUP_30Rnd_762x39_AKM_bakelite_desert_M", 50], 
["CUP_30Rnd_TE1_Green_Tracer_762x39_AK47_M", 50], 
["CUP_30Rnd_TE1_Green_Tracer_762x39_AK47_bakelite_M", 50],
["CUP_30Rnd_TE1_Green_Tracer_762x39_AKM_bakelite_desert_M", 50], 
["CUP_8Rnd_762x25_TT", 10], 
["CUP_10Rnd_762x54_SVD_M", 20], 
["CUP_16Rnd_9x19_cz75", 10], 
["CUP_18Rnd_9x19_Phantom", 10], 
["CUP_30Rnd_9x19_Vityaz", 10], 
["CUP_30Rnd_762x39_AK103_bakelite_M", 50], 
["CUP_30Rnd_762x39_AK47_bakelite_M", 50], 
["CUP_30Rnd_762x39_AK47_M", 50], 
["CUP_10Rnd_9x19_Compact", 10], 
["16Rnd_9x21_Mag", 10], 
["CUP_75Rnd_TE4_LRT4_Green_Tracer_762x39_RPK_M", 20]
    ]],
    
    // Grenade/Explosif
    ["Grenade/Explosif", [
       ["CUP_1Rnd_HE_GP25_M", 40], 
["CUP_6Rnd_HE_GP25_M", 10], 
["tsp_breach_block_mag", 10], 
["tsp_breach_block_auto_mag", 10], 
["tsp_flashbang_cts2", 20], 
["Grenade_min_rf_rgd_5", 50], 
["tsp_breach_linear_mag", 10], 
["tsp_breach_linear_auto_mag", 10], 
["tsp_breach_popper_mag", 10], 
["tsp_breach_popper_auto_mag", 10], 
["SmokeShellBlue", 10], 
["SmokeShellYellow", 10], 
["SmokeShellRed", 10], 
["SmokeShellGreen", 30], 
["SmokeShell", 70], 
["ace_marker_flags_green", 10], 
["ACE_DefusalKit", 4], 
["ACE_wirecutter", 2], 
["CUP_PipeBomb_M", 10], 
["tsp_breach_silhouette_mag", 10], 
["tsp_breach_stick_mag", 10], 
["CUP_1Rnd_SMOKE_GP25_M", 10], 
["CUP_1Rnd_SmokeRed_GP25_M", 10], 
["CUP_FlareWhite_GP25_M", 10], 
["CUP_FlareRed_GP25_M", 10], 
["CUP_FlareGreen_GP25_M", 10], 
["tsp_breach_shock", 10], 
["ToolKit", 2],
["ACE_FlareTripMine_Mag",10],
["APERSTripMine_Wire_Mag",10]
    ]],

    // Munitions lanceur
    ["Munitions lanceur", [
       ["1Rnd_min_rf_9M336_missiles", 10], 
["RPG32_F", 10], 
["Titan_AT", 10], 
["CUP_OG7_M", 10], 
["CUP_PG7V_M", 10], 
["CUP_PG7VL_M", 10], 
["CUP_PG7VM_M", 10], 
["CUP_PG7VR_M", 10], 
["CUP_TBG7V_M", 10] 
    ]],

    //Mun métis
    ["Mun métis", [
       ["CUP_AT13_M", 10], 
["Vorona_HEAT", 10] 

    ]],
    //Divers
    ["Divers", [
["Laserdesignator", 5], 
["Rangefinder", 10], 
["ACE_Vector", 5], 
["ACE_IR_Strobe_Item", 10], 
["ACE_Banana", 10], 
["ACE_WaterBottle", 20], 
["ACE_rope36", 10], 
["ACE_NVG_Wide", 10], 
["ACE_NVG_Wide_WP", 10], 
["tsp_lockpick", 10], 
["ACE_Flashlight_XL50", 10], 
["ACE_microDAGR", 10], 
["ACE_Altimeter", 10], 
["ACE_Fortify", 10], 
["ACE_SpraypaintGreen", 10], 
["ACE_EntrenchingTool", 10], 
["tfw_rf3080Item", 10], 
["ACE_CableTie", 20], 
["min_rf_UavTerminal", 5], 
["ACE_EarPlugs", 10],
["ItemAndroid",10],
["ItemCTab",10], 
["ACE_SpareBarrel",5]

]],
    //Lanceurs
    ["Lanceurs", [
["launch_min_rf_verba", 5], 
["CUP_launch_Metis", 2], 
["launch_O_Vorona_green_F", 2], 
["CUP_launch_RPG26", 10], 
["launch_min_rf_RPG32", 2], 
["CUP_launch_RPG7V", 2], 
["CUP_launch_RShG2", 10]
]],

    //Inventaire VHL
    ["Inventaire VHL", [
["launch_min_rf_verba", 1], 
["CUP_launch_RPG26", 2], 
["CUP_launch_RShG2", 2], 
["CUP_1Rnd_HE_GP25_M", 5], 
["CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M", 5], 
["1Rnd_min_rf_9M336_missiles", 4], 
["CUP_30Rnd_762x39_AK103_bakelite_M", 25], 
["CUP_30Rnd_762x39_AK47_M", 25], 
["tsp_flashbang_cts2", 10], 
["Grenade_min_rf_rgd_5", 10], 
["SmokeShellBlue", 2], 
["SmokeShellYellow", 2], 
["SmokeShellRed", 2], 
["SmokeShellGreen", 10], 
["SmokeShell", 20], 
["CUP_75Rnd_TE4_LRT4_Green_Tracer_762x39_RPK_M", 5], 
["CUP_1Rnd_SmokeRed_GP25_M", 5], 
["ACE_WaterBottle", 2]
]]
]; 