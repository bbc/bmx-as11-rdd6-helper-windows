<# : embed_rdd6.bat
: Embed RDD 6 surround sound metadata in an AS-11 HD file

@echo off
setlocal

powershell -noprofile "iex (${%~f0} | out-string)"

goto :EOF

: end Batch portion / begin PowerShell hybrid chimera #>

function Fail-And-Exit {
    Write-Host "               " -ForegroundColor red -BackgroundColor white
    Write-Host "  ###########  " -ForegroundColor red -BackgroundColor white
    Write-Host "  # FAILURE #  " -ForegroundColor red -BackgroundColor white
    Write-Host "  ###########  " -ForegroundColor red -BackgroundColor white
    Write-Host "               " -ForegroundColor red -BackgroundColor white
    pause
    exit
}

Clear-Host
Write-Host " Embed RDD 6 Surround Sound Metadata in an AS-11 UK DPP HD file " -ForegroundColor blue -BackgroundColor white
Write-Host This script will display a series of File Chooser windows
pause
Write-Host
Write-Host Choose an AS-11 HD file in the File Chooser window...
Add-Type -AssemblyName System.Windows.Forms
$f = new-object Windows.Forms.OpenFileDialog
$f.Title = "Choose AS-11 HD file"
$f.InitialDirectory = pwd
$f.Filter = "MXF Files (*.mxf)|*.mxf|All Files (*.*)|*.*"
$f.ShowHelp = $true
if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::Cancel) {
    exit
}
$as11_file = $f.FileName
Write-Host "Chose $as11_file"
Write-Host

$m = .\bmx\mxf2raw --as11 "$as11_file" | Select-String -Pattern " audio_track_layout " -SimpleMatch -CaseSensitive
if ($m -eq $null) {
    Write-Host No AS_11_Audio_Track_Layout metadata property found: is this an AS-11 UK DPP file?
    Fail-And-Exit
}
$required_layout_1 = "EBU_R_123_16c (value='49')"
$required_layout_2 = "EBU_R_123_16d (value='50')" # must be same length as above
$actual_layout = $m.ToString().Substring($m.ToString().length - $required_layout_1.length, $required_layout_1.length)
if ($actual_layout -ne $required_layout_1 -And $actual_layout -ne $required_layout_2) {
    Write-Host Audio track layout is ${actual_layout}: must be $required_layout_1 or $required_layout_2
    Fail-And-Exit
}
$m = .\bmx\mxf2raw --as11 "$as11_file" | Select-String -Pattern "[S2020-1] Compressed Audio Metadata" -SimpleMatch -CaseSensitive
$message = "..."
if ($m -ne $null) {
    Write-Host "This file already contains RDD 6 Audio Metadata" -ForegroundColor DarkYellow
    Write-Host "Press 'y' if you want to replace it, or any other key to exit"
    if ($host.ui.RawUI.ReadKey('NoEcho,IncludeKeyDown').Character -ne "y") {
        exit
    }
    Write-Host
    $message = " (ignore the two warnings)..." 
}

Write-Host Choose an RDD 6 metadata XML file in the File Chooser window...
$f.Title = "Choose RDD 6 metadata XML file"
$f.InitialDirectory = [System.IO.Path]::GetDirectoryName("$as11_file")
$f.Filter = "XML Files (*.xml)|*.xml|All Files (*.*)|*.*"
$f.FileName = ""
$f.ShowHelp = $true
if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::Cancel) {
    exit
}
$rdd6_file = $f.FileName
Write-Host "Chose $rdd6_file"
Write-Host

Write-Host Specify an output filename in the File Chooser window...
$f = new-object Windows.Forms.SaveFileDialog
$f.Title = "Specify output filename"
$f.InitialDirectory = [System.IO.Path]::GetDirectoryName("$rdd6_file")
$f.FileName = [System.IO.Path]::GetFileNameWithoutExtension("$as11_file") `
    + "_with_rdd6" + [System.IO.Path]::GetExtension("$as11_file")
if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::Cancel) {
    Fail-And-Exit
}
$output_file = $f.FileName

Write-Host "Creating $output_file$message"
.\bmx\bmxtranswrap.exe -o "$output_file" -p --rdd6 "$rdd6_file" -t as11op1a --pass-dm "$as11_file"
if ($? -eq "True") {
    Write-Host "               " -ForegroundColor green -BackgroundColor white
    Write-Host "  ###########  " -ForegroundColor green -BackgroundColor white
    Write-Host "  # SUCCESS #  " -ForegroundColor green -BackgroundColor white
    Write-Host "  ###########  " -ForegroundColor green -BackgroundColor white
    Write-Host "               " -ForegroundColor green -BackgroundColor white
    pause
}
else {
    Fail-And-Exit
}
