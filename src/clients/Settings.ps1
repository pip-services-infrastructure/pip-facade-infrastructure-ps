########################################################
##
## Settings.ps1
## Client facade to infrastructure Pip.Services
## Settings commands
##
#######################################################

function Get-PipSettingsSections
{
<#
.SYNOPSIS

Get section ids from settings

.DESCRIPTION

Gets a page of section ids from settings that satisfy specified criteria

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/settings/ids)

.PARAMETER Filter

A filter with search criteria (default: no filter)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.PARAMETER Total

A include total count (default: false)

.EXAMPLE

# Get all sections from test cluster
PS> Get-PipSettingsSections -Name "test"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/settings/ids",
        [Parameter(Mandatory=$false, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Filter = @{},
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [int] $Skip = 0,
        [Parameter(Mandatory=$false, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [int] $Take = 100
    )
    begin {}
    process 
    {
        $route = $Uri
        $params = $Filter +
        @{ 
            skip = $Skip;
            take = $Take
        }

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Params $params

        Write-Output $result.Data
    }
    end {}
}


function Read-PipSettingsSection
{
<#
.SYNOPSIS

Reads section from settings specified by its id

.DESCRIPTION

Gets requested section

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/settings/{0})

.PARAMETER Section

A section id

.EXAMPLE

# Read section with settings for user 123 from test cluster
PS> Read-PipSettingsSection -Name "test" -Section 123

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/settings/{0}",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Section
    )
    begin {}
    process 
    {
        $route = $Uri -f $Section

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route

        $hash = ConvertObjectToHashtable($result)
        Write-Output $hash
    }
    end {}
}


function Write-PipSettingsSection
{
<#
.SYNOPSIS

Writes settings section specified by its is

.DESCRIPTION

Writes a hashtable into specified settings section

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/settings/{0})

.PARAMETER Section

A section id

.PARAMETER Parameters

A section parameters

.EXAMPLE

# Write settings section for user 123 to test cluster
PS> Write-PipSettingsSection -Name "test" -Section 123 -Parameters @{ key1=123; key2="ABC" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/settings/{0}",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Section,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $Parameters
    )
    begin {}
    process 
    {
        $route = $Uri -f $Section

        Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Request $Parameters
    }
    end {}
}


function Read-PipSettingsParam
{
<#
.SYNOPSIS

Reads parameter from settings section

.DESCRIPTION

Reads a single parameter from specified settings section

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/settings/{0}/{1})

.PARAMETER Section

A section id

.PARAMETER Key

A parameter key

.EXAMPLE

# Read language parameter for user 123 from test cluster
PS> Read-PipSettingsParam -Name "test" -Section 123 -Key "language"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/settings/{0}/{1}",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Section,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Key
    )
    begin {}
    process 
    {
        $route = $Uri -f $Section, $Key

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route

        Write-Output $result
    }
    end {}
}


function Write-PipSettingsParam
{
<#
.SYNOPSIS

Writes settings parameter 

.DESCRIPTION

Writes a single parameter into specified settings section

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/settings/{0}/{1})

.PARAMETER Section

A section id

.PARAMETER Key

A parameter key

.PARAMETER Value

A parameter value

.EXAMPLE

# Set language parameter for user 123 to test cluster
PS> Write-PipSettingsParam -Name "test" -Section 123 -Key language -Value en

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/settings/{0}/{1}",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Section,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Key,
        [Parameter(Mandatory=$true, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [object] $Value
    )
    begin {}
    process 
    {
        $route = $Uri -f $Section, $Key
        $params = @{
            value = $Value
        }

        Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Params $params
    }
    end {}
}


function Add-PipSettingsParam
{
<#
.SYNOPSIS

Increment settings parameter 

.DESCRIPTION

Increments a single parameter by specified count

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/settings/{0}/{1}/increment)

.PARAMETER Section

A section id

.PARAMETER Key

A parameter key

.PARAMETER Value

An increment count

.EXAMPLE

# Increment attempt parameter for user 123 to test cluster
PS> Add-PipSettingsParam -Name "test" -Section 123 -Key attempt -Count 1

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/settings/{0}/{1}/increment",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Section,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Key,
        [Parameter(Mandatory=$true, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [object] $Value
    )
    begin {}
    process 
    {
        $route = $Uri -f $Section, $Key
        $params = @{
            value = $Value
        }

        Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Params $params
    }
    end {}
}