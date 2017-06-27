########################################################
##
## EventLog.ps1
## Client facade to infrastructure Pip.Services
## Event log commands
##
#######################################################

function Read-PipEvents 
{
<#
.SYNOPSIS

Reads system events from event log

.DESCRIPTION

Gets a page of system evens from event log that satisfy specified criteria

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/eventlog)

.PARAMETER Filter

A filter with search criteria (default: no filter)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.PARAMETER Total

A include total count (default: false)

.EXAMPLE

Get-PipEvents -Filter @{ type="Failure" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/eventlog",
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


function Write-PipEvent
{
<#
.SYNOPSIS

Writes event into event log

.DESCRIPTION

Writes a single event into event log

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/eventlog)

.PARAMETER Event

An event to be written:
- id: string
- time: Date
- correlation_id: string
- source: string
- type: string
- severity: EventLogSeverityV1
- message: string
- details: Hashtable

.EXAMPLE

Write-PipEvent -Event @{ correlation_id="123"; type="Other"; message="Just a test event" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/eventlog",
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $Event
    )
    begin {}
    process 
    {
        $route = $Uri

        Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Request $Event
    }
    end {}
}
