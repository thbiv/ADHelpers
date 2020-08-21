---
external help file: ADHelpers-help.xml
Module Name: ADHelpers
online version:
schema: 2.0.0
---

# Clear-ADHHomeFolder

## SYNOPSIS
Clears the home folder attributes from an AD user account.
Can also delete the home folder itself.

## SYNTAX

```
Clear-ADHHomeFolder [-User] <String[]> [-Server <String>] [-DeleteHomeFolder] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Clears the home folder attributes from an AD user account.
Can also delete the home folder itself.

## EXAMPLES

### EXAMPLE 1
```
Clear-HomeFolder -User janed
```

This example will clear the HomeDrive and HomeDirectory attributes of the account for 'janed'

### EXAMPLE 2
```
Clear-HomeFolder -User janed -DeleteHomeFolder
```

This example does the same as example 1 but will also attempt to delete the folder that was in the HomeDirectory attribute.

## PARAMETERS

### -DeleteHomeFolder
If used, the function will delete the folder that is in the HomeDirectory attribute of the AD user account.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
The doman controller that the function will make Active Directory requests and changes.

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
The username of the user to clear the attributes from.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
