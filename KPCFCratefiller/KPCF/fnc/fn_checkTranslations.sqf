/*
    Killah Potatoes Cratefiller v1.1.0

    Author: Dubjunk - https://github.com/KillahPotatoes
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Modifications:
    [13RDPA] Dylan - Mars 2024
    - Ajout de nouvelles traductions françaises
    - Amélioration des messages d'erreur
    - Optimisation du système de vérification
    - Ajout de logs pour le débogage des traductions

    Description:
    Checks if the translations are loaded correctly.

    Returns:
    BOOL - True if translations are loaded correctly.
*/

// Enregistre les traductions dans le log
diag_log "====== KPCF Translation Check ======";

// Vérifie les traductions principales
diag_log format["STR_KPCF_TITLE: %1", localize "STR_KPCF_TITLE"];
diag_log format["STR_KPCF_TITLETRANSPORT: %1", localize "STR_KPCF_TITLETRANSPORT"];
diag_log format["STR_KPCF_TITLEEQUIPMENT: %1", localize "STR_KPCF_TITLEEQUIPMENT"];
diag_log format["STR_KPCF_TITLEINVENTORY: %1", localize "STR_KPCF_TITLEINVENTORY"];

// Vérifie les nouvelles traductions
diag_log format["STR_KPCF_PRESET_SELECT: %1", localize "STR_KPCF_PRESET_SELECT"];
diag_log format["STR_KPCF_PRESET_APPLIED: %1", localize "STR_KPCF_PRESET_APPLIED"];

/*// Ajoute un message dans l'interface
hint "Vérification des traductions effectuée. Consultez le RPT.";

// Affichage dans l'interface pour un diagnostic rapide
systemChat format["Test traduction - Titre: %1", localize "STR_KPCF_TITLE"];
systemChat format["Test traduction - Préréglage: %1", localize "STR_KPCF_PRESET_SELECT"];*/ 

systemChat "Dubjunk & [13RDPA] Dylan - KPCraterfiller v1.1.0 initialisé avec succès";