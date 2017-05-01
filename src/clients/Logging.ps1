########################################################
##
## Logging.ps1
## Client facade to infrastructure Pip.Services
## Logging commands
##
#######################################################

function Read-PipLog
{
<#
.SYNOPSIS

Reads messages from logging service

.DESCRIPTION

Reads a page of messages from logging service that satisfy specified criteria

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

Switch to read log messages as text

.EXAMPLE

# Read top 10 log messages containing "Invoice" from test cluster in text format
PS> Read-PipLog -Name "test" -Filter @{ Search="Invoice" } -Take 10 -AsText

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
        $route = "/api/1.0/logging"

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


function Read-PipErrors 
{
<#
.SYNOPSIS

Reads error messages from logging service

.DESCRIPTION

Gets a page of error messages from logging service that satisfy specified criteria

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

Switch to read traces as text

.EXAMPLE

# Get top 10 errors containing "Invoice" from test cluster in text format
PS> Read-PipErrors -Name "test" -Filter @{ search="Invoice" } -Take 10 -AsText

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
        $route = "/api/1.0/logging/errors"

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


function Write-PipLog
{
<#
.SYNOPSIS

Logs a message

.DESCRIPTION

Writes a message into logging service

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Message

A message with the following structure
- time: Date
- source: string
- evel: LogLevel - (0: None, 1: Fatal, 2: Error, 3: Warn, 4: Info, 5: Debug, 6: Trace)
- correlation_id: string
- error: ErrorDescription
- message: string

.EXAMPLE

# Write trace to test cluster
PS> Write-PipLog -Name "test" -Message @{ correlation_id="123"; level=2; source="Powershell" error=@{ message="Failed" }; message="Just a test" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $Message
    )
    begin {}
    process 
    {
        $route = "/api/1.0/logging"

        Invoke-PipFacade -Connection $Connection -Name $Name -Method "Post" -Route $route -Request $Message
    }
    end {}
}

function Clear-PipLog
{
<#
.SYNOPSIS

Clears all log messages on the server

.DESCRIPTION

Clears all log messages including errors on the server

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.EXAMPLE

# Clear log on test cluster
PS> Clear-PipLog -Name "test"

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
        $route = "/api/1.0/logging"

        Invoke-PipFacade -Connection $Connection -Name $Name -Method "Delete" -Route $route
    }
    end {}
}
