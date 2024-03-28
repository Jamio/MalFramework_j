#include "script_component.hpp"

/*
   GrenadeStop v0.8 for ArmA 3 Alpha by Bake (tweaked slightly by Rarek)

   DESCRIPTION:
   Stops players from throwing grenades in safety zones.

   INSTALLATION:
   Move grenadeStop.sqf to your mission's folder. Then add the
   following line to your init.sqf file (create one if necessary):
   execVM "grenadeStop.sqf";

   CONFIGURATION:
   Edit the #defines below.
*/

// #define SAFETY_ZONES    [["safezone_marker1", 300]] // Syntax: [["marker1", radius1], ["marker2", radius2], ...]
// #define MESSAGE "FIRING or THROWING GRENADES is PROHIBITED at HQ"

// Define custom message from config
private _sfZoneMessage = GVAR(safezone_message);

// Define safety zones and compile array of markers and distances
private _sfZones = GVAR(safe_areas);

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



if !(hasInterface) exitWith {};
waitUntil {!isNull player};

player addEventHandler ["Fired", {
   if ({(_this select 0) distance getMarkerPos (_x select 0) < _x select 1} count _sfZones > 0) then
   {
       deleteVehicle (_this select 6);
       titleText [_sfZoneMessage, "PLAIN", 3];
   };
}];