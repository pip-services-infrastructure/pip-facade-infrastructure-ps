﻿########################################################
##
## Statistics.ps1
## Client facade to infrastructure Pip.Services
## Statistics commands
##
#######################################################

function Get-PipStatGroups
{
<#
.SYNOPSIS

Get groups from statistics

.DESCRIPTION

Gets a page of groups from statistics

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.EXAMPLE

# Get statistic groups from test cluster
PS> Get-PipStatGroups -Name "test"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [int] $Skip = 0,
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [int] $Take = 100
    )
    begin {}
    process 
    {
        $route = "/api/1.0/statistics/groups"
        $params =
        @{ 
            skip = $Skip;
            take = $Take
        }

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method "Get" -Route $route -Params $params

        Write-Output $result.Data
    }
    end {}
}


function Get-PipStatCounters
{
<#
.SYNOPSIS

Get counters from statistics

.DESCRIPTION

Gets a page of counters from statistics that satisfy specified criteria

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

# Get all statistic counters from test cluster
PS> Get-PipStatCounters -Name "test"

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
        $route = "/api/1.0/statistics/counters"
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


function Read-PipStatCounter
{
<#
.SYNOPSIS

Gets set of counter values for specified time range

.DESCRIPTION

Gets value set for a counter at specified time horizon from/to time range

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Group

A counter group

.PARAMETER Counter

A counter name

.PARAMETER Type

A counter type - (0: Total, 1: Year, 2: Month, 3: Day, 4: Hour) (default: Total)

.PARAMETER From

A start of the time range

.PARAMETER To

An end of the time range

.EXAMPLE

# Get hourly counters for test calls for the last week
PS> Read-PipStatCounter -Name "test" -Group test -Counter calls -Type "Hour" -From ([DateTime]::UtcNow.AddDays(-7)) -To ([DateTime]::UtcNow)

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, Position, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Group,
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Counter,
        [Parameter(Mandatory=$false, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $Type = 0,
        [Parameter(Mandatory=$false, Position = 3, ValueFromPipelineByPropertyName=$true)]
        [object] $From = [DateTime]::UtcNow.AddHours(-1),
        [Parameter(Mandatory=$false, Position = 4, ValueFromPipelineByPropertyName=$true)]
        [object] $To = [DateTime]::UtcNow
    )
    begin {}
    process 
    {
        $route = "/api/1.0/statistics/$Group/$Counter"
        $params = @{
            type = $Type
            from_time = $From
            to_time = $To
        }

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method "Get" -Route $route -Params $params

        Write-Output $result
    }
    end {}
}


function Add-PipStatCounter
{
<#
.SYNOPSIS

Increments statistics counter by provided value

.DESCRIPTION

Increments statistics counter by value, updates totals at all different time horizons

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Group

A counter group

.PARAMETER Counter

A counter name

.PARAMETER Value

An increment value (Default: 1)

.EXAMPLE

# Increment test calls counter
PS> Add-PipStatCounter -Name "test" -Group test -Counter calls -Value 1

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, Position, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Group,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Counter,
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [long] $Value = 1
    )
    begin {}
    process 
    {
        $route = "/api/1.0/statistics/$Group/$Counter"
        $params = @{ value = $Value }

        Invoke-PipFacade -Connection $Connection -Name $Name -Method "Post" -Route $route -Params $params
    }
    end {}
}