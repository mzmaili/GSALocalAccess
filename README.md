# GSALocalAccess Script
The **GSALocalAccess script** is designed to enhance the user experience for Global Secure Access (GSA) users by seamlessly managing **Private Access** based on network connectivity. This script **automates the enabling and disabling of Private Access** without requiring any user intervention. When a user connects to the corporate network, Private Access is automatically disabled, ensuring smooth internal resource access. Conversely, upon disconnection from the corporate network, Private Access is automatically reactivated, maintaining secure remote connectivity.

# What challenge GSALocalAccess solves
Global Secure Access (GSA) users need the flexibility to bypass GSA and directly access private applications when connected to the corporate network while still being able to access these applications when working remotely through GSA. Enabling or disabling private access on the Global Secure Access client presents a significant challenge due to these varying access needs. To resolve this issue, the **GSALocalAccess script** offers a streamlined solution, making it easier to manage private access and ensuring seamless connectivity, whether inside or outside the corporate network.

# How GSALocalAccess works
The **GSALocalAccess** script creates a **Task Scheduler** named **GSALocalAccess** under the **Microsoft\GlobalSecureAccess** folder. This task is responsible for **automatically enabling or disabling Private Access** based on the user's location.
It achieves this by modifying the [IsPrivateAccessDisabledByUser](https://learn.microsoft.com/en-us/entra/global-secure-access/how-to-install-windows-client#disable-or-enable-private-access-on-the-client) registry value, automatically detecting whether the user is inside or outside the corporate network. The **GSALocalAccess Task Scheduler** is triggered whenever the following event is logged, which occurs each time a device connects to a network, whether via wired or wireless connection: <br>

<b>Event ID:</b> 10000<br>
<b>Source:</b> NetworkProfile<br>
<b>Log Name:</b> Microsoft-Windows-NetworkProfile/Operational

## Script requirements
- Global Secure Access Client should be installed before running the script.
- Intune license, if you need to to push the script using Microsoft Intune.

## How to use the script
- Download the `GSALocalAccess.ps1` script from [this](https://github.com/mzmaili/GSALocalAccess) GitHub repo.
- Open the script and modify `<Enter your Corp Network Name Here>` value of **$CorpNetworkName** parameter with your network(s).
   - If you have multiple networks, add a comma (,) between each network name like `"CorpNetwork1,CorpNetwork2,CorpNetwork3"`. Otherwise, add a single network name like `"OneCorpNetwork"`.
- Execute the `GSALocalAccess.ps1` script as needed, either directly on the device, via Intune, through Group Policy, or using SCCM.

## Running the script using Intune
1.	Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/) with the appropriate roles
2.	Navigate to **Devices** > **Windows** > **Scripts and remediations**
3. Open **Platform scripts** tab, click on **Add**, to add a new script as the following:
   - **Basics** tab, Enter a name (e.g., 'GSALocalAccess Script')
   - **Script settings** tab, select the script location and set all values to **No**
     
     ![Alt text](/media/Script_settings.png "Script_settings")
     
   - **Assignments** tab, click on **Add all devices**.

<br>

## Frequently asked questions
### Does this script change anything?
Yes, it creates a **Task Scheduler** entry named **GSALocalAccess** under the **Microsoft\GlobalSecureAccess** folder

### Does this script require any PowerShell module to be installed?
No, the script does not require any PowerShell module.

<!--
## Manually: Run the script as an administrator
## Using Group Policy:

## User experience

-->
