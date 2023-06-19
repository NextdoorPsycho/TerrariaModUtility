# Made by @nextdoorpsycho Terraria Server Mod Deobfuscator, Sorter, and COllector Utility v1.0
# Define path to the config file
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "config.json"

# Check if the config file exists
if (-not (Test-Path -Path $configPath)) {
    # Define default config
    $defaultConfig = @{
        modsDirectoryTarget = "C:\Program Files (x86)\Steam\steamapps\workshop\content\1281930"
        outputFolder        = "C:\Users\yourNameHereProbably\Desktop\Terraria"
        preferredDates      = @("2022.9")
        loggingEnabled      = $true
        runSilent           = $false
        collectVersions     = $false
        clearOutputDir      = $true
        blacklist           = @{}
    }

    # Generate initial blacklist
    $folders = Get-ChildItem -Path $defaultConfig.modsDirectoryTarget -Directory
    foreach ($folder in $folders) {
        $modFiles = Get-ChildItem -Path $folder.FullName -Filter "*.tmod" -Recurse
        foreach ($modFile in $modFiles) {
            $defaultConfig.blacklist[$modFile.BaseName] = $false
        }
    }

    # Convert to JSON and save as config.json
    $defaultConfig | ConvertTo-Json -Depth 5 | Set-Content -Path $configPath
    # Exit the script after first run
    Write-Output "First run complete. Please edit the config file as desired and then rerun the script."
    exit
}

# Load the config file
$config = Get-Content -Path $configPath | ConvertFrom-Json

# Check if $config is not null
if ($null -eq $config) {
    Write-Error "Config file is not properly loaded."
    exit
}

# Create the output folder if it doesn't exist
if (-not (Test-Path -Path $config.outputFolder)) {
    New-Item -Path $config.outputFolder -ItemType Directory | Out-Null
}

# If clearOutputDir is set to true, delete all files in the output folder
if ($config.clearOutputDir) {
    Get-ChildItem -Path $config.outputFolder -File | Remove-Item -Force
}

# Create the debug log file if logging is enabled
$debugLog = Join-Path -Path $PSScriptRoot -ChildPath "debug.log"
if ($config.loggingEnabled -and (-not (Test-Path -Path $debugLog))) {
    New-Item -Path $debugLog -ItemType File | Out-Null
}

# Get the list of folders in the mod directory
$folders = Get-ChildItem -Path $config.modsDirectoryTarget -Directory

foreach ($folder in $folders) {
    # Get all .tmod files recursively
    $modFiles = Get-ChildItem -Path $folder.FullName -Filter "*.tmod" -Recurse | Sort-Object -Property LastWriteTime -Descending

    # Copy all versions of the mod if collectVersions is enabled
    if ($config.collectVersions) {
        foreach ($modFile in $modFiles) {
            # Get parent folder name as date/version
            $date = $modFile.Directory.Name

            # Check if the mod file is in a root folder
            if ($modFile.Directory.FullName -eq $folder.FullName) {
                $date = "root"
            }

            # Create a directory in output folder with date/version as its name if not exists
            $targetFolder = Join-Path -Path $config.outputFolder -ChildPath $date
            if (-not (Test-Path -Path $targetFolder)) {
                New-Item -Path $targetFolder -ItemType Directory | Out-Null
            }

            # Destination path
            $destination = Join-Path -Path $targetFolder -ChildPath $modFile.Name

            # Copy the file to the destination
            Copy-Item -Path $modFile.FullName -Destination $destination -Force

            # Log operation
            if ($config.loggingEnabled) {
                $message = "Copied: " + $modFile.Name + " to " + $destination
                Add-Content -Path $debugLog -Value $message
            }

            # Generate output content
            $outputContent = "{0}: {1}: {2}" -f $folder.Name, $modFile.BaseName, $date
            Add-Content -Path $debugLog -Value $outputContent
        }
    } else {
        # Copy only preferred versions of the mod
        foreach ($modFile in $modFiles) {
            # Get parent folder name as date/version
            $date = $modFile.Directory.Name

            # Skip if the date/version is not in preferred dates
            if ($config.preferredDates -notcontains $date) {
                continue
            }

            # Destination path
            $destination = Join-Path -Path $config.outputFolder -ChildPath $modFile.Name

            # Copy the file to the destination
            Copy-Item -Path $modFile.FullName -Destination $destination -Force

            # Log operation
            if ($config.loggingEnabled) {
                $message = "Copied: " + $modFile.Name + " to " + $destination
                Add-Content -Path $debugLog -Value $message
            }

            # Generate output content
            $outputContent = "{0}: {1}: {2}" -f $folder.Name, $modFile.BaseName, $date
            Add-Content -Path $debugLog -Value $outputContent
        }
    }
}
