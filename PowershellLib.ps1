$date = Get-Date -format "MM/dd/yyyy HH:MM:ss"
$logFileDate = Get-Date -Format "MMddyyyyHHMMss"
$logFile = "$PSScriptRoot\Logs\Log_$logFileDate.txt"

function Write-Log-Message { 

    Param(
        
        [Parameter(Position=0, Mandatory)]
        [ValidateSet(1, 2, 3)]        
        [int]$messageType,

        [Parameter(Position=1, Mandatory)]
        [String]$message
    )

    $infoDebugError = ""
    #$date = Get-Date -format "MM/dd/yyyy HH:MM:ss"
    $currentStack = Get-PSCallStack

    switch($messageType) {
        1 {$infoDebugError = "INFO"}
        2 {$infoDebugError = "DEBUG"}
        3 {$infoDebugError = "ERROR"}
    }  
    
    if($currentStack.Count -gt 1) {
        
        $parent = $currentStack[1]
        $functionName = $parent.Command
        $scriptPath = $parent.ScriptName.Split("\")
        $count = $scriptPath.Length

        if($functionName -eq $scriptPath[$count-1]) {
            $functionName = "MAIN"
        }

        Write-Host "[$date][$infoDebugError] [$($scriptPath[$count-1]) - $($functionName)]: $message" 
    }
    else {
        Write-Host "[$date][$infoDebugError] [MAIN]: $message"
    } 
}

function Start-Log {
    Param( 
        [Parameter(Position=0, Mandatory=$false)]
        [String]$filePathOverride
    )
    
    
    
    if($filePathOverride -ne "") {

        if(!(Test-Path $filePathOverride)){
            Write-Log-Message 1 "Log folder does not exist. Creating."
            New-Item -Path $filePathOverride -Name "LOGS" -ItemType Directory
        }
        else {
            Write-Log-Message 1 "Log folder already exists. Not creating"
        }

        Start-Transcript -Path $logFile

    }
    else {
        Start-Transcript
    }
}

Function Stop-Log () {
    Stop-Transcript
}