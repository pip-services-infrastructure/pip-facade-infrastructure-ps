########################################################
##
## pip-facade-infrastructure-ps.ps1
## Client facade to infrastructure Pip.Services
## Powershell module entry
##
#######################################################

$path = $PSScriptRoot
if ($path -eq "") { $path = "." }

. "$($path)/src/clients/Logging.ps1"
. "$($path)/src/clients/Counters.ps1"
. "$($path)/src/clients/Settings.ps1"
. "$($path)/src/clients/Statistics.ps1"
. "$($path)/src/clients/EventLog.ps1"
. "$($path)/src/clients/Blobs.ps1"
