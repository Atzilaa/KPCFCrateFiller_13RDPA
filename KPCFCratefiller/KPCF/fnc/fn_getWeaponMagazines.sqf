/*
    Killah Potatoes Cratefiller

    Description:
    Récupère les magazines compatibles avec une arme spécifique.

    Parameter(s):
        0: STRING - Classe de l'arme

    Returns:
    ARRAY - Tableau des magazines compatibles
*/

params [
    ["_weaponClass", "", [""]]
];

// Si aucune classe d'arme n'est fournie, retourner un tableau vide
if (_weaponClass isEqualTo "") exitWith {[]};

// Récupérer tous les magazines compatibles avec l'arme
private _compatibleMagazines = [];

// Obtenir les magazines compatibles à partir de la configuration
private _cfgWeapons = configFile >> "CfgWeapons" >> _weaponClass;
private _muzzles = getArray (_cfgWeapons >> "muzzles");

// Si l'arme n'a pas de muzzles explicites, utiliser seulement "this"
if (count _muzzles == 0) then {
    _muzzles = ["this"];
};

// Parcourir tous les muzzles et récupérer les magazines compatibles
{
    private _muzzle = _x;
    private _magazines = [];
    
    // Si le muzzle est "this", utiliser directement la config de l'arme
    if (_muzzle == "this") then {
        _magazines = getArray (_cfgWeapons >> "magazines");
    } else {
        // Sinon, utiliser la config du muzzle spécifique
        _magazines = getArray (_cfgWeapons >> _muzzle >> "magazines");
    };
    
    // Ajouter les magazines trouvés au tableau de résultats
    _compatibleMagazines append _magazines;
} forEach _muzzles;

// Supprimer les doublons
_compatibleMagazines = _compatibleMagazines arrayIntersect _compatibleMagazines;

// Retourner le tableau des magazines compatibles
_compatibleMagazines 