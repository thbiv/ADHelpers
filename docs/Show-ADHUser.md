---
external help file: ADHelpers-help.xml
Module Name: ADHelpers
online version: https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6
schema: 2.0.0
---

# Show-ADHUser

## SYNOPSIS
Shows ADUser Information.

## SYNTAX

```
Show-ADHUser [-UserName] <String> [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
Collects and displays certain information for an ADUser.

## EXAMPLES

### EXAMPLE 1
```
Show-ADUser -UserName janed
```

This example gathers information about janed's account and displays it to the console.
This function has an alias of 'sadu' so an alternate way of write this command is:

PS C:\\\> sadu janed

## PARAMETERS

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

### -UserName
SAMAccountName of the ADUser

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
