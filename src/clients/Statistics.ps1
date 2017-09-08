########################################################
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

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/statistics/groups)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.PARAMETER Total

A include total count (default: false)

.EXAMPLE

Get-PipStatGroups

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/statistics/groups",
        [Parameter(Mandatory=$false, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [int] $Skip = 0,
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [int] $Take = 100
    )
    begin {}
    process 
    {
        $route = $Uri
        $params =
        @{ 
            skip = $Skip;
            take = $Take
        }

        $result = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params

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

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/statistics/counters)

.PARAMETER Filter

A filter with search criteria (default: no filter)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.EXAMPLE

Get-PipStatCounters

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/statistics/counters",
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

        $result = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params

        Write-Output $result.Data
    }
    end {}
}


function Read-PipStatCounter
{
<#
.SYNOPSIS

Gets set of counters values for specified time range

.DESCRIPTION

Gets value set for a counter or group of counterts at specified time horizon from/to time range

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/statistics/{0}/{1})

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

Read-PipStatCounter -Group test -Counter calls -Type "Hour" -From ([DateTime]::UtcNow.AddDays(-7)) -To ([DateTime]::UtcNow)

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/statistics/{0}",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
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
        $route = $Uri -f $Group
        if ($Counter -ne $null -and $Counter -ne '') {
            $route += "/" + $Counter
        }

        $params = @{
            type = $Type
            from_time = $From
            to_time = $To
        }

        $result = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params

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

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/statistics/{0}/{1})

.PARAMETER Group

A counter group

.PARAMETER Counter

A counter name

.PARAMETER Time

An increment time (Default: current time)

.PARAMETER Timezone

A timezone to calculate stats (Default: UTC)

.PARAMETER Value

An increment value (Default: 1)

.EXAMPLE

Add-PipStatCounter -Group test -Counter calls -Value 1

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/statistics/{0}/{1}",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Group,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Counter,
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [DateTime] $Time = $null,
        [Parameter(Mandatory=$false, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [string] $Timezone = $null,
        [Parameter(Mandatory=$false, Position = 3, ValueFromPipelineByPropertyName=$true)]
        [long] $Value = 1
    )
    begin {}
    process 
    {
        $route = $Uri -f $Group, $Counter
        $params = @{
            time = $Time;
            timezone = $Timezone;
            value = $Value 
        }

        Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params
    }
    end {}
}
