/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
    Configuration file for various variables of the KP cratefiller.
*/

// The Base object is for the player interaction, so at these object you can open the dialog
KPCF_cratefillerBase = [
    "Land_RepairDepot_01_civ_F"
];

// The Spawn object is the point where crates will spawn and acts the center for the KPCF_spawnRadius
KPCF_cratefillerSpawn = "HeliHEmpty";

// This variable defines if the player will be able to spawn and delete crates
KPCF_canSpawnAndDelete = true;

// If set to "true" the item lists will be generated from the config
KPCF_generateLists = false;

// These variable defines the range where inventories can be edited
// Example: With an setting of 10 all objects in a radius of 10m from the center of the spawn object can be edited
KPCF_spawnRadius = 25;

// Defines the distance for the interaction (addAction / ACE)
KPCF_interactRadius = 5;

// Defines the available crates
KPCF_crates = [
"Box_IND_Ammo_F", 
"Box_IND_AmmoOrd_F", 
"Box_IND_WpsLaunch_F", 
"Box_AAF_Equip_F", 
"I_CargoNet_01_ammo_F", 
"ACE_medicalSupplyCrate_advanced"
];

KPCF_crateCapacities = [
    ["Box_IND_Ammo_F", 7000, "this setMaxLoad 7000; diag_log format ['KPCF: Capacité personnalisée appliquée pour %1', typeOf this];"],
    ["Box_IND_AmmoOrd_F", 4100, "this setMaxLoad 4100; diag_log format ['KPCF: Capacité personnalisée appliquée pour %1', typeOf this];"], 
    ["Box_IND_WpsLaunch_F", 7000, "this setMaxLoad 7000; diag_log format ['KPCF: Capacité personnalisée appliquée pour %1', typeOf this];"], 
    ["I_CargoNet_01_ammo_F", 31000, "this setMaxLoad 31000; diag_log format ['KPCF: Capacité personnalisée appliquée pour %1', typeOf this];"],
    ["ACE_medicalSupplyCrate_advanced", 2000, "this setMaxLoad 2000; if (isClass (configFile >> 'CfgPatches' >> 'ace_cargo')) then { this setVariable ['ace_cargo_size', 1, true]; this setVariable ['ace_cargo_space', 2000, true]; [this, 1] call ace_cargo_fnc_setSize; [this, 2000] call ace_cargo_fnc_setSpace; };"]
];

// Defines the blacklisted items
// Blacklisted items are used on every category with activated generatedLists and everytime on the magazines and attachments
// So this variable will ensure the block of unwanted items
KPCF_blacklistedItems = [
    ""
];

// ----- This Variable will only be used with activated generatedLists -----

// Defines the whitelisted items
// Whitelisted items will be added after the item detection to ensure the availability
KPCF_whitelistedItems = [
    ""
    ];

// ----- Defines allowed magazines -----
// Only these magazines will be shown in the magazine list for compatible weapons
KPCF_allowedMagazines = [
    "CUP_PG7V_M","CUP_30Rnd_TE1_Green_Tracer_762x39_AK47_M","CUP_75Rnd_TE4_LRT4_Green_Tracer_762x39_RPK_M","Vorona_HEAT","CUP_PG7VR_M","Titan_AT","16Rnd_9x21_green_Mag","CUP_1Rnd_SmokeRed_GP25_M","CUP_10Rnd_9x19_Compact","16Rnd_9x21_red_Mag","16Rnd_9x21_yellow_Mag","RPG32_HE_F","CUP_30Rnd_TE1_Green_Tracer_762x39_AKM_bakelite_desert_M","1Rnd_min_rf_9M336_missiles","CUP_PG7VM_M","CUP_30Rnd_TE1_Green_Tracer_762x39_AK103_bakelite_M","CUP_10Rnd_762x54_SVD_M","CUP_18Rnd_9x19_Phantom","CUP_30Rnd_762x39_AK103_bakelite_M","CUP_30Rnd_762x39_AK47_bakelite_M","CUP_30Rnd_762x39_AKM_bakelite_desert_M","CUP_10Rnd_762x51_CZ750_Tracer","CUP_1Rnd_SMOKE_GP25_M","CUP_5Rnd_127x108_KSVK_M","16Rnd_9x21_Mag","CUP_PG7VL_M","CUP_TBG7V_M","CUP_10Rnd_762x51_CZ750","RPG32_F","CUP_6Rnd_SmokeRed_GP25","CUP_30Rnd_762x39_AK15_M","CUP_30Rnd_9x19_Vityaz","CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M","CUP_8Rnd_762x25_TT","CUP_6Rnd_HE_GP25_M","10Rnd_762x54_Mag","CUP_16Rnd_9x19_cz75","Titan_AP","CUP_AT13_M","CUP_OG7_M","Titan_AA","Vorona_HE","CUP_1Rnd_HE_GP25_M","CUP_30Rnd_TE1_Green_Tracer_762x39_AK47_bakelite_M","CUP_30Rnd_762x39_AK47_M","CUP_12Rnd_B_Saiga12_Slug","CUP_12Rnd_B_Saiga12_Buck_0","ACE_10Rnd_762x54_Tracer_mag","CUP_FlareWhite_GP25_M","CUP_FlareRed_GP25_M","CUP_FlareGreen_GP25_M","ace_csw_50Rnd_127x108_mag","CUP_compats_29Rnd_30mm_AGS30_M","CUP_30Rnd_TE1_Green_Tracer_762x39_AK15_Desert_M","CUP_30Rnd_762x39_AK15_Desert_M","CUP_6Rnd_Smoke_GP25","CUP_50Rnd_B_765x17_Ball_M","Laserbatteries"
];

