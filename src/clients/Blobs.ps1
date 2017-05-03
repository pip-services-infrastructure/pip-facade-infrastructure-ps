########################################################
##
## Blobs.ps1
## Client facade to infrastructure Pip.Services
## Blob storage commands
##
#######################################################

function Get-PipBlobs 
{
<#
.SYNOPSIS

Gets list of blobs

.DESCRIPTION

Gets a page of blocks headers

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/blobs)


.PARAMETER Filter

A filter with search criteria (default: no filter)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.PARAMETER Total

A include total count (default: false)

.EXAMPLE

# Get all blobs from test server
PS> Get-PipBlobs -Name "test"

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
        [string] $Uri = "/api/1.0/blobs",
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
        $params = 
        @{ 
            filter = ConvertFilterParamsToString($Filter); 
            skip = $Skip;
            take = $Take
        }

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Params $params

        Write-Output $result.Data
    }
    end {}
}


function Get-PipBlob
{
<#
.SYNOPSIS

Gets a blob by its unique id

.DESCRIPTION

Gets header for a single blob by its unique id

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/blobs/{0})

.PARAMETER Id

A blob id

.EXAMPLE

# Get blob 123 info from test server
PS> Get-PipBlob -Name "test" -Id 123

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Put",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/blobs/{0}/info",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Id = @{}
    )
    begin {}
    process 
    {
        $route = $Uri -f $Id

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route

        Write-Output $result
    }
    end {}
}


function Update-PipBlob
{
<#
.SYNOPSIS

Updates blob header

.DESCRIPTION

Updates selected blob header fields

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Put')

.PARAMETER Uri

An operation uri (default: /api/1.0/blobs/{0}/info)

.PARAMETER Id

A blob id

.PARAMETER Group

A blob group

.PARAMETER File

A blob file name

.PARAMETER Completed

A completed flag (default: False)

.PARAMETER Expire

A blob expiration time (default: no expiration)

.EXAMPLE

# Updates blob group name and completed flad
PS> Update-PipBlob -Id 234 -Group test -Completed $false

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Put",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/blobs/{0}/info",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Id,
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [string] $Group,
        [Parameter(Mandatory=$false, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [string] $File,
        [Parameter(Mandatory=$false, Position = 3, ValueFromPipelineByPropertyName=$true)]
        [bool] $Completed,
        [Parameter(Mandatory=$false, Position = 4, ValueFromPipelineByPropertyName=$true)]
        [object] $Expire
    )
    begin {}
    process 
    {
        $info = Get-PipBlob -Connection $Connection -Name $Name -Id $Id

        if ($Group -ne "") { $info.group = $Group }
        if ($File -ne "") { $info.name = $File }
        if ($Completed -ne $null) { $info.completed = $Completed }
        if ($Expire -ne $null) { $info.expire_time = $Expire }

        $route = $Uri -f $Id

        Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Request $info
    }
    end {}
}


function Read-PipBlob
{
<#
.SYNOPSIS

Reads blob by id

.DESCRIPTION

Reads content of a blob identified by id

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/blobs/{0})

.PARAMETER Id

A blob id

.PARAMETER OutFile

Optional file name to write the blob to

.EXAMPLE

# Read blob to temp123.dat file
PS> Read-PipBlob -Name "test" -Id "123" -OutFile temp123.dat

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Put",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/blobs/{0}",
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Id,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $OutFile
    )
    begin {}
    process 
    {
        ## Get gateway session
        $Connection = if ($Connection -eq $null) { Get-PipConnection -Name $Name } else {$Connection}
        if ($Connection -eq $null) 
        {
            throw "PipConnection is not defined. Please, use Open-PipConnection or Select-PipConnection"
        }

        ## Read blob name if it is not set
        if ($OutFile -eq '') {
            $blob = Get-PipBlob -Connection $Connection -Id $Id
            $OutFile = $blob.name
        }

        ## Construct URI with parameters
        $route = $Uri -f $Id
        $uri = $Connection.Protocol + "://" + $Connection.Host + ":" + $Connection.Port + $Route;

        Invoke-WebRequest -Uri $uri -OutFile $OutFile -UseBasicParsing
    }
    end {}
}


function Write-PipBlob
{
<#
.SYNOPSIS

Writes a new blob

.DESCRIPTION

Creates a new blob and loads file as its content

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/blobs)

.PARAMETER Group

A blob group

.PARAMETER Completed

A completed flag (default: False)

.PARAMETER Expire

A blob expiration time (default: no expiration)

.PARAMETER InFile

A name of the file to read from

.EXAMPLE

# Write a new blob from a local file
PS> Write-PipBlob -Group test -InFile photo.jpg

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
        [string] $Uri = "/api/1.0/blobs",
        [Parameter(Mandatory=$false, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $Group,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $InFile,
        [Parameter(Mandatory=$false, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [switch] $Completed,
        [Parameter(Mandatory=$false, Position = 3, ValueFromPipelineByPropertyName=$true)]
        [object] $Expire
    )
    begin {}
    process 
    {
        $route = $Uri
        $params = @{
            group = $Group
            completed = $Completed
            expire_time = $Expire
        }

        Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -InFile $InFile -Params $params
    }
    end {}
}


function Remove-PipBlob
{
<#
.SYNOPSIS

Removes blob by its id

.DESCRIPTION

Removes blob identified by id

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Delete')

.PARAMETER Uri

An operation uri (default: /api/1.0/blobs/{0})

.PARAMETER Id

A blob id

.EXAMPLE

# Remove blob
PS> Remove-PipBlob -Name "test" -Id "123"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Delete",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/blobs/{0}",
        [Parameter(Mandatory=$True, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Id
    )
    begin {}
    process 
    {
        $route = $Uri -f $Id

        Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route
    }
    end {}
}
