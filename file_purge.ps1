#   Script Name : AutomationPurge.ps1
#
#  	Developed By : Rohan Ganguly
#  	Scripting Language : PowerShell
#
#   Date : July 5 2018
#
#   Purpose : To perform the purge operation on files older than 28 days and keep a track of files which are getting deleted
#   Author  : Rohan Ganguly
#
#              

#Setting up variables
$BASE_DIR=(Resolve-Path .\).Path
$ddMMyyyy=(Get-Date).ToString('dd-MM-yyyy');

$LOG_DIR=$BASE_DIR + "\LogFolder"
$LOG_FILE=$LOG_DIR + "\purge-"+$ddMMyyyy +".log"

$xml_config=$BASE_DIR + "\purge_config.xml"
[xml]$xml_content=Get-Content $xml_config

# Starting the script execution
write-output "===========================================================================" >> $LOG_FILE;
write-output "$(get-date) : Staring the script " | out-file $LOG_FILE -Append -Force;  


foreach ($entity in $xml_content.GetElementsByTagName("DIR_RETENTION") ){ 
	$retention=[int32]$entity.RETENTION
	$dir=$entity.DIR
		
	write-output "$(get-date) : Deleteing at $dir with retention period of $retention days" >> $LOG_FILE;

		Get-ChildItem -File -Recurse $dir | 
		Where-object {$_.LastWriteTime -lt (get-date).adddays(-$retention)} | % { 
			$_.fullname | del -Force
			$_.fullname | Out-File $LOG_FILE -Append
		}
}

write-output "$(get-date) : Script execution completed " | out-file $LOG_FILE -Append -Force;  
write-output "========================================================================= " | out-file $LOG_FILE -Append -Force;  

# #purge Script

# #delete files older than 28 days
# $dir = (Resolve-Path .\).Path
# $ddMMyyyy = (Get-Date).ToString('dd-MM-yyyy')

# $log = $dir + "\logFolder"
# $log_file = $log + "\purge -" + $ddMMyyyy +".log"

# $retention = 28
# $purge_dir = "/purgefolder"

# Write-Output "============================" >> $log_file
# Write-Output "$(get-date) : Starting the script"|out-file $log_file -Append -Force
# Write-Output "$(get-date) : Deleting at $purge_dir with retention period of $retention days" >> $log_file

# Get-ChildItem -File -Recurse $purge_dir | 
#     Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-$retention)}| ForEach-Object {
#         #foreach-object do the following- del and log
#         $_.FullName | del -Force
#         $_.FullName | Out-File $log_file -Append


#     }
#     Write-Output "$(get-date) : Script execution complete"| out-file $log_file -Append -Force
#     Write-Output "======================================"| out-file $log_file -Append -Force


