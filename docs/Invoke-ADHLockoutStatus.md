---
external help file: ADHelpers-help.xml
Module Name: ADHelpers
online version: https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6
schema: 2.0.0
---

# Invoke-ADHLockoutStatus

## SYNOPSIS
A function for getting and dealing with locked AD user accounts.

## SYNTAX

### User
```
Invoke-ADHLockoutStatus [-UserName] <String> [-LockoutStatus] [-Unlock] [<CommonParameters>]
```

### Locked
```
Invoke-ADHLockoutStatus [-Locked] [-LockedDC <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LockoutStatus function can retrieve an AD User account's locked status from all domain controllers as well as
unlock the account from all domain controllers.

## EXAMPLES

### EXAMPLE 1
```
Get-LockoutStatus -UserName janed -LockoutStatus
```

This example will get the lock status of the user account janed from all domain controllers.

### EXAMPLE 2
```
Get-LockoutStatus -UserName janed -Unlock
```

This example will unlock the janed user account from all domain controllers.

### EXAMPLE 3
```
Get-LockoutStatus -Locked
```

This example will get all locked accounts from all domain controllers, then group then by the username.

### EXAMPLE 4
```
(Get-LockoutStatus -Locked).Group
```

This example does the same as the previous example except that it will not group by the username but will list all locked account for all domain controllers.

### EXAMPLE 5
```
Get-LockoutStatus -Locked -LockedDC myservername
```

This example will get all locked account from only 1 domain controller.

## PARAMETERS

### -Locked
Gathers all Locked user accounts from all Domain controllers and groups the output by the username.

```yaml
Type: SwitchParameter
Parameter Sets: Locked
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LockedDC
Used with the 'Locked' switch to only gather information from one domain controller.

```yaml
Type: String
Parameter Sets: Locked
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LockoutStatus
Retrieves the lock status of a user account from all writable domain controllers.

```yaml
Type: SwitchParameter
Parameter Sets: User
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Unlock
Will unlock a user account from all writable domain controllers.

```yaml
Type: SwitchParameter
Parameter Sets: User
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
The username of the AD user account to get the status for or unlock.

```yaml
Type: String
Parameter Sets: User
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
