---
external help file: ADHelpers-help.xml
Module Name: ADHelpers
online version: https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6
schema: 2.0.0
---

# Show-ADHComputer

## SYNOPSIS
Shows ADComputer Information

## SYNTAX

```
Show-ADHComputer [-ComputerName] <String> [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
Collects information about the computer object including LAPS and BitLocker information.
Will also perform a simple online/offline check.

## EXAMPLES

### EXAMPLE 1
```
Show-ADComputer -ComputerName computer1
PS C:\> Show-ADComputer computer1
PS C:\> sadc computer1
```

All 3 of these commands in this example will return information for a computer named 'computer1'

## PARAMETERS

### -ComputerName
Name of the computer to return data for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
The doman controller that the function will make Active Directory requests and changes to.

This parameter supports the use of a config file and Powershell variable to automatically pass a value to the function.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(Get-ADHServerValue)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
