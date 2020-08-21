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



---

## Licensing

ADHelpers is licensed under the [MIT License](LICENSE)

---

## Release Notes

Please refer to [Release Notes](Release-Notes.md)