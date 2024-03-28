#include "script_component.hpp"

if (!GVARMAIN(moduleSafezones)) exitWith {};

// Init the safezone
call FUNC(initSafezones);