// ----- Defines allowed muzzle devices -----
// Only these muzzle devices will be shown in the attachment list for compatible weapons
KPCF_allowedMuzzles = [
    "CUP_muzzle_snds_SA61","CUP_muzzle_snds_KZRZP_AK762","CUP_muzzle_mfsup_Flashhider_PK_Tan","CUP_muzzle_Bizon","CUP_muzzle_snds_KZRZP_SVD","muzzle_snds_L","CUP_muzzle_snds_KZRZP_AK762_desert","CUP_muzzle_mfsup_Flashhider_762x39_Black","CUP_muzzle_snds_KZRZP_SVD_desert","CUP_muzzle_mfsup_Flashhider_762x39_Tan","CUP_muzzle_snds_KZRZP_PK","CUP_muzzle_snds_socom762rc","CUP_muzzle_mfsup_Flashhider_PK_Black","CUP_muzzle_snds_KZRZP_PK_desert"
];

// ----- Defines allowed optics -----
// Only these optics will be shown in the attachment list for compatible weapons
KPCF_allowedOptics = [
    "CUP_optic_1p63","CUP_optic_1P87_RIS","CUP_optic_1P87_RIS_desert","CUP_optic_1P87_1P90_BLK","CUP_optic_Aimpoint_5000","CUP_optic_CompM4","CUP_optic_AIMM_COMPM4_BLK","CUP_optic_MicroT1","CUP_optic_MicroT1_low","CUP_optic_AIMM_MICROT1_BLK","CUP_optic_AC11704_Black","CUP_optic_AC11704_Tan","optic_DMS","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","CUP_optic_Elcan_SpecterDR_RMR_black","CUP_optic_Elcan_SpecterDR_KF_RMR","CUP_optic_Elcan_SpecterDR_RMR","CUP_optic_Elcan_reflex","CUP_optic_Eotech533","CUP_optic_Eotech553_Black","CUP_optic_G33_HWS_BLK","CUP_optic_G33_HWS_TAN","CUP_optic_ISM1400A7_tan","CUP_optic_ISM1400A7","optic_MRCO","CUP_optic_LeupoldMk4_10x40_LRT_Desert","CUP_optic_LeupoldMk4","CUP_optic_LeupoldMk4_MRT_tan","CUP_optic_LeupoldM3LR","CUP_optic_LeupoldMk4_20x40_LRT","CUP_optic_LeupoldMk4_25x50_LRT","CUP_optic_LeupoldMk4_25x50_LRT_DESERT","optic_Hamr","CUP_optic_CompM2_Coyote","CUP_optic_CompM2_Black","CUP_optic_CompM2_low","CUP_optic_CompM2_low_coyote","CUP_optic_MARS","CUP_optic_MARS_tan","CUP_optic_AIMM_MARS_TAN","CUP_optic_AIMM_MARS_BLK","CUP_optic_MEPRO","CUP_optic_MEPRO_moa_clear","CUP_optic_MEPRO_openx_orange","CUP_optic_MEPRO_tri_clear","CUP_optic_OKP_7_rail","CUP_optic_OKP_7_d_rail","CUP_optic_PGO7V3","CUP_optic_ACOG","CUP_optic_ACOG_Reflex_Desert","CUP_optic_TrijiconRx01_black","CUP_optic_TrijiconRx01_desert","CUP_optic_TrijiconRx01_kf_black","CUP_optic_TrijiconRx01_kf_desert","CUP_optic_NSPU","CUP_optic_PSO_1","CUP_optic_PechenegScope","CUP_optic_PSO_1_AK","CUP_optic_PSO_1_1","CUP_optic_PSO_3","CUP_optic_PSO_1_open","CUP_optic_PSO_1_AK_open","CUP_optic_PSO_1_1_open","CUP_optic_PSO_3_open","CUP_optic_ZeissZPoint","CUP_optic_ZeissZPoint_desert","CUP_optic_VortexRazor_UH1_Black","CUP_optic_VortexRazor_UH1_Tan","CUP_optic_RCO_PCAP","CUP_optic_RCO_PCAP_tan","CUP_optic_Kobra","CUP_optic_SB_3_12x50_PMII_Tan","CUP_optic_MicroT1_coyote","CUP_optic_HoloDesert","CUP_optic_ACOG_TA01NSN_RMR_Tan","CUP_optic_ACOG_TA648_308_RDS_Black","CUP_optic_Elcan_SpecterDR_KF_RMR_black","CUP_optic_AIMM_COMPM2_BLK","CUP_optic_ACOG_TA01NSN_RMR_Black","CUP_optic_ACOG_TA01B_RMR_Black","CUP_optic_NSPU_RPG","optic_LRPS","CUP_optic_HoloBlack","CUP_optic_ACOG_TA01B_RMR_Tan","CUP_optic_SB_11_4x20_PM_tan","CUP_optic_Leupold_VX3","CUP_optic_AIMM_COMPM2_TAN","CUP_optic_AIMM_M68_BLK","CUP_optic_MicroT1_low_coyote","CUP_optic_AIMM_ZDDOT_BLK","CUP_optic_ACOG_TA648_308_RDS_Desert","CUP_optic_AIMM_M68_TAN","CUP_optic_SB_11_4x20_PM","CUP_optic_ZDDot","CUP_optic_SB_3_12x50_PMII","CUP_optic_AIMM_MICROT1_TAN","CUP_optic_Elcan_reflex_Coyote"
];

