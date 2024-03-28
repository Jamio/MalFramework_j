#include "script_component.hpp"

/*
    Author:
        Jamio

    Description:
        Creates Safezones for gunshots and grenades, adds fired event handler to players.

    Arguments:
        -

    Example:
        call MF_safezone_fnc_initSafezones

    Returns:
        void
*/

// Define custom message from config
private _sfZoneMessage = GVAR(safeMessage);

// Define safety zones and compile array of markers and distances
private _sfZones = GVAR(safeArea);

if (_sfZones isEqualTo []) exitWith {
   [COMPONENT_STR, "ERROR","The safezone array is empty. Please add safezones or disable the module.", true] call EFUNC(main,log);
};

_sfZones apply {
    _markerName = _x select 0;
    // Check if marker exists by comparing its position to [0,0,0], which is the default position for non-existent markers.
    if (getMarkerPos _markerName isEqualTo [0,0,0]) then {
        // Log or notify about the non-existent marker
        [COMPONENT_STR, "ERROR", format ["Safezone marker (%1) does not exist.", _markerName], true] call EFUNC(main,log);
    };
};

private _sfZones = GVAR(safeArea); // Redefine right before critical usage


if !(hasInterface) exitWith {};
waitUntil {!isNull player};

player addEventHandler ["Fired", {
    private _sfZones = GVAR(safeArea); // Redefine right before critical usage
    private _sfZoneMessage = GVAR(safeMessage);
    _isInSafeZone = false; // Default to not in a safezone
    {
        _distance = (_this select 0) distance getMarkerPos (_x select 0);
        if (_distance < _x select 1) then {
            _isInSafeZone = true; // Player is within a safezone
        };
    } forEach _sfZones; // Use forEach for iterating over the zones
    
    if (_isInSafeZone) then {
        deleteVehicle (_this select 6); // Delete the projectile
        titleText [_sfZoneMessage, "PLAIN", 3]; // Show the custom message
    };
}];
