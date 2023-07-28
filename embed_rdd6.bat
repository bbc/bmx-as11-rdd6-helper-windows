<# : embed_rdd6.bat
: Embed RDD 6 surround sound metadata in an AS-11 HD file

@echo off
setlocal

powershell -noprofile "iex (${%~f0} | out-string)"

goto :EOF

: end Batch portion / begin PowerShell hybrid chimera #>

Write-Host Embed RDD 6 Surround Sound Metadata in an AS-11 UK DPP HD file
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

$m = .\bmx\mxf2raw --as11 "$as11_file" | Select-String -Pattern " audio_track_layout " -SimpleMatch -CaseSensitive
if ($m -eq $null) {
    Write-Host No AS_11_Audio_Track_Layout metadata property found: is this an AS-11 UK DPP file?
    pause
    exit
}
$required_layout_1 = "EBU_R_123_16c (value='49')"
$required_layout_2 = "EBU_R_123_16d (value='50')" # must be same length as above
$actual_layout = $m.ToString().Substring($m.ToString().length - $required_layout_1.length, $required_layout_1.length)
if ($actual_layout -ne $required_layout_1 -And $actual_layout -ne $required_layout_2) {
    Write-Host Audio track layout is ${actual_layout}: must be $required_layout_1 or $required_layout_2
    pause
    exit
}
$m = .\bmx\mxf2raw --as11 "$as11_file" | Select-String -Pattern "[S2020-1] Compressed Audio Metadata" -SimpleMatch -CaseSensitive
$message = ""
if ($m -ne $null) {
    Write-Host "${as11_file}: This file already contains Compressed Audio Metadata" -ForegroundColor DarkYellow
    Write-Host "Press 'y' if you want to replace it, or any other key to exit"
    if ($host.ui.RawUI.ReadKey('NoEcho,IncludeKeyDown').Character -ne "y") {
        exit
    }
    $message = "(ignore the two warnings)" 
}

$f.Title = "Choose RDD 6 metadata XML file"
$f.InitialDirectory = [System.IO.Path]::GetDirectoryName("$as11_file")
$f.Filter = "XML Files (*.xml)|*.xml|All Files (*.*)|*.*"
$f.FileName = ""
$f.ShowHelp = $true
if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::Cancel) {
    exit
}
$rdd6_file = $f.FileName

$f = new-object Windows.Forms.SaveFileDialog
$f.Title = "Specify output filename"
$f.InitialDirectory = [System.IO.Path]::GetDirectoryName("$rdd6_file")
$f.FileName = [System.IO.Path]::GetFileNameWithoutExtension("$as11_file") `
    + "_with_rdd6" + [System.IO.Path]::GetExtension("$as11_file")
if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::Cancel) {
    exit
}
$output_file = $f.FileName

Write-Host "Creating $output_file $message"
.\bmx\bmxtranswrap.exe -o "$output_file" -p --rdd6 "$rdd6_file" -t as11op1a --pass-dm "$as11_file"
if ($? -eq "True") {
    Write-Host Success
}
pause