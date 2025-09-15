# UTF-8 Encoding für Console-Ausgabe setzen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Pfade zur Vorlage und zur Textdatei
$_openscadTemplateFile = "Gardensign.scad"
$_textFilePath = "$PSScriptRoot\Gardensign.txt"
$_outputFolder = "output"
$_openSCADPath = "C:\Program Files\OpenSCAD\openscad.exe"

# Sicherstellen, dass das Ausgabeverzeichnis existiert
if (!(Test-Path $_outputFolder)) {
    New-Item -ItemType Directory -Path $_outputFolder | Out-Null
}

# Inhalt der Textdatei einlesen
$_textLines = Get-Content $_textFilePath  -Encoding UTF8

foreach ($_line in $_textLines) {
    $_text = $_line.Trim()
    $_length = $_text.Length

    # Fontgröße bestimmen
    if ($_length -lt 1) {
        Write-Host "Skip empty rows" -ForegroundColor Yellow
        continue
    } elseif ($_length -le 10) {
        $_fontsize = 12
    } elseif ($_length -le 12) {
        $_fontsize = 10
    } elseif ($_length -le 16) {
        $_fontsize = 8
    } else {
        Write-Host "Skip '$_text' (to long with $_length characters)" -ForegroundColor Yellow
        continue
    }

    Write-Host "Create STL file '$_text' with fontsize $_fontsize" -ForegroundColor Gray

    # OpenSCAD-Datei vorbereiten
    $_scadContent = [System.IO.File]::ReadAllText("$PSScriptRoot\$_openscadTemplateFile", [System.Text.Encoding]::UTF8)
    # Setze Fontgröße als Zahl (kein Problem)
    $_scadContent = $_scadContent -replace "###GardensignFontsize###", $_fontsize.ToString()

    # Setze Text als korrekt eingebetteten String mit Anführungszeichen
    $_scadContent = $_scadContent -replace "###GardensignText###", "`"$_text`""

    # Unerlaubte Zeichen in Dateinamen ersetzen
    $_filenameSafe = ($_text -replace '[\\\/:*?"<>|]', '_')

    # Pfade definieren
    $_tempScadPath = Join-Path "$PSScriptRoot\$_outputFolder" "Gardensign - $($_filenameSafe).scad"
    $_tempStlPath  = Join-Path "$PSScriptRoot\$_outputFolder" "Gardensign - $($_filenameSafe).stl"

    # Vorhandene Dateien löschen
    if (Test-Path $_tempScadPath) {
        Remove-Item $_tempScadPath -Force
        Write-Host "🗑️ Delete old SCAD file: $_tempScadPath" -ForegroundColor DarkGray
    }
    if (Test-Path $_tempStlPath) {
        Remove-Item $_tempStlPath -Force
        Write-Host "🗑️ Delete old STL file: $_tempStlPath" -ForegroundColor DarkGray
    }

    # Neue SCAD-Datei schreiben (UTF-8 ohne BOM)
    [System.IO.File]::WriteAllText($_tempScadPath, $_scadContent, [System.Text.UTF8Encoding]::new($false))

    # OpenSCAD ausführen
    #& "$_openSCADPath" -o $_tempStlPath $_tempScadPath
    Start-Process -FilePath "$_openSCADPath" `
              -ArgumentList "-o", "`"$_tempStlPath`"", "`"$_tempScadPath`"" `
              -NoNewWindow -Wait `
              -RedirectStandardError "nul"

    # Temporäre SCAD-Datei nach jedem Lauf löschen
    if (Test-Path $_tempScadPath) {
        Remove-Item $_tempScadPath -Force
        Write-Host \"🧹 Delete temporary file: $_tempScadPath\" -ForegroundColor DarkGray
    }

    if (Test-Path $_tempStlPath) {
        if ((Get-Item $_tempStlPath).Length -gt 0) {
            Write-Host "✅ Successful created STL file: $_tempStlPath" -ForegroundColor Green
        } else {
            Write-Host "[X] STL-Datei leer: $_tempStlPath" -ForegroundColor Red
        }
    } else {
        Write-Host "[X] STL-File was not created: $_tempStlPath" -ForegroundColor Red
    }

}
