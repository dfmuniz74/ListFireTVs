# Clear the screen
Clear-Host

# Step 1: Execute dns-sd -B with a timeout of 3 seconds
$timeoutSeconds = 3
$code = {
    dns-sd -B _amzn-wplay._tcp
}

Write-Host "Searching for Fire TV devices on the network..." -NoNewline
$j = Start-Job -ScriptBlock $code

# Wait for the job to finish or timeout
if (Wait-Job $j -Timeout $timeoutSeconds) {
    $browseOutput = Receive-Job $j | Out-String -Stream
} else {
    Stop-Job -Job $j
    $browseOutput = Receive-Job $j | Out-String -Stream
}

# Clean up the job
Remove-Job -Force $j

# Step 2: Extract Instance Names from the output
$instanceNames = ($browseOutput | Where-Object { $_ -match "Add" } | ForEach-Object {
    ($_ -split "\s+")[-1]
}) | Where-Object { $_ -match "amzn.dmgr" }

if ($instanceNames.Count -eq 0) {
    Write-Host "No Fire TV devices found."
    exit
}

Write-Host " Devices found: $($instanceNames.Count)"

# Step 3: Iterate over each Instance Name and get details
$results = @()

Write-Host "`nProcessing devices" -NoNewline
foreach ($instance in $instanceNames) {
    Write-Host "." -NoNewline

    # Execute the lookup command with a timeout
    $lookupCommand = "dns-sd -L `"$instance`" _amzn-wplay._tcp"
    $lookupJob = Start-Job -ScriptBlock { param ($cmd) Invoke-Expression $cmd } -ArgumentList $lookupCommand

    # Wait for the job to finish or timeout
    if (Wait-Job $lookupJob -Timeout $timeoutSeconds) {
        $lookupOutput = Receive-Job $lookupJob | Out-String
    } else {
        Stop-Job -Job $lookupJob
        $lookupOutput = Receive-Job $lookupJob | Out-String
    }

    # Clean up the job
    Remove-Job -Force $lookupJob

    # Extract IP, MAC, and Hostname
    if ($lookupOutput -match "(\d{1,3}-\d{1,3}-\d{1,3}-\d{1,3}).local") {
        $ip = $matches[1] -replace "-", "."
    }

    if ($lookupOutput -match " c=([a-fA-F0-9:]+)") {
        $mac = $matches[1]
    }

    if ($lookupOutput -match " n=([^ ]+) at=") {
        $hostname = $matches[1]
    }

    if ($ip -and $mac -and $hostname) {
        $results += [PSCustomObject]@{
            IP       = $ip
            MAC      = $mac
            Hostname = $hostname
        }
    } else {
        Write-Host "Incomplete details for: $instance"
    }
}

# Step 4: Display results
if ($results.Count -gt 0) {
    Write-Host " Fire TV devices found:"
    $results | Format-Table -AutoSize
} else {
    Write-Host "No valid details were found."
}
