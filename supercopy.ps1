$startTime = get-date #begin timestamp

# Define number of jobs to run concurrently.
$maxConcurrentJobs = 8

# Define Source and Destination 

$source = Read-Host -Prompt "Enter source path: "
$dest = Read-Host -Prompt "Enter destination path: "

# Set $log to a local folder to store logfiles
    
$log = "C:\Sync\Logs\"

if(!$log) {
    mkdir $log
}

$files = Get-ChildItem $source
$files | ForEach-Object {
    $ScriptBlock = {
        param($name, $source, $dest, $log)
        $log += "\$name-$(get-date -f yyyy-MM-dd).log"
        robocopy "$source\$name" "$dest\$name" /E /nfl /XO /np /mt:20 /ndl > $log
        Write-Host "$source\$name" " completed"
    }
    $job = Get-Job -State "Running"
    while ($job.count -ge $maxConcurrentJobs) {
        Start-Sleep -Milliseconds 500
        $job = Get-Job -State "Running"
    }
    Get-job -State "Completed" | Receive-job
    Remove-job -State "Completed"
    Start-Job $ScriptBlock -ArgumentList $_,$source,$dest,$log
}


While (Get-Job -State "Running") { Start-Sleep 2 }
    Remove-Job -State "Completed" 
    Get-Job | Write-host

$tend = get-date # End timestamp
new-timespan -start $startTime -end $tend
