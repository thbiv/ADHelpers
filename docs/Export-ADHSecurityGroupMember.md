---
external help file: ADHelpers-help.xml
Module Name: ADHelpers
online version:
schema: 2.0.0
---

# Export-ADHSecurityGroupMember

## SYNOPSIS
Exports security group members to an XLSX file along with other information about the security group.

## SYNTAX

```
Export-ADHSecurityGroupMember [-Group] <String> [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
Exports security group members to an XLSX file along with other information about the security group.

## EXAMPLES

### EXAMPLE 1
```
Export-SecurityGroupMember -Group 'Domain Admins'
```

This example will take information from the Domain Admins security group and create an XLSX file with that data.

## PARAMETERS

### -Group
Name of the security group to be exported.

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
