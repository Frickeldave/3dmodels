# Set UTF-8 encoding for console output
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Paths to template and text file
$_openscadTemplateFile = "Gardensign.scad"
$_textFilePath = "$PSScriptRoot\Gardensign.txt"
$_outputFolder = "output"
$_openSCADPath = "C:\Program Files\OpenSCAD\openscad.exe"

# Ensure output directory exists
if (!(Test-Path $_outputFolder)) {
    New-Item -ItemType Directory -Path $_outputFolder | Out-Null
}

# Read text file content
$_textLines = Get-Content $_textFilePath -Encoding UTF8

foreach ($_line in $_textLines) {
    $_text = $_line.Trim()
    $_length = $_text.Length

    # Skip empty lines
    if ($_length -lt 1) {
        Write-Host "Skipping empty line" -ForegroundColor Yellow
        continue
    }

    # Variables for text processing
    $_line1 = ""
    $_line2 = ""
    $_isMultiLine = $false

    # Check if text >16 characters and contains space
    if ($_length -gt 16 -and $_text.Contains(" ")) {
        # Split at first space
        $_spaceIndex = $_text.IndexOf(" ")
        $_line1 = $_text.Substring(0, $_spaceIndex)
        $_line2 = $_text.Substring($_spaceIndex + 1)
        $_isMultiLine = $true
        
        # Determine font size based on longest line
        $_maxLineLength = [Math]::Max($_line1.Length, $_line2.Length)
        if ($_maxLineLength -le 10) {
            $_fontsize = 12
        } elseif ($_maxLineLength -le 12) {
            $_fontsize = 10
        } elseif ($_maxLineLength -le 16) {
            $_fontsize = 8
        } else {
            $_fontsize = 6  # Very small font for long words
        }
        
        Write-Host "Creating STL for '$_text' (2 lines) with font size $_fontsize" -ForegroundColor Gray
    }
    # Normal single-line processing
    elseif ($_length -le 16) {
        $_line1 = $_text
        $_isMultiLine = $false
        
        # Determine font size
        if ($_length -le 10) {
            $_fontsize = 12
        } elseif ($_length -le 12) {
            $_fontsize = 10
        } else {
            $_fontsize = 8
        }
        
        Write-Host "Creating STL for '$_text' with font size $_fontsize" -ForegroundColor Gray
    }
    # Text too long and no space
    else {
        Write-Host "Skipping '$_text' (too long with $_length characters, no space)" -ForegroundColor Yellow
        continue
    }

    # Prepare OpenSCAD file
    $_scadContent = [System.IO.File]::ReadAllText("$PSScriptRoot\$_openscadTemplateFile", [System.Text.Encoding]::UTF8)
    
    # Replace parameters
    $_scadContent = $_scadContent -replace "###GardensignFontsize###", $_fontsize.ToString()
    $_scadContent = $_scadContent -replace "###GardensignLine1###", "`"$_line1`""
    
    if ($_isMultiLine) {
        $_scadContent = $_scadContent -replace "###GardensignLine2###", "`"$_line2`""
        $_scadContent = $_scadContent -replace "###GardensignIsMultiLine###", "true"
    } else {
        $_scadContent = $_scadContent -replace "###GardensignLine2###", "`"`""
        $_scadContent = $_scadContent -replace "###GardensignIsMultiLine###", "false"
    }

    # Replace invalid characters in filename
    $_filenameSafe = ($_text -replace '[\\\/:*?"<>|]', '_')

    # Define paths
    $_tempScadPath = Join-Path "$PSScriptRoot\$_outputFolder" "Gardensign - $($_filenameSafe).scad"
    $_tempStlPath  = Join-Path "$PSScriptRoot\$_outputFolder" "Gardensign - $($_filenameSafe).stl"

    # Delete existing files
    if (Test-Path $_tempScadPath) {
        Remove-Item $_tempScadPath -Force
        Write-Host "[DEL] Old SCAD file deleted: $_tempScadPath" -ForegroundColor DarkGray
    }
    if (Test-Path $_tempStlPath) {
        Remove-Item $_tempStlPath -Force
        Write-Host "[DEL] Old STL file deleted: $_tempStlPath" -ForegroundColor DarkGray
    }

    # Write new SCAD file (UTF-8 without BOM)
    [System.IO.File]::WriteAllText($_tempScadPath, $_scadContent, [System.Text.UTF8Encoding]::new($false))

    # Execute OpenSCAD
    Start-Process -FilePath "$_openSCADPath" `
              -ArgumentList "-o", "`"$_tempStlPath`"", "`"$_tempScadPath`"" `
              -NoNewWindow -Wait `
              -RedirectStandardError "nul"

    # Delete temporary SCAD file after each run
    if (Test-Path $_tempScadPath) {
        Remove-Item $_tempScadPath -Force
        Write-Host "[CLEAN] Temporary SCAD file removed: $_tempScadPath" -ForegroundColor DarkGray
    }

    if (Test-Path $_tempStlPath) {
        if ((Get-Item $_tempStlPath).Length -gt 0) {
            Write-Host "[OK] STL successfully created: $_tempStlPath" -ForegroundColor Green
        } else {
            Write-Host "[ERROR] STL file is empty: $_tempStlPath" -ForegroundColor Red
        }
    } else {
        Write-Host "[ERROR] STL file was not created: $_tempStlPath" -ForegroundColor Red
    }
}