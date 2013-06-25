#BulkCreateVMs.ps1

$ParentVHD = "C:\ClusterStorage\Library1\Centos-6.3-Template\Centos-6.3-Template.vhdx"

$path = "C:\ClusterStorage\Library1\vms\VMs.csv"

import-csv -path $path|ForEach-Object {
$erroractionpreference = 0    

$vmName = $_.Name
[int] 
$vmmemory = $_.Memory

$vmstartmemory=$vmmemory*1073741824

$vmcpucount = $_.Cpucount

$vmSwitch = $_.Network
$vmpath = $_.Path

#Create the VM

New-VM -Name $vmname -Path $vmpath

#Set the VM Memory properties

Set-VM -Name $vmname -StaticMemory -MemoryStartupBytes $vmstartmemory

#Set the vCPU

Set-VMProcessor -VMName $vmname -Count $vmcpucount

#Connect the VM to vSwitch

Connect-VMNetworkAdapter -VMName $vmname -SwitchName $vmSwitch
#Create VHD for the VM

New-VHD -Path "$vmpath\$vmname\Virtual Hard Disks\$vmname.vhdx" -ParentPath $ParentVHD

#Add the VHD to the VM to IDE 0 Location 0

Add-VMHardDiskDrive -vmname $vmname -ControllerType IDE -ControllerNumber 0 -Path "$vmpath\$vmname\Virtual Hard Disks\$vmname.vhdx"
Write-Host -BackgroundColor Green -ForegroundColor Black "Virtual Machine $vmName $vmmemory $vmstartmemory $vmcpucount $vmSwitch $vmpath has been successfully created"     

}