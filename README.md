# ADHelpers

![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/ADHelpers)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/ADHelpers)
![PowerShell Gallery](https://img.shields.io/powershellgallery/p/ADHelpers)

![GitHub](https://img.shields.io/github/license/thbiv/ADHelpers)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/thbiv/ADHelpers)

---

#### Table of Contents

-   [Synopsis](#Synopsis)
-   [Commands](#Commands)
-   [Installing ADHelpders](#Installing-ADHelpers)
-   [Configuring Default Parameter Values](#Configuring-Default-Parameter-Values)
-   [Licensing](#Licenseing)
-   [Release Notes](#Release-Notes)

---

## Synopsis

Module with functions for ActiveDirectory tasks.

The functions in this module were originally created to assist with Active Directory tasks for onboarding and offboarding as well as retrieving information about objects in Active Directory. They have been modified to be reusable.

---

## Commands

[Clear-ADHHomeFolder](docs\Clear-ADHHomeFolder.md)

Clears the home folder attributes from an AD user account. Can also delete the home folder itself.

[Export-ADHSecurityGRoupMember](docs\Export-ADHSecurityGRoupMember.md)

Exports security group information to an XLSX file.

[Export-ADHUserSecurityGroup](docs\Export-ADHUserSecurityGroup.md)

Exports security group membership and other important information for an AD user account object to an XLSX file.

[Invoke-ADHLockoutStatus](Invoke-ADHLockoutStatus.md)

Getting and dealing with locked AD user account objects.

[Reset-ADHUserPassword](docs\Reset-ADHUserPassword.md)

Reset an AD user account password. This function will perform the reset on all writable domain controllers.

[Search-ADHObject](docs\Search-ADHObject.md)

Gives the ability to search user objects, computer objects, security groups, and organizational units.

[Show-ADHComputer](docs\Show-ADHComputer.md)

Displays AD computer object information including LAPS and Bitlocker if available.

[Show-ADHUser](docs\Show-ADHUser.md)

Displays AD user object information.

---

## Installing ADHelpers

ADHelpers has not been released to PSGallery yet.

---

## Configuring Default Parameter Values

Some parameters support 2 ways of configuring their default values making using the functions a little quicker and easier without having to type out the parameters you need all the time.

When a function is executed and a supported parameter was not used, the function will check to see if a specific variable exists in the current powershell session. If it finds that variable, the value of that variable will be used as the value of the parameter.

If no variable exists, the function will check if there is a powershell data file exists at the following path.

```
$Home\Documents\ADHelpers\ADHelpers.Config.psd1
```

The function will check if a specific configuration is present in the file. If there is, the function will use that value as the value of the parameter.

The order in which the functions will check for parameter values are:

1.  Using the parameter in command execution
1.  Variable
1.  Config file

### Supported Parameters

#### Server 

-   Functions: Clear-ADHHomeFolder, Export-ADHSecurityGroupMember, Export-ADHUserSecurityGroup, Search-ADHObject, Show-ADHComputer, Show-ADHUser
-   Variable Name: ADH_Server
-   Configuration file setting name: Server

#### OutputPath

-   Functions: Export-ADHUserSecurityGroup
-   Variable Name: ADH_TermOutputPath
-   Configuration file setting name: TermOutputPath

### Using Variables

Using variables to configure default parameter values is as simple as defining the variable.

```Powershell
$ADH_Server = 'server01'
```

Best practice here would be to set the variables in your profile so you won't need to worry about it again.

### Using Config File

To use the config file method of configuring default parameter values, first create a folder named ```ADHelpers``` in your ```Documents``` folder. Then create a file in that folder named ```ADHelpers.Config.psd1```. Populate the file with the configuration settings like any other PSD1 file.

Here is an example

```Powershell
# Example ADHekpers.Config.psd1
@{
    Server = 'Server01'
    TermOutputPath = "Server02\path\to\folder"
}
```

---

## Licensing

ADHelpers is licensed under the [MIT License](LICENSE)

---

## Release Notes

Please refer to [Release Notes](Release-Notes.md)