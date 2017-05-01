########################################################
##
## Counters.ps1
## Client facade to infrastructure Pip.Services
## Counters commands
##
#######################################################

function Read-PipCounters
{
<#
.SYNOPSIS

Reads performance counters from counters service

.DESCRIPTION

Reads a page of performance counters from counters service that satisfy specified criteria

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

.PARAMETER AsText

Switch to read performance counters as text

.EXAMPLE

# Read top 10 counters containing "Invoice" from test cluster in text format
PS> Read-PipCounters -Name "test" -Filter @{ search="Invoice" } -Take 10 -AsText

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
        [int] $Take = 100,
        [Parameter(Mandatory=$false, Position = 3, ValueFromPipelineByPropertyName=$true)]
        [bool] $Total,
        [Parameter(Mandatory=$false, Position = 4, ValueFromPipelineByPropertyName=$true)]
        [switch] $AsText
    )
    begin {}
    process 
    {
        $route = "/api/1.0/counters"

        $params = $Filter +
        @{ 
            skip = $Skip;
            take = $Take
            total = $Total
        }

        if ($AsText) 
        {
            $route += "/text"

            $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method "Get" -Route $route -Params $params -RawResult $true

            $result = $result -split "\r\n"
            Write-Output $result
        }
        else 
        {
            $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method "Get" -Route $route -Params $params

            Write-Output $result.Data
        }
    }
    end {}
}


function Write-PipCounter
{
<#
.SYNOPSIS

Writes a performance counter

.DESCRIPTION

Writes a performance counter into counters service

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Counter

A counter object with the following structure
- name: string
- type: CounterType (0: Interval, 1: LastValue, 2: Statistics, 3: Timestamp, 4: Increment)
- last: number
- count: number
- min: number
- max: number
- average: number
- time: Date

.EXAMPLE

# Write counter to test cluster
PS> Write-PipCount -Name "test" -Counter @{ name="test.total_calls"; type=4; count=1 }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $Counter
    )
    begin {}
    process 
    {
        $route = "/api/1.0/counters"

        Invoke-PipFacade -Connection $Connection -Name $Name -Method "Post" -Route $route -Request $Counter
    }
    end {}
}


function Clear-PipCounters
{
<#
.SYNOPSIS

Clears all performance counters on the server

.DESCRIPTION

Clears all performance counters on the server

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.EXAMPLE

# Clear coutners on test cluster
PS> Clear-PipCounters -Name "test"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name
    )
    begin {}
    process 
    {
        $route = "/api/1.0/counters"

        $null = Invoke-PipFacade -Connection $Connection -Name $Name -Method "Delete" -Route $route
    }
    end {}
}