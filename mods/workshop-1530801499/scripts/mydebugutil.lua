local debugutil = {}

function debugutil.print(...)
  local modname = (global('env') and env.modname) or ModManager.currentlyloadingmod or "unknown mod"
  print(ModInfoname(modname), ...)
end

return debugutil
