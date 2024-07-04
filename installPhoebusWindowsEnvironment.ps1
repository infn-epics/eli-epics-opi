#variabile con path ove verrà installato Phoebus e il progetto git.
$destinationPath = "C:\Users\sparc"
# Directory temporanea
$tempDir = $destinationPath

# Percorso corrente dello script
$scriptPath = $MyInvocation.MyCommand.Path

# Nome file dello script
$scriptName = [System.IO.Path]::GetFileName($scriptPath)

# Percorso dello script nella directory temporanea
$tempScriptPath = Join-Path $tempDir $scriptName

if ($scriptPath -ne $tempScriptPath) {
    Copy-Item $scriptPath $tempScriptPath -Force
    # Esegui lo script nella directory temporanea e termina l'esecuzione dell'originale
    & $tempScriptPath @args
    Exit
}

# Script originario realizzato da IlSoftware.it  https://www.ilsoftware.it modificato da A. D'Uffizi
#Check di sicurezza permessi
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	
	
	$scriptPath = $MyInvocation.MyCommand.Path
    $scriptArgs = $args[0]
	if (-not $scriptArgs) {
        $scriptArgs = @()
    }
	$arguments = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$scriptPath`"") + $scriptArgs
	Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
	Exit
}
#check versione operativo
if([System.Environment]::OSVersion.Version.Build -lt 18363) {"ATTENZIONE: Per usare lo script e' necessario aggiornare almeno a Windows 10 versione 1909 ..."; Start-Sleep -s 5; Exit}


#!codice per attivare feature OpenSSH-Server. Commentato perché ancora da problemi. 
#!Probabilmente manca una istruzione: il download della feature.
#Comunque non necessario


#$featureName = "OpenSSH-Server"
# Abilita la feature opzionale OpenSSH Server
#Write-Output "Abilitazione della feature opzionale $featureName..."
#Add-WindowsCapability -Online -Name $featureName

# Imposta il servizio OpenSSH Server in avvio automatico
#Write-Output "Impostazione del servizio OpenSSH Server in avvio automatico..."
#Set-Service -Name "sshd" -StartupType Automatic

# Avvia il servizio OpenSSH Server
#Write-Output "Avvio del servizio OpenSSH Server..."
#Start-Service -Name "sshd"

# Verifica lo stato del servizio
#$serviceStatus = Get-Service -Name "sshd"
#Write-Output "Lo stato del servizio OpenSSH Server è: $($serviceStatus.Status)"


#SWITCH per installazione completa mettere tutto a true, tranne Prereq,  obsoleto 
$installPrereq=$false
if ($args[0] -eq "install") {
	Write-Output "Installazione programmi automatizzata"
	$installPackages=$true
	$installPhoebus=$true 
	$cloneGitProject=$true
	$setDefaultApp=$true
	$copysettings=$true
	$installLink=$true
}
else
{
	Write-Output "Esecuzione update"
	$installPackages=$false
	$installPhoebus=$false
	$cloneGitProject=$true
	$setDefaultApp=$false
	$copysettings=$true
	$installLink=$false
}

Write-Output "Moving to "  $destinationPath
Set-Location -Path $destinationPath
# ! Fase download. Il software originario scarica winget e VCLibs. A noi non sembrano servire. Winget c'è di default e funziona.
#Creazione web client 
$wc = New-Object System.Net.WebClient

$output=".\DesktopAppInstaller.appxbundle"
$output2=".\VCLibs.appx"

$output3=$destinationPath + "/phoebus.zip"
$json=Invoke-WebRequest 'https://api.github.com/repos/microsoft/winget-cli/releases/latest' -UseBasicParsing
$psobj = ConvertFrom-Json $json
$version=$psobj.tag_name

# Crea la directory di destinazione se non esiste
if (!(Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath
}


if ($installPrereq) 
{
	Write-Host "Download WinGet in corso..." -ForegroundColor white -BackgroundColor green
	$wc.DownloadFile("https://github.com/microsoft/winget-cli/releases/download/$version/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle",$output)

	Write-Host "Download VCLibs in corso..." -ForegroundColor white -BackgroundColor green
	if([Environment]::Is64BitOperatingSystem) {$wc.DownloadFile("https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx",$output2)}
	else{$wc.DownloadFile("https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx",$output2)}
}
else 
{
	Write-Host "Skipped prerequisites.."
}

#Istruzioni originarie forse utili con le VCLibs. Per noi ancora inutili 
#Add-AppxPackage -Path $output2 -ErrorAction SilentlyContinue
#Add-AppxPackage -Path $output
#Clear


#Installazione Git, Java, Python da pacchetti winget
if ($installPackages)
{
	winget install Git.Git --accept-package-agreements --accept-source-agreements
	winget install Microsoft.OpenJDK.17 --accept-package-agreements --accept-source-agreements
	winget install Python.Python.3.9 --accept-package-agreements --accept-source-agreements
}
else
{
	Write-Host("Skipped packages")
}
if ($installPhoebus) 
{
#Download di Phoebus
	$ph_version="4.7.3"
	Write-Host "Downloading phoebus in corso..." -ForegroundColor white -BackgroundColor green

	#WARNING E' meglio parametrizzare la versione anche in considerazione del rename successivo 
	$wc.DownloadFile("https://controlssoftware.sns.ornl.gov/css_phoebus/nightly/phoebus-win.zip",$output3)
	#$wc.DownloadFile("https://github.com/ControlSystemStudio/phoebus/releases/download/v"+$ph_version+"/phoebus-"+$ph_version+"-win.zip",$output3)
	#https://github.com/ControlSystemStudio/phoebus/releases/download/v4.7.2/Phoebus-4.7.2-win.zip



	
	Write-Host "Extracting phoebus..." -ForegroundColor white -BackgroundColor green
	tar -xf $output3 
	$oldName="phoebus-"+$ph_version+"-SNAPSHOT" 
	Rename-Item -Path $oldName -NewName "Phoebus"
	Remove-Item $output3
}
else
{
	Write-Host "Skipped Phoebus" 
}
if ($cloneGitProject)
{
	if ($args[0] -eq "install") 
	{
		
		Write-Host "Cloning git project.." -ForegroundColor white -BackgroundColor green
		git clone https://baltig.infn.it/lnf-da-control/epik8-sparc.git --recurse-submodule
	}
	else
	{
		$gitPath=$destinationPath+"/epik8-sparc"
		if (Test-Path $gitPath) {
			Write-Host "Removing dir " $gitPath -ForegroundColor white -BackgroundColor green
		# Cancella la directory
		Remove-Item -Recurse -Force $gitPath
		}
		Write-Host "Cloning git project.." -ForegroundColor white -BackgroundColor green
		git clone https://baltig.infn.it/lnf-da-control/epik8-sparc.git --recurse-submodule
		
	}
}
else
{
	Write-Host "Skipped clone epik8-sparc"
}
if ($setDefaultApp) 
{
	Write-Host "Setting phoebus as predefined launcher for .bob"  -ForegroundColor white -BackgroundColor green

	$extension = ".bob"
	$applicationProgID = "Phoebus"
	#percorso dell'eseguibile
	$applicationPath = $destinationPath +"\Phoebus\phoebus.bat"

	# Crea un ProgID per l'applicazione se non esiste
	if (-not (Test-Path "HKCU:\Software\Classes\$applicationProgID")) {
	New-Item -Path "HKCU:\Software\Classes\$applicationProgID" -Force
	}
	Set-ItemProperty -Path "HKCU:\Software\Classes\$applicationProgID" -Name "FriendlyTypeName" -Value "$applicationProgID File"
	if (-not (Test-Path "HKCU:\Software\Classes\$applicationProgID\DefaultIcon")) {
		New-Item -Path "HKCU:\Software\Classes\$applicationProgID\DefaultIcon" -Force
	}
	Set-ItemProperty -Path "HKCU:\Software\Classes\$applicationProgID\DefaultIcon" -Name "(default)" -Value "$applicationPath,0"

	if (-not (Test-Path "HKCU:\Software\Classes\$applicationProgID\shell\open\command")) {
	New-Item -Path "HKCU:\Software\Classes\$applicationProgID\shell\open\command" -Force
	}
	Set-ItemProperty -Path "HKCU:\Software\Classes\$applicationProgID\shell\open\command" -Name "(default)" -Value "`"$applicationPath`" -resource `"%1`" "

	# Associa l'estensione al ProgID
	New-Item -Path "HKCU:\Software\Classes\$extension" -Force
	Set-ItemProperty -Path "HKCU:\Software\Classes\$extension" -Name "(default)" -Value $applicationProgID
}
else
{
	Write-Host "Skipped setting phoebus as default app opening .bob"
}

