---
external help file: ADHelpers-help.xml
Module Name: ADHelpers
online version: https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6
schema: 2.0.0
---

# Export-ADHUserSecurityGroup

## SYNOPSIS
Exports security groups and other data for an AD User Account to Excel format and saves to a folder.

## SYNTAX

```
Export-ADHUserSecurityGroup [-User] <String> [-Server <String>] [-OutputPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Exports security groups and other data for an AD User Account to Excel format and saves to a folder.
Requires the ActiveDirectory and ExcelPSLib modules

## EXAMPLES

### EXAMPLE 1
```
Export-UserSecurityGroups -User janed
```

This example will export the security groups of an account with a logonid of janed to the default output path.

## PARAMETERS

### -OutputPath
The path to which the XLSX file will be saved.
Do not include the file name in this path.

This parameter supports the use of a config file and Powershell variable to automatically pass a value to the function.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(Get-ADHTermOutputPathValue)
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

### -User
The Logon ID of the account to export.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Written by Thomas Barratt

## RELATED LINKS

[https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6](https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6)

[https://excelpslib.codeplex.com/](https://excelpslib.codeplex.com/)

[http://epplus.codeplex.com/](http://epplus.codeplex.com/)

