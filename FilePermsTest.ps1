#
#This script assumes a file called "ReadTestFile.txt" already is created in all folders. 
#Here is a powershell command to do so:
#
#foreach($folder in (Get-ChildItem -Directory .)) { New-Item -ItemType File -path "$folder\ReadTestFile.txt"}
#


Write-Host "Username is: $env:username"

$childdirs = Get-ChildItem -Directory -Path "." 

#
#Test Read access to all folders by attempting to read a file that exists in all folders.
#
$ReadTestResults = @{}
foreach($folder in $childdirs) { 
	Get-Content "$folder\ReadTestFile.txt" -ErrorAction SilentlyContinue 2>&1>$null
	$retval = $?
	$ReadTestResults.add($folder, $retval)
}


#
#Test write access to all folders by attempting to create a test file.
#
$WriteTestResults = @{}
foreach($folder in $childdirs) { 
	New-Item -ItemType File -Path "$folder\TestFile.txt" -ErrorAction SilentlyContinue 2>&1>$null
	$retval = $?
	if($retval -eq "True") {
		Remove-Item "$folder\TestFile.txt"
	}
	$WriteTestResults.add($folder, $retval)
}

#Compile the test results into a table that we can print to the screen.
#If a user does not have Read access, we assume they have no access.
$Results = $ReadTestResults.Clone()
foreach($CurrentKey in $ReadTestResults.Keys) {
	if($ReadTestResults[$CurrentKey] -eq 'True') { $Results[$CurrentKey] = 'Read' }
	else { $Results[$CurrentKey] = 'No Access'}
	if($WriteTestResults[$CurrentKey] -eq 'True') { $Results[$CurrentKey] += ' & Write' }
}

$Results.GetEnumerator() | Format-Table -Property Key, Value
