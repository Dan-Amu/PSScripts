param (
	[int]$disks,
	[string]$prefix = "Disk",
	[uint64]$size = 10GB,
	[string]$path = ($pwd)
)

if ($path.endswith('\') -eq $false) {
$path = $path + '\'
}

for ($i = 1; $i -le $disks; $i++) {
$VHDpath = $path+$prefix+'VHDX'+$i+'.vhdx' 
Write-Host $VHDpath
New-VHD -Path $VHDpath -SizeBytes $size
}
