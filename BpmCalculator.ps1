# Requires PowerShell 5.1+ (Windows 10 default)
$script:configPath = "$PSScriptRoot\config.json"
$script:config = $null

function Initialize-Config {
    [PSCustomObject]@{
        BaseValue = 30000
        BpmList = @(120, 128, 140, 150)
    }
}

function Load-Config {
    try {
        if (-not (Test-Path $script:configPath)) {
            $script:config = Initialize-Config
            $script:config | ConvertTo-Json | Out-File $script:configPath
        }
        $script:config = Get-Content $script:configPath | ConvertFrom-Json
    }
    catch {
        Write-Host "Error loading config: $_" -ForegroundColor Red
        exit
    }
}

function Save-Config {
    try {
        $script:config | ConvertTo-Json | Out-File $script:configPath
    }
    catch {
        Write-Host "Error saving config: $_" -ForegroundColor Red
    }
}

function Show-MainMenu {
    Clear-Host
    Write-Host "=== BPM Calculator ==="
    Write-Host "1. Calculate Kick Timing"
    Write-Host "2. Edit Configuration"
    Write-Host "3. Exit"
    
    switch (Read-Host "`nSelect option") {
        '1' { Show-Calculation-Menu }
        '2' { Show-Config-Menu }
        '3' { exit }
        default { Show-MainMenu }
    }
}

function Show-Config-Menu {
    Clear-Host
    Write-Host "=== Configuration Editor ==="
    Write-Host "1. Edit Base Value (Current: $($script:config.BaseValue))"
    Write-Host "2. Manage BPM List"
    Write-Host "3. Return to Main Menu"
    
    switch (Read-Host "`nSelect option") {
        '1' { Edit-BaseValue }
        '2' { Manage-Bpm-List }
        '3' { Show-MainMenu }
        default { Show-Config-Menu }
    }
}

function Edit-BaseValue {
    Clear-Host
    Write-Host "Current Base Value: $($script:config.BaseValue)"
    $newValue = Read-Host "Enter new base value (number)"
    
    # Validate input is a number and positive
    if ([double]::TryParse($newValue, [ref]$null)) {
        if ([double]$newValue -le 0) {
            Write-Host "Base Value must be a positive number!" -ForegroundColor Red
        } else {
            $script:config.BaseValue = [math]::Round([double]$newValue, 2)
            Save-Config
            Write-Host "Base value updated!" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Invalid number format!" -ForegroundColor Red
    }
    
    pause
    Show-Config-Menu
}

function Manage-Bpm-List {
    Clear-Host
    Write-Host "=== BPM List Management ==="
    $sortedBpm = $script:config.BpmList | Sort-Object
    for ($i = 0; $i -lt $sortedBpm.Count; $i++) {
        Write-Host "$($i+1). $($sortedBpm[$i]) BPM"
    }
    
    Write-Host "`n1. Add New BPM"
    Write-Host "2. Delete BPM"
    Write-Host "3. Return to Config Menu"
    
    switch (Read-Host "`nSelect option") {
        '1' { Add-Bpm }
        '2' { Remove-Bpm }
        '3' { Show-Config-Menu }
        default { Manage-Bpm-List }
    }
}

function Add-Bpm {
    Clear-Host
    $newBpm = Read-Host "Enter new BPM value (number)"
    
    # Validate input is a number, greater than 50, and not already in the list
    if ([int]::TryParse($newBpm, [ref]$null)) {
        if ([int]$newBpm -le 50) {
            Write-Host "BPM must be greater than 50!" -ForegroundColor Red
        }
        elseif ($script:config.BpmList -contains [int]$newBpm) {
            Write-Host "BPM already exists in the list!" -ForegroundColor Red
        }
        else {
            $script:config.BpmList += [int]$newBpm
            $script:config.BpmList = $script:config.BpmList | Sort-Object
            Save-Config
            Write-Host "BPM added!" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Invalid BPM value!" -ForegroundColor Red
    }
    
    pause
    Manage-Bpm-List
}

function Remove-Bpm {
    Clear-Host
    $sortedBpm = $script:config.BpmList | Sort-Object
    for ($i = 0; $i -lt $sortedBpm.Count; $i++) {
        Write-Host "$($i+1). $($sortedBpm[$i]) BPM"
    }
    
    $selection = Read-Host "`nEnter number to delete (or 'b' to go back)"
    if ($selection -eq 'b') { Manage-Bpm-List; return }
    
    if ([int]::TryParse($selection, [ref]$null) -and $selection -gt 0 -and $selection -le $sortedBpm.Count) {
        $script:config.BpmList = $script:config.BpmList | Where-Object { $_ -ne $sortedBpm[$selection-1] }
        Save-Config
        Write-Host "BPM removed!" -ForegroundColor Green
    }
    else {
        Write-Host "Invalid selection!" -ForegroundColor Red
    }
    
    pause
    Manage-Bpm-List
}

function Show-Calculation-Menu {
    Clear-Host
    Write-Host "=== BPM Selection ==="
    $sortedBpm = $script:config.BpmList | Sort-Object
    for ($i = 0; $i -lt $sortedBpm.Count; $i++) {
        Write-Host "$($i+1). $($sortedBpm[$i]) BPM"
    }
    
    Write-Host "`nEnter:"
    Write-Host "- Number from list above"
    Write-Host "- Custom BPM value"
    Write-Host "- 'b' to go back"
    
    # Changed variable name from $input to $userInput (conflict with automatic variable)
    $userInput = Read-Host "`nYour selection"
    if ($userInput -eq 'b') { Show-MainMenu; return }
    
    # Initialize $selection with $null
    $selection = $null
    $bpm = $null
    
    # 1. Fix TryParse usage
    if ([int]::TryParse($userInput, [ref]$selection)) {
        # Handle list selection
        if ($selection -gt 0 -and $selection -le $sortedBpm.Count) {
            $bpm = $sortedBpm[$selection-1]
        }
        # Handle custom numeric BPM input
        else {
            $bpm = $selection
        }
    }
    # 2. Handle direct BPM number input (e.g., "104" as string)
    elseif ([int]::TryParse($userInput, [ref]$bpm)) {
        # Continue validation
    }
    else {
        Write-Host "Invalid input!" -ForegroundColor Red
        pause
        Show-Calculation-Menu
        return
    }
    
    # 3. Add BPM validation
    if ($bpm -le 0) {
        Write-Host "BPM must be a positive number!" -ForegroundColor Red
        pause
        Show-Calculation-Menu
        return
    }
    
    $time = [math]::Round($script:config.BaseValue / $bpm, 2)
    Clear-Host
    Write-Host "=== Calculation Result ==="
    Write-Host "Base Value: $($script:config.BaseValue)"
    Write-Host "BPM: $bpm"
    Write-Host "Time between kicks: $time ms" -ForegroundColor Green
    Write-Host "`nFormula: $($script:config.BaseValue) / $bpm = $time"
    
    pause
    Show-MainMenu
}

# Main execution flow
Load-Config
while ($true) {
    Show-MainMenu
}