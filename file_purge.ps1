#purge Script

#delete files older than 28 days
$dir = (Resolve-Path .\).Path
$ddMMyyyy = (Get-Date).ToString('dd-MM-yyyy')

$log = $dir + "\logFolder"
$log_file = $log + "\purge -" + $ddMMyyyy +".log"

$retention = 28
$purge_dir = "/purgefolder"

Write-Output "============================" >> $log_file
Write-Output "$(get-date) : Starting the script"|out-file $log_file -Append -Force
Write-Output "$(get-date) : Deleting at $purge_dir with retention period of $retention days" >> $log_file

Get-ChildItem -File -Recurse $purge_dir | 
    Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-$retention)}| ForEach-Object {
        #foreach-object do the following- del and log
        $_.FullName | del -Force
        $_.FullName | Out-File $log_file -Append


    }
    Write-Output "$(get-date) : Script execution complete"| out-file $log_file -Append -Force
    Write-Output "======================================"| out-file $log_file -Append -Force


