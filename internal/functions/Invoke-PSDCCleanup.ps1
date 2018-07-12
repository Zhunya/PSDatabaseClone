function Invoke-PSDCCleanup {

    param(
        [object[]]$ItemList,
        [System.Management.Automation.PSCredential]
        $SqlCredential,
        [System.Management.Automation.PSCredential]
        $Credential
    )

    begin {
        # Reverse the order of the items to run backwards
        $ItemList = $ItemList | Sort-Object Number -Descending
    }

    process {

        # Loop through each of the items
        foreach ($item in $ItemList) {

            $computer = [PSFComputer]$item.Computer

            switch ($item.TypeName) {
                "FileInfo" {
                    try {
                        Write-PSFMessage -Message "Removing file $($item.Object.Name)" -Level Verbose
                        if ($computer.IsLocalhost) {
                            if (Test-Path -Path $item.Object.FullName) {
                                Remove-Item -Path $item.Object.FullName -Recurse -Force -Confirm:$false
                            }
                            else {
                                Write-PSFMessage -Message "Object $($item.Object.FullName) doesn't exist" -Level Verbose
                            }
                        }
                        else {
                            $command = [scriptblock]::Create("Remove-Item -Path $($item.Object.FullName) -Recurse -Force -Confirm:$false")
                            Invoke-PSFCommand -ComputerName $computer -ScriptBlock $command -Credential $Credential
                        }
                    }
                    catch {

                    }
                }

                "DirectoryInfo" {
                    try {
                        Write-PSFMessage -Message "Removing directory $($item.Object.Name)" -Level Verbose
                        if ($computer.IsLocalhost) {
                            if (Test-Path -Path $item.Object.FullName) {
                                Remove-Item -Path $item.Object.FullName -Recurse -Force -Confirm:$false
                            }
                            else {
                                Write-PSFMessage -Message "Object $($item.Object.FullName) doesn't exist" -Level Verbose
                            }
                        }
                        else {
                            $command = [scriptblock]::Create("Remove-Item -Path $($item.Object.FullName) -Recurse -Force -Confirm:$false")
                            Invoke-PSFCommand -ComputerName $computer -ScriptBlock $command -Credential $Credential
                        }

                    }
                    catch {

                    }
                }

                "Database" {
                    $database = $item.Object
                    try {
                        $null = Remove-DbaDatabase -SqlInstance $database.SqlInstance -Database $database.DatabaseName -SqlCredential $SqlCredential
                    }
                    catch {

                    }
                }

                "VirtualHardDisk" {
                    $item.Object
                    $vhd = $item.Object

                    # Dismount the VHD if it's attched
                    try {
                        if ($vhd.Attached) {
                            Write-PSFMessage -Message "Dismounting vhd $($vhd.Path)" -Level Verbose
                            if ($computer.IsLocalhost) {
                                Dismount-VHD -Path $vhd.Path
                            }
                            else {
                                $command = [scriptblock]::Create("Dismount-VHD -Path $($vhd.Path)")
                                Invoke-PSFCommand -ComputerName $computer -ScriptBlock $command -Credential $Credential
                            }
                        }
                    }
                    catch {

                    }

                    # Remove the vhd
                    try {
                        Write-PSFMessage -Message "Removing vhd $($vhd.Path)" -Level Verbose
                        if ($computer.IsLocalhost) {
                            if (Test-Path -Path $i.Object.FullName) {
                                Remove-Item -Path $vhd.Path -Force -Confirm:$false
                            }
                            else {
                                Write-PSFMessage -Message "Object $($i.TypeName) doesn't exist" -Level Verbose
                            }
                        }
                        else {
                            $command = [scriptblock]::Create("Remove-Item -Path $($vhd.Path) -Recurse -Force -Confirm:$false")
                            Invoke-PSFCommand -ComputerName $computer -ScriptBlock $command -Credential $Credential
                        }
                    }
                    catch {

                    }

                }

            } # End switch

        } # For each cleanup item

    } # End process

    end {

    }
}