// ----- Defines allowed accessory rails -----
// Only these rail attachments will be shown in the attachment list for compatible weapons
KPCF_allowedRailAttachments = [
   "CUP_acc_ANPEQ_15_Black","CUP_acc_ANPEQ_15_Black_Top","CUP_acc_ANPEQ_15","CUP_acc_ANPEQ_15_Tan_Top","CUP_acc_ANPEQ_15_Flashlight_Black_L","CUP_acc_ANPEQ_15_Flashlight_Tan_L","CUP_acc_ANPEQ_15_Top_Flashlight_Black_L","CUP_acc_ANPEQ_15_Top_Flashlight_Tan_L","CUP_acc_LLM01_desert_L","CUP_acc_LLM01_L","CUP_acc_LLM_black","CUP_acc_LLM"
];

// ----- Defines allowed bipods -----
// Only these bipods will be shown in the attachment list for compatible weapons
KPCF_allowedBipods = [
    "CUP_bipod_Harris_1A2_L_BLK","CUP_decal_BallisticShield_Militia_Yellow","CUP_bipod_VLTOR_Modpod","CUP_bipod_VLTOR_Modpod_black"
];

// ----- Defines all allowed attachments -----
// This combines all allowed attachments for easier filtering
KPCF_allowedAttachments = KPCF_allowedMuzzles + KPCF_allowedOptics + KPCF_allowedRailAttachments + KPCF_allowedBipods;

// ----- These Variables will be replaced with activated generatedLists -----

// Armes + Armes de poing + Lanceurs + Statiques

KPCF_weapons = [
    "CUP_hgun_CZ75","CUP_hgun_Compact","CUP_hgun_Duty","CUP_hgun_Phantom","CUP_hgun_TT","CUP_glaunch_6G30","CUP_arifle_AK103_railed","CUP_arifle_AK103_GL_railed","CUP_arifle_AK104_railed","CUP_arifle_AK109_railed","CUP_arifle_AK15_black","CUP_arifle_AK15_arid","CUP_arifle_AK15_VG_arid","CUP_arifle_AK15_VG_black","CUP_arifle_AK15_GP34_black","CUP_arifle_AK15_GP34_arid","CUP_arifle_AKM_GL_top_rail","CUP_arifle_AKMN_railed_desert","CUP_arifle_AKMN_railed","CUP_smg_BallisticShield_PP19","CUP_smg_BallisticShield_Sa61","CUP_srifle_CZ750","CUP_lmg_PKM_top_rail_B50_vfg","CUP_lmg_Pecheneg_top_rail_B50_vfg","CUP_sgun_Saiga12K_top_rail","CUP_srifle_SVD_top_rail","CUP_srifle_ksvk","CUP_arifle_RPK74_top_rail","launch_min_rf_verba","ace_csw_kordCarryTripod","ace_csw_kordCarryTripodLow","CUP_DSHKM_carry","CUP_KORD_carry","CUP_SPG9_carry","CUP_2b14_carry","ace_csw_spg9CarryTripod","ace_csw_carryMortarBaseplate","CUP_AGS30_carry","ace_csw_sag30CarryTripod","CUP_launch_Metis","launch_O_Vorona_green_F","CUP_launch_RPG7V","launch_min_rf_RPG32","CUP_launch_RShG2","CUP_launch_RPG26","launch_I_Titan_short_F"
];

