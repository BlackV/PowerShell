<#
.Synopsis
   Function to export a VM and and clean the export folder
.DESCRIPTION
   Take VM(s) from pipeline or vairable, export the VM(s) to a path
   then cleanup old VM(s) in that path larger than the retention value (default 5)
.EXAMPLE
   Invoke-VMExport -VM test -Path c:\temp -Retention 5
   Will export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
   i.e. C:\temp\test\20180915\
.EXAMPLE
   Get-VM test | Invoke-VMExport -Path c:\temp -Retention 5
   Hyper-V\Get-VM module gets the VM and passes it through the pipeline to Invoke-VMExport
   to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
   i.e. C:\temp\test\20180915\
.EXAMPLE
   'test' | Invoke-VMExport -Path c:\temp -Retention 5
   gets the VM as a string and passes it through the pipeline to Invoke-VMExport
   to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
   i.e. C:\temp\test\20180915\
.EXAMPLE
   Get-VM test, test2 | Invoke-VMExport -Path c:\temp -Retention 5
   Hyper-V\Get-VM module gets the VMs and passes it through the pipeline to Invoke-VMExport
   to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
   i.e. C:\temp\test\20180915\
.EXAMPLE
   'test' | Invoke-VMExport -Path c:\temp -Retention 5
   gets the vmname as a string and passes it through the pipeline to Invoke-VMExport
   to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
   i.e. C:\temp\test\20180915\
.EXAMPLE
   get-clusterresource -Name TEST | where ResourceType -eq 'virtual Machine Configuration' | get-vm | Invoke-VMExport -Path c:\temp -Retention 5
   gets the failover cluster resource and passes it through the pipeline to Invoke-VMExport
   to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
   i.e. C:\temp\test\20180915\
.NOTES
   Wrapper for Hyper-V\Export-VM this is a required module
.FUNCTIONALITY
   Module for extending VM export
#>
function Invoke-VMExport {
    [CmdletBinding(SupportsShouldProcess = $true,
        PositionalBinding = $true,
        ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # VM that will be exported
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        $VM,

        # BASE Path to export the VM (vm name and date will be appended)
        [ValidateNotNullOrEmpty()]
        $Path = 'c:\build\export',

        # Number of OLD exports to keep (Default 5)
        [int]
        $Retention = 5
    )

    Begin {
        $CurrentDate = get-date -Format yyyyMMdd
        if (-not (Test-Path -Path $Path -PathType Container)) {
            Write-Verbose -Message "$path does not exist, creating"
            $null = New-Item -Path $Path -ItemType Directory
        }
    }
    Process {

        foreach ($singleVM in $VM) {
            if ($singleVM.GetType().fullname -eq 'Microsoft.HyperV.PowerShell.VirtualMachine') {
                $ExportPrams = @{
                    'path'        = "$path\$($singleVM.name)\$CurrentDate"
                    'vm'          = $singleVM
                    'OutVariable' = 'HV'
                }
                $folders = Get-ChildItem -Directory -Path "$path\$($singleVM.name)" -ErrorAction SilentlyContinue | Sort-Object -Property name
            }
            else {
                $ExportPrams = @{
                    'path'        = "$path\$singleVM\$CurrentDate"
                    'vm'          = Get-VM -Name $singleVM
                    'OutVariable' = 'STRING'
                }
                $folders = Get-ChildItem -Directory -Path "$path\$singleVM" -ErrorAction SilentlyContinue | Sort-Object -Property name
            }
            Export-VM @ExportPrams -ErrorVariable ExportError

            if (-not $ExportError) {
                write-verbose -Message 'No export error continuing to retentioncheck'
                if ($folders.Count -gt $Retention) {
                    if ($pscmdlet.ShouldProcess("$path\<VMNAME>", "Remove folder greater than the last $Retention exports")) {
                        $folders | Select-Object -first ($folders.count - $Retention) | Remove-Item -Recurse
                    }
                }
                else {
                    Write-Verbose -Message "There are $(($folders).count) folders, this is less than or equal to the retention count of $Retention exports, NO folders will be removed from $path"
                }
            }
            else {
                Write-Verbose -Message "Export failed, NO folders will be removed from $path"
            }
        }
    }
    End {

    }
}