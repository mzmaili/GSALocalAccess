# GSALocalAccess Script
GSALocalAccess script helps Global Secure Access users to disable Private Access on Global Secure Access clinet when they connect to the corporate network, and enable Private Access when they disconnect from the corporate network automatically without user interaction.

# Why its needed/what issue it resoles
coming from the fact that Global Secure Access users need to bypass Global Secure Access and directly access private applications one they are connected to the corporate network, also, they need to access private applications wheh they are outside the corporate network. enabling/disabling private access on global secure access client becomes challenging. GSALocalAccess script helps recolve this challenge.

# How does GSALocalAccess work
GSALocalAccess sript creates a task schdular with the name of 'GSALocalAccess' under '\Microsoft\GlobalSecureAccess' folder which enables/disabels Private Access by modifying [IsPrivateAccessDisabledByUser](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-install-windows-client#disable-or-enable-private-access-on-the-client) registry key value as as per the user location weather they are inside or out side the corporate network. GSALocalAccess task scedular triggers once the following eventis  written which is being written once a device connects to a network, wheather using wire cable or wireless:
Event ID: 10000
Source: NetworkProfile
Log Name: Microsoft-Windows-NetworkProfile/Operational

## Script requirements
- Global Secure Access Client shoould be installed before running the script.
- Intune licese, if an IT admin needs to push the script using Intune.

## How to run the script
- Download the `GSALocalAccess.ps1` script from [this](https://github.com/mzmaili/Get-AzureADUsersLastSignIn) GitHub repo.
- Open the script and modify `CorpNetworkName` parameter value to match your corporate network name.
- Excute the `GSALocalAccess.ps1` script as your per your need; on the device directly, using Intune, using Group Policy, or using System Center Configuration Manager (SCCM).

## Manulaly: Run the script as an administrator
## Using Intune: Follow Intune section
## Using Group Policy:


## Why is this script useful?
- To retrieve Azure AD users with their last sign-in details.
- To generate a CSV report with the result.

## User experience
PowerShell console output:  
![Alt text](https://github.com/mzmaili/Get-AzureADUsersLastSignIn/blob/main/media/PS.png "PowerShell Output")  

CSV output:  
![Alt text](https://github.com/mzmaili/Get-AzureADUsersLastSignIn/blob/main/media/CSV.png "CSV Output")  

# Frequently asked questions
## Does this script change anything?
No. It just retrieves data.

## Should tenant have a specific Azure AD license?
Yes, tenant should have an Azure AD Premium license.

## What data does this script retrieves?
Get-AzureADUsersLastSignIn script retrieves the following details for each user in the tenant:  
`Object ID, Display Name, User Principal Name, Account Enabled, onPremisesSyncEnabled, Created DateTime (UTC), Last Success Signin (UTC)`

## Can I get users last sign-in details through Get-Azureaduser command?
No.

## Does this script require any PowerShell module to be installed?
No, the script does not require any PowerShell module.

## What does "N/A" value in "Last Success Signin (UTC)" field mean?
If 'Last Success Signin (UTC)' value is 'N/A', this could be due to one of the following two reasons:
- The last successful sign-in of a user took place before April 2020.
- The affected user account was never used for a successful sign-in.
