<#
.Synopsis
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
#>
function Copy-VMWareTools
{
    [CmdletBinding()]
Param
    (
        # Path to save the downloaded file (defaults to TEMP)
        [string]
        $Path=$env:TEMP ,

        # Param2 help description
        [ValidateSet('AutoDetect','x64','x86','Both')]
        [string]
        $CPUType
    )

    Begin
    {

    function DoToolsExist ($TestPath)
    {
        if (Test-Path $TestPath)
            {
            Write-Warning -WarningAction Inquire "the file $TestPath already exists"
            }
    }

    $VMWAreurl = 'https://packages.vmware.com/tools/releases'
    $latest = (Invoke-WebRequest -Uri $VMWAreurl).links |select innerhtml  |select -Last 2 |select -First 1 -ExpandProperty innerhtml
    $Vmwarex64tool = (Invoke-WebRequest -Uri "$VMWAreurl/$latest/windows/x64").links.href | Where-Object {$_ -like '*.exe'}
    $Vmwarex86tool = (Invoke-WebRequest -Uri "$VMWAreurl/$latest/windows/x86").links.href | Where-Object {$_ -like '*.exe'}
    }
    Process
    {
    switch ($CPUType)
        {
        'AutoDetect' {if ([Environment]::Is64BitOperatingSystem){
                            DoToolsExist -TestPath "$path\$(($Vmwarex64tool).Split('/')[1])"
                            Invoke-WebRequest -Uri "$VMWAreurl/$latest/windows/$Vmwarex64tool" -OutFile "$path\$(($Vmwarex64tool).Split('/')[1])"
                            }
                        else {
                            Invoke-WebRequest -Uri "$VMWAreurl/$latest/windows/$Vmwarex86tool" -OutFile "$path\$(($Vmwarex86tool).Split('/')[1])"
                            }
                        }
        'x64'         {Invoke-WebRequest -Uri "$VMWAreurl/$latest/windows/$Vmwarex64tool" -OutFile "$path\$(($Vmwarex64tool).Split('/')[1])"}
        'x86'         {Invoke-WebRequest -Uri "$VMWAreurl/$latest/windows/$Vmwarex86tool" -OutFile "$path\$(($Vmwarex86tool).Split('/')[1])"}
        'Both'        {
                        Invoke-WebRequest -Uri "$VMWAreurl/$latest/windows/$Vmwarex86tool" -OutFile "$path\$(($Vmwarex86tool).Split('/')[1])"
                        Invoke-WebRequest -Uri "$VMWAreurl/$latest/windows/$Vmwarex64tool" -OutFile "$path\$(($Vmwarex64tool).Split('/')[1])"
                        }
            }
    }
    End
    {
    }
}