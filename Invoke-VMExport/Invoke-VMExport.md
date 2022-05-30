---
external help file: Invoke-VMExport-help.xml
Module Name: invoke-vmexport
online version:
schema: 2.0.0
---

# Invoke-VMExport

## SYNOPSIS
Function to export a VM and and clean the export folder

## SYNTAX

```
Invoke-VMExport [-VM] <Object> [-Path <Object>] [-Retention <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Take VM(s) from pipeline or vairable, export the VM(s) to a path
then cleanup old VM(s) in that path larger than the retention value (default 5)

## EXAMPLES

### EXAMPLE 1
```Powershell
Invoke-VMExport -VM test -Path c:\temp -Retention 5
```

Will export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
i.e.
C:\temp\test\20180915\

### EXAMPLE 2
```Powershell
Get-VM test | Invoke-VMExport -Path c:\temp -Retention 5
```

Hyper-V\Get-VM module gets the VM and passes it through the pipeline to Invoke-VMExport
to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
i.e.
C:\temp\test\20180915\

### EXAMPLE 3
```Powershell
'test' | Invoke-VMExport -Path c:\temp -Retention 5
```

gets the VM as a string and passes it through the pipeline to Invoke-VMExport
to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
i.e.
C:\temp\test\20180915\

### EXAMPLE 4
```Powershell
Get-VM test, test2 | Invoke-VMExport -Path c:\temp -Retention 5
```

Hyper-V\Get-VM module gets the VMs and passes it through the pipeline to Invoke-VMExport
to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
i.e.
C:\temp\test\20180915\

### EXAMPLE 5
```Powershell
'test' | Invoke-VMExport -Path c:\temp -Retention 5
```

gets the vmname as a string and passes it through the pipeline to Invoke-VMExport
to export a VM called TEST to C:\TEMP\VM Name\Current Date and remove the oldest leaving the latest 5 VM exports
i.e.
C:\temp\test\20180915\

## PARAMETERS

### -VM
VM that will be exported

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Path
BASE Path to export the VM (vm name and date will be appended)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: C:\build\export
Accept pipeline input: False
Accept wildcard characters: False
```

### -Retention
Number of OLD exports to keep (Default 5)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES
Wrapper for Hyper-V\Export-VM this is a required module

## RELATED LINKS
