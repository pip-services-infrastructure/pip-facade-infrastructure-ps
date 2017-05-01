########################################################
##
## Registry.ps1
## Client facade to infrastructure Pip.Services
## Registry commands
##
#######################################################

function Get-PipRegistrySections
{
<#
.SYNOPSIS

Get section ids from registry

.DESCRIPTION

Gets a page of section ids from registry that satisfy specified criteria

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Filter

A filter with search criteria (default: no filter)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.EXAMPLE

# Get all sections from test cluster
PS> Get-PipRegistrySections -Name "test"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
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
        $route = "/api/1.0/registry/ids"
        $params = $Filter +
        @{ 
            skip = $Skip;
            take = $Take
        }

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method "Get" -Route $route -Params $params

        Write-Output $result.Data
    }
    end {}
}


function Read-PipRegistrySection
{
<#
.SYNOPSIS

Reads section from registry specified by its id

.DESCRIPTION

Gets requested section

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Section

A section id

.EXAMPLE

# Read section with settings for user 123 from test cluster
PS> Read-PipRegistrySection -Name "test" -Section 123

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Section
    )
    begin {}
    process 
    {
        $route = "/api/1.0/registry/$Section"

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Route $route

        $hash = ConvertObjectToHashtable($result)
        Write-Output $hash
    }
    end {}
}


function Write-PipRegistrySection
{
<#
.SYNOPSIS

Writes registry section specified by its is

.DESCRIPTION

Writes a hashtable into specified registry section

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Section

A section id

.PARAMETER Parameters

A section parameters

.EXAMPLE

# Write settings section for user 123 to test cluster
PS> Write-PipRegistrySection -Name "test" -Section 123 -Parameters @{ key1=123; key2="ABC" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Section,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $Parameters
    )
    begin {}
    process 
    {
        $route = "/api/1.0/registry/$Section"

        Invoke-PipFacade -Connection $Connection -Name $Name -Method "Post" -Route $route -Request $Parameters
    }
    end {}
}


function Read-PipRegistryParam
{
<#
.SYNOPSIS

Reads parameter from registry section

.DESCRIPTION

Reads a single parameter from specified registry section

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Section

A section id

.PARAMETER Key

A parameter key

.EXAMPLE

# Read language parameter for user 123 from test cluster
PS> Read-PipRegistryParam -Name "test" -Section 123 -Key "language"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Section,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Key
    )
    begin {}
    process 
    {
        $route = "/api/1.0/registry/$Section/$Key"

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Route $route

        Write-Output $result
    }
    end {}
}


function Write-PipRegistryParam
{
<#
.SYNOPSIS

Writes registry parameter 

.DESCRIPTION

Writes a single parameter into specified registry section

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Section

A section id

.PARAMETER Key

A parameter key

.PARAMETER Value

A parameter value

.EXAMPLE

# Set language parameter for user 123 to test cluster
PS> Write-PipRegistryParam -Name "test" -Section 123 -Key language -Value en

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
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
        $route = "/api/1.0/registry/$Section/$Key"
        $params = @{
            value = $Value
        }

        Invoke-PipFacade -Connection $Connection -Name $Name -Method "Post" -Route $route -Params $params
    }
    end {}
}


function Add-PipRegistryParam
{
<#
.SYNOPSIS

Increment registry parameter 

.DESCRIPTION

Increments a single parameter by specified count

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Section

A section id

.PARAMETER Key

A parameter key

.PARAMETER Count

An increment count

.EXAMPLE

# Increment attempt parameter for user 123 to test cluster
PS> Add-PipRegistryParam -Name "test" -Section 123 -Key attempt -Count 1

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Section,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Key,
        [Parameter(Mandatory=$true, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [object] $Count
    )
    begin {}
    process 
    {
        $route = "/api/1.0/registry/$Section/$Key/increment"
        $params = @{
            value = $Count
        }

        Invoke-PipFacade -Connection $Connection -Name $Name -Method "Post" -Route $route -Params $params
    }
    end {}
}