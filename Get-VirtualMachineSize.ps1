function Get-VirtualMachineSize {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]    
        [string]$VmName,
        [string]$VmSize
    )
    
    try {
        Get-AzTenant -ErrorAction STOP
    } catch {
        Connect-AzAccount -ErrorAction STOP
    }

    $ExitArray = [System.Collections.ArrayList]@()

    $server = Get-AzVM -Name $VmName
    if($Server.VmSize -eq $VmSize) {
        $ExitArray.Append($server.name)
    } 
    
    return $ExitArray
}

Export-ModuleMember -Function Get-VirtualMachineSize



