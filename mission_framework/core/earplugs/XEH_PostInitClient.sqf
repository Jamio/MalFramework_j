#include "script_component.hpp"

if !(GVARMAIN(moduleEarplugs)) exitWith {
    systemChat "Earplugs module is disabled.";
    diag_log "Earplugs module is disabled.";
};

systemChat "Earplugs XEH_PostInitClient starting...";
diag_log "Earplugs XEH_PostInitClient starting...";

[] call FUNC(initEarplugs);
systemChat "Called initEarplugs function.";
diag_log "Called initEarplugs function.";
