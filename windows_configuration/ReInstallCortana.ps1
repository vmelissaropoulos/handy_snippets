Get-AppxPackage -AllUsers Microsoft.Windows.Cortana | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml”}