if ($copysettings)
{
	$phoebusPath=$destinationPath+"\Phoebus"
	$settingTemplate=$destinationPath+"\epik8-sparc\opi\settings_template.ini"
	Write-Host "Copying settings.ini"  -ForegroundColor white -BackgroundColor green
	if  ((Test-Path $phoebusPath) -and (Test-Path $settingTemplate)) {

	Copy-Item -Path  $settingTemplate -Destination $phoebusPath"\settings.ini"
	$username = $env:USERNAME
	$pythonPath = "c:/Users/$username/AppData/Local/Programs/Python/Python39/python -i"
	$configEntry =[Environment]::NewLine+ "org.phoebus.applications.console/shell=$pythonPath"
	Write-Host("Adding python path to settings.ini")
	Add-Content -Path .\Phoebus\settings.ini  -Value $configEntry
}
	else
	{
		Write-Host "Test path failed:" $settingTemplate   " and " $phoebusPath 
	}
}
else
{
	Write-Host "Skipped copying settings"
}

if ($installLink)
{
	Write-Host("Creating link on desktop")
	$targetPath = $destinationPath +"/epik8-sparc/opi/Launcher.bob"
	if (-Not (Test-Path -Path $targetPath)) {
    Write-Host "Il file di destinazione non esiste: $targetPath"
    return
}
	# Percorso del desktop
	$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "SPARC LAUNCHER.lnk")

	# Creazione del COM object WScript.Shell
	$wshShell = New-Object -ComObject WScript.Shell

	# Creazione del collegamento
	$shortcut = $wshShell.CreateShortcut($desktopPath)
	$shortcut.TargetPath = $targetPath
	$iconPath = "C:\Windows\System32\shell32.dll"
	$iconIndex = 18
	$shortcut.IconLocation = "$iconPath,$iconIndex"
	$shortcut.Save()

	Write-Host "Collegamento creato con successo sul desktop."
}
else
{
	Write-Host "Skipped link on desktop"
}

Write-Host("Installazione completata")
Remove-Item $tempScriptPath -Force
#Impedisci la chiusura powershell in attesa di input utente 
Read-Host

# Utilizzare eventualmente la forma seguente:
# winget install --id Recuva --interactive --scope machine
# In questo modo non si accetteranno mai le impostazioni predefinite per l'installazione del software indicato
# e l'applicazione sarà installata per tutti gli account utente configurati sulla macchina Windows.
