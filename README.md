# GSALocalAccess Script
The **GSALocalAccess script** is designed to enhance the user experience for Global Secure Access (GSA) users by seamlessly managing **Private Access** based on network connectivity. This script **automates the enabling and disabling of Private Access** without requiring any user intervention. When a user connects to the corporate network, Private Access is automatically disabled, ensuring smooth internal resource access. Conversely, upon disconnection from the corporate network, Private Access is automatically reactivated, maintaining secure remote connectivity.

# What challange does GSALocalAccess solve
Global Secure Access (GSA) users need the flexibility to bypass GSA and directly access private applications when connected to the corporate network while still being able to access these applications when working remotely through GSA. Enabling or disabling private access on the Global Secure Access client presents a significant challenge due to these varying access needs. To resolve this issue, the **GSALocalAccess script** offers a streamlined solution, making it easier to manage private access and ensuring seamless connectivity, whether inside or outside the corporate network.

# How GSALocalAccess works
The **GSALocalAccess** script creates a **Task Scheduler** entry named **GSALocalAccess** under the **Microsoft\GlobalSecureAccess** folder. This task is responsible for **automatically enabling or disabling Private Access** based on the user's location.
It achieves this by modifying the [IsPrivateAccessDisabledByUser](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-install-windows-client#disable-or-enable-private-access-on-the-client) registry value, automatically detecting whether the user is inside or outside the corporate network. The **GSALocalAccess Task Scheduler** is triggered whenever the following event is logged, which occurs each time a device connects to a network, whether via wired or wireless connection:

The <b>GSALocalAccess</b> sript creates a Task Scheduler with the name of <b>GSALocalAccess</b> under <b>Microsoft\GlobalSecureAccess</b> folder which enables/disabels Private Access automatically by modifying [IsPrivateAccessDisabledByUser](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-install-windows-client#disable-or-enable-private-access-on-the-client) registry value detecting the user location weather they are inside or out side the corporate network. GSALocalAccess task scedular triggers once the following eventis  written which is being written once a device connects to a network, wheather using wire cable or wireless:<br><br>
<b>Event ID:</b> 10000<br>
<b>Source:</b> NetworkProfile<br>
<b>Log Name:</b> Microsoft-Windows-NetworkProfile/Operational

## Script requirements
- Global Secure Access Client shoould be installed before running the script.
- Intune licese, if an IT admin needs to push the script using Intune.

## How to use the script
- Download the `GSALocalAccess.ps1` script from [this](https://github.com/mzmaili/GSALocalAccess) GitHub repo.
- Open the script and modify `CorpNetworkName` parameter value to match your corporate network name.
- Excute the `GSALocalAccess.ps1` script as needed, either directly on the device, via Intune, through Group Policy, or using SCCM.

<!--
## Manulaly: Run the script as an administrator
## Using Intune: Follow Intune section
## Using Group Policy:

## User experience

# Frequently asked questions
## Does this script change anything?
Yes, it creates a **Task Scheduler** entry named **GSALocalAccess** under the **Microsoft\GlobalSecureAccess** folder

## Does this script require any PowerShell module to be installed?
No, the script does not require any PowerShell module.

-->
