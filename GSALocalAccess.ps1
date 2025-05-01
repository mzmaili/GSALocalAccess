<#

.SYNOPSIS
    GSALocalAccess V1.6 PowerShell script.

.DESCRIPTION
    GSALocalAccess script helps Global Secure Access users to disable Private Access on Global Secure Access clinet when they connect to the corporate network(s), 
    and enable Private Access when they disconnect from the corporate network(s) automatically without user interaction.
    For more info, visit: https://github.com/mzmaili/GSALocalAccess

.Note
    Before running the script, make sure to update "<Enter your Corp Network Name Here>" value of $CorpNetworkName parameter with your network(s).
    If you have multiple networks, add a comma (,) between each network name like "CorpNetwork1,CorpNetwork2,CorpNetwork3". Otherwise, add a single network name like "OneCorpNetwork".

.AUTHOR:
    Mohammad Zmaili

.EXAMPLE
    .\GSALocalAccess.ps1

#>


Function CreateGSALocalAccessTask($CorpNetworkName){
    
    # PowerShell script
    $PSScript = "`$CorpNetworks = '"+$CorpNetworkName+"' -split ',';`$NetworkName = if ((Get-WinEvent -FilterHashtable @{Logname='Microsoft-Windows-NetworkProfile/Operational';Id=10000} -MaxEvents 1).message -match 'Name:\s*(.+)') { `$matches[1] } else { `$null };foreach (`$CorpNetwork in `$CorpNetworks){If (`$NetworkName -eq `$CorpNetwork){Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Global Secure Access Client' -Name 'IsPrivateAccessDisabledByUser' -Value 1 -force;exit}}Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Global Secure Access Client' -Name 'IsPrivateAccessDisabledByUser' -Value 0 -force"

    # Define the task action
    $arg = '-NoProfile -ExecutionPolicy Bypass -Command "&{' + $PSScript + '}"'
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arg

    #Trigger on event id 10000
    $CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger
    $Trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
    $Trigger.Subscription = @"
    <QueryList><Query Id="0" Path="Microsoft-Windows-NetworkProfile/Operational"><Select Path="Microsoft-Windows-NetworkProfile/Operational">*[System[Provider[@Name='Microsoft-Windows-NetworkProfile'] and EventID=10000]]</Select></Query></QueryList>
"@
    $Trigger.Enabled = $True

    #Set task principal
    $Prin = New-ScheduledTaskPrincipal -GroupId "S-1-1-0"

    #Stop task if runs more than 60 minutes
    $Timeout = (New-TimeSpan -Seconds 60)

    #Set name of task
    $TaskName = "GSALocalAccess"

    #Other settings on the task:
    $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -StartWhenAvailable -DontStopIfGoingOnBatteries -ExecutionTimeLimit $Timeout

    #Create the task
    $task = New-ScheduledTask -Action $action -principal $Prin -Trigger $Trigger -Settings $settings

    #Register the task
    Register-ScheduledTask -TaskName $TaskName -InputObject $task -TaskPath "\Microsoft\GlobalSecureAccess\" -Force -ErrorAction SilentlyContinue

}


$CorpNetworkName = "<Enter your Corp Network Name Here>" # Example "OneCorpNetwork" OR "CorpNetwork1,CorpNetwork2,CorpNetwork3"

CreateGSALocalAccessTask $CorpNetworkName