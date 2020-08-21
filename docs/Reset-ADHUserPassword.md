---
external help file: ADHelpers-help.xml
Module Name: ADHelpers
online version: https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6
schema: 2.0.0
---

# Reset-ADHUserPassword

## SYNOPSIS
Resets an AD User password.

## SYNTAX

```
Reset-ADHUserPassword [-UserName] <String> [-ForceChangePasswordAtLogon] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Resets an AD User password.

## EXAMPLES

### EXAMPLE 1
```
Reset-ADUserPassword -UserName janed
Enter user's New Password [Leave Blank to EXIT]: ********
Re-Enter user's New Password: ********
```

This example resets the password for janed.
Running this function will prompt to enter and re-enter password.

## PARAMETERS

### -ForceChangePasswordAtLogon
Using this switch will prompt the user to change their password at first logon.

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

### -UserName
SAMAccountName of the account to reset.

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
