# KPCFCrateFiller13RDPA

Version personnalisée du système de gestion de caisses KP Cratefiller pour le 13ème RDPA. Cette modification améliore considérablement l'expérience utilisateur, la gestion des capacités des caisses et ajoute de nombreuses fonctionnalités pour faciliter la logistique dans vos missions Arma 3.

## Fonctionnalités implémentées

### Système de capacités amélioré
- **Capacités personnalisées** : Définissez des capacités spécifiques pour chaque type de caisse
- **Système de hook d'initialisation** : Application automatique des capacités aux caisses lors de leur création
- **Variables locales de capacité** : Possibilité de définir des capacités par caisse individuelle
- **Priorité intelligente** : Utilisation hiérarchique des capacités (personnalisées > variables locales > configuration par défaut)
- **Protection contre le dépassement** : Empêche l'ajout d'équipement au-delà de la capacité définie

### Interface utilisateur améliorée
- **Barre de progression avec code couleur** :
  - Jaune (< 50% de remplissage)
  - Orange (50-80% de remplissage)
  - Rouge (> 80% de remplissage ou dépassement)
- **Tooltips d'information** : Affiche le niveau exact de remplissage (X% - Y/Z)
- **Sons d'erreur** : Feedback audio lors du dépassement de capacité
- **Messages de statut détaillés** : Informations précises sur les actions effectuées
- **Feedback visuel** : Indication claire des limites atteintes

### Gestion des préréglages
- **Vérification de capacité pour les préréglages** : Empêche l'application de préréglages qui dépasseraient la capacité
- **Mode d'ajout** : Possibilité d'ajouter un préréglage à l'inventaire existant sans le remplacer
- **Statistiques détaillées** : Comptage par type d'objet (armes, munitions, objets, sacs à dos)
- **Gestion de masse optimisée** : Calcul précis de la charge pour chaque type d'équipement

### Système de débogage amélioré
- **Messages de débogage complets** : Informations détaillées sur les opérations effectuées
- **Journalisation avancée** : Toutes les étapes importantes sont enregistrées dans le journal
- **Traçage des erreurs** : Identification précise des problèmes lors de l'ajout/suppression d'équipement
- **Vérifications de sécurité** : Contrôles pour éviter les erreurs courantes

### Compatibilité et optimisation
- **Support pour les mods ACE et CBA** : Compatibilité avec les extensions populaires
- **Optimisation des performances** : Réduction de l'impact sur les performances du serveur
- **Structure modulaire** : Facilité d'extension et de personnalisation
- **Correction de bugs** : Résolution de problèmes présents dans la version originale

## Installation

1. Copiez le dossier `KPCFCratefiller` dans votre mission
2. Ajoutez ces lignes dans description.ext:

```//KPCF
#include "KPCFCratefiller\KPGUI\KPGUI_defines.hpp" 
#include "KPCFCratefiller\KPCF\ui\KPCF_dialog.hpp"

class CfgFunctions {
    #include "KPCFCratefiller\KPCF\KPCF_functions.hpp"
};
```
## Configuration des capacités personnalisées

Pour définir des capacités personnalisées pour vos caisses, modifiez le tableau `KPCF_crateCapacities` dans votre script d'initialisation :

```sqf
// Exemple de configuration personnalisée
KPCF_crateCapacities = [
    ["I_CargoNet_01_ammo_F", 31000],         // CargoNet OTAN (grande capacité)
    ["Box_IND_Ammo_F", 12000],               // Caisse de munitions standard
    ["Box_IND_AmmoOrd_F", 15000],            // Caisse d'explosifs
    ["Box_IND_WpsLaunch_F", 8000],           // Caisse de lanceurs
    ["ACE_medicalSupplyCrate_advanced", 5000] // Caisse médicale ACE
];
```

## Utilisation du système de hook

Le système de hook permet d'initialiser automatiquement des caisses avec des capacités personnalisées :

```sqf
// Exemple d'utilisation des hooks
KPCF_cratefiller_hooks = [
    ["I_CargoNet_01_ammo_F", 31000],
    ["Box_IND_Ammo_F", 12000]
];
```

## Dépannage

Si vous rencontrez des problèmes :
1. Vérifiez les messages de débogage dans le journal RPT
2. Assurez-vous que les capacités sont correctement définies
3. Vérifiez que les hooks sont correctement configurés
4. Consultez la documentation pour les cas particuliers

## Licence

Ce projet est une modification du KP Cratefiller original, publié sous licence GNU GPL v3.0.

## Crédits

- Développement original : [Dubjunk](https://github.com/KillahPotatoes)
- Modifications et améliorations : [13ème RDPA] Dylan

## Contribution

Les suggestions et contributions sont les bienvenues. N'hésitez pas à ouvrir des issues ou des pull requests sur le dépôt GitHub. 