// Defines the available grenades
KPCF_grenades = [
"Grenade_min_rf_rgd_5","SmokeShellBlue","SmokeShellYellow","SmokeShellRed","SmokeShellGreen","SmokeShell","O_R_IR_Grenade","tsp_flashbang_cts2"
];

// Defines the available explosives
KPCF_explosives = [
"tsp_breach_package_mag","tsp_breach_block_mag","tsp_breach_linear_mag","tsp_breach_linear_auto_mag","tsp_breach_block_auto_mag","tsp_breach_popper_mag","tsp_breach_popper_auto_mag","CUP_PipeBomb_M","tsp_breach_silhouette_mag","tsp_breach_stick_mag","CUP_MineE_M"
];

// Defines the available items
KPCF_items = [
"ACE_Vector","Rangefinder","Laserdesignator","ItemMap","ItemCompass","TFAR_anprc152","ACE_Altimeter","ItemAndroid","ItemcTab","min_rf_UavTerminal","ACE_EarPlugs","cigs_lighter","ItemcTabHCam","ACE_SpareBarrel","ACE_WaterBottle","ACE_rope12","ACE_rope15","ACE_rope18","ACE_rope27","ACE_rope3","ACE_rope36","ACE_rope6","ACE_bloodIV","ACE_bloodIV_250","ACE_bloodIV_500","MineDetector","ACE_M26_Clacker","ace_marker_flags_green","FSGm_ItemMedicBagMil","ACE_tourniquet","ACE_Flashlight_MX991","ACE_Kestrel4500","ACE_DefusalKit","ACE_Tripod","tsp_lockpick","ACE_SpottingScope","ACE_Flashlight_XL50","ACE_microDAGR","cigs_morley_cigpack","ACE_Fortify","ACE_MapTools","ACE_quikclot","ACE_SpraypaintGreen","ACE_EntrenchingTool","ACE_wirecutter","ItemAndroidMisc","ACE_Sandbag_empty","ACE_bodyBag","tfw_rf3080Item","ACE_CableTie","tsp_breach_shock","ACE_RangeCard","ACE_RangeTable_82mm","ACE_artilleryTable","ItemcTabMisc","ToolKit","ACE_surgicalKit","ACE_personalAidKit","tfw_blade","tfw_whip","tfw_dd","CUP_G_ESS_BLK_Dark","CUP_G_ESS_BLK_Ember","CUP_G_ESS_BLK","CUP_G_ESS_CBR_Dark","CUP_G_ESS_CBR_Ember","CUP_G_ESS_CBR","CUP_G_ESS_RGR_Dark","CUP_G_ESS_RGR_Ember","CUP_G_ESS_RGR","CUP_G_ESS_KHK_Dark","CUP_G_ESS_KHK_Ember","CUP_G_ESS_KHK","CUP_G_ESS_BLK_Scarf_Grn","CUP_G_ESS_KHK_Scarf_Tan","CUP_G_Oakleys_Drk","CUP_G_Oakleys_Embr","CUP_G_Oakleys_Clr","CUP_G_Grn_Scarf_Shades","CUP_G_Tan_Scarf_Shades","CUP_FR_NeckScarf","CUP_FR_NeckScarf2","ACE_NVG_Wide","ACE_NVG_Wide_WP","ACE_splint","ACE_epinephrine","ACE_adenosine","ACE_morphine","ACE_IR_Strobe_Item","ACE_Banana","ACE_packingBandage","ACE_painkillers","ACE_elasticBandage","ACE_ATragMX"
];

// Defines the available backpacks
KPCF_backpacks = [
"tfw_ilbe_DD_mc","ACE_TacticalLadder_Pack","min_rf_backpack_green","min_rf_torna_green","tfw_ilbe_DD_gr"
];

// ----- Définir les compatibilités manuelles -----
// Cette variable permet de définir quels accessoires sont compatibles avec quelles armes
// Format: [modèle d'arme ou classe parent, [accessoire1, accessoire2, ...]]
KPCF_manualCompatibility = [
    // Compatibilité par modèle d'arme (utilise la fonction de recherche partielle)
    
   // ["AK15", ["CUP_bipod_Harris_1A2_L_BLK", "CUP_bipod_VLTOR_Modpod", "CUP_bipod_VLTOR_Modpod_black"]],
   // ["AK10", ["CUP_bipod_Harris_1A2_L_BLK", "CUP_bipod_VLTOR_Modpod", "CUP_bipod_VLTOR_Modpod_black"]]
    
    // Vous pouvez facilement ajouter d'autres familles d'armes ici
    // ["Modèle_Arme", ["accessoire1", "accessoire2"]]
];

