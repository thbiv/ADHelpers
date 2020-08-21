---
external help file: ADHelpers-help.xml
Module Name: ADHelpers
online version: https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6
schema: 2.0.0
---

# Search-ADHObject

## SYNOPSIS
Function for searching different AD Objects.

## SYNTAX

### User
```
Search-ADHObject [-Search] <String> [-Server <String>] [-User] [<CommonParameters>]
```

### Computer
```
Search-ADHObject [-Search] <String> [-Server <String>] [-Computer] [<CommonParameters>]
```

### Group
```
Search-ADHObject [-Search] <String> [-Server <String>] [-Group] [<CommonParameters>]
```

### OU
```
Search-ADHObject [-Search] <String> [-Server <String>] [-OU] [<CommonParameters>]
```

## DESCRIPTION
Function for searching different AD Objects.
Will let you search user objects,
computer objects, security groups, and organizational units.
You can only
search for one object type at a time.

## EXAMPLES

### EXAMPLE 1
```
Search-ADObject -Search jane -User
```

This example will search ActiveDirectory for any usernames that contain 'jane'.

### EXAMPLE 2
```
Search-ADObject -Search abcd -Computer
```

This example will search ActiveDirectory for any computernames that contain 'abcd'.

## PARAMETERS

### -Computer
Will list all computer accounts that contain the search string.

```yaml
Type: SwitchParameter
Parameter Sets: Computer
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
Will list all security groups that contain the search string.

```yaml
Type: SwitchParameter
Parameter Sets: Group
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OU
Will listall organizational units that contain the search string.

```yaml
Type: SwitchParameter
Parameter Sets: OU
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search
Specifies the search string the function will use.

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

### -User
Will list all user accounts that contain the search string.

```yaml
Type: SwitchParameter
Parameter Sets: User
Aliases:

Required: True
Position: Named
Default value: False
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
