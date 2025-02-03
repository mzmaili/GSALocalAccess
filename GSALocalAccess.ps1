<#

.SYNOPSIS
    GSALocalAccess V1.0 PowerShell script.

.DESCRIPTION
    GSALocalAccess script helps Global Secure Access users to disable Private Access on Global Secure Access clinet when they connect to the corporate network, 
    and enable Private Access when they disconnect from the corporate network automatically without user interaction.
    For more info, visit: https://github.com/mzmaili/GSALocalAccess

.Note
    Before running the script, make sure to update "<Enter your Corp Network Name Here>" value of $CorpNetworkName parameter.

.AUTHOR:
    Mohammad Zmaili

.EXAMPLE
    .\GSALocalAccess.ps1

#>


Function CreateGSALocalAccessTask($CorpNetworkName){
    
    # PowerShell script
    $PSScript = "`$CorpNetworkName = '"+$CorpNetworkName+"';`$NetworkName = if ((Get-WinEvent -FilterHashtable @{Logname='Microsoft-Windows-NetworkProfile/Operational';Id=10000} -MaxEvents 1).message -match 'Name:\s*(\w+)') { `$matches[1] } else { `$null };If (`$NetworkName -eq `$CorpNetworkName){Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Global Secure Access Client' -Name 'IsPrivateAccessDisabledByUser' -Value 1 -force}else{Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Global Secure Access Client' -Name 'IsPrivateAccessDisabledByUser' -Value 0 -force}"

    # Define the task action
    $arg = '-NoProfile -ExecutionPolicy Bypass -Command "&{' + $PSScript + '}"'
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arg

    #trigger on event id 10000
    $CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger
    $Trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
    $Trigger.Subscription = @"
    <QueryList><Query Id="0" Path="Microsoft-Windows-NetworkProfile/Operational"><Select Path="Microsoft-Windows-NetworkProfile/Operational">*[System[Provider[@Name='Microsoft-Windows-NetworkProfile'] and EventID=10000]]</Select></Query></QueryList>
"@
    $Trigger.Enabled = $True


    #Stop Task if runs more than 60 minutes
    $Timeout = (New-TimeSpan -Seconds 60)

    #Additional Settings on the Task:
    $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -StartWhenAvailable -DontStopIfGoingOnBatteries -ExecutionTimeLimit $Timeout

    #Set Name of Task
    $TaskName = "GSALocalAccess"

    #Create the Task
    $task = New-ScheduledTask -Action $action -Trigger $Trigger -Settings $settings

    #Register Task
    Register-ScheduledTask -TaskName $TaskName -InputObject $task -TaskPath "\Microsoft\GlobalSecureAccess\" -Force -ErrorAction SilentlyContinue

}
 
$CorpNetworkName = "<Enter your Corp Network Name Here>"
 
CreateGSALocalAccessTask $CorpNetworkName