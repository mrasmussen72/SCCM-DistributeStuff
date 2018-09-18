#
# Press 'F5' to run this script. Running this script will load the ConfigurationManager
# module for Windows PowerShell and will connect to the site.
#
# This script was auto-generated at '9/18/2018 1:05:52 PM'.

# Uncomment the line below if running in an environment where script signing is 
# required.
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

######################################## Script Variables ########################

$dpGroup = "AllDPs" # DP group name
$SiteCode = "MS1" # Site code
$LogFilePath = "c:\Windows\CCM\Logs\DistributeStuff.Log" # path to log file
$ProviderMachineName = "MSACCT-SCCM.MSACCTCloud.Local" # SMS Provider machine name

####################################### End Script Variables #####################

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams

$stringBuilder = New-Object System.Text.StringBuilder

function Write-Logging($message)
{
	$dateTime = Get-Date -Format yyyyMMddTHHmmss
	$null = $stringBuilder.Append($dateTime.ToString())
	$null = $stringBuilder.Append( "`t==>>`t")
	$null = $stringBuilder.AppendLine( $message)
    $stringBuilder.ToString() | Out-File -FilePath $LogFilePath -Append
    $stringBuilder.Clear() | Out-Null
}

Write-Logging -message "Starting Script##########################"
Write-Logging -message "DP Group = $($dpGroup)"
Write-Logging -message "Getting Applications..."
$apps = Get-CMApplication
Write-Logging -message "Number of apps = $($apps.Count.ToString())"
Write-Logging -message "Getting Packages..."
$packages = Get-CMPackage
Write-Logging -message "Nuymber of packages = $($packages.Count.ToString())"
Write-Logging -message "Getting boot images..."
$bootImages = Get-CMBootImage
Write-Logging -message "Number of boot images = $($bootImages.Count.ToString())"
$driverPackages = Get-CMDriverPackage
Write-Logging -message "Getting OS Images..."
$osImages = Get-CMOperatingSystemImage
Write-Logging -message "Numvber of operating system images = $($osImages.Count.ToString())"
$osUpdatePackages = Get-CMOperatingSystemUpgradePackage

Write-Logging -message "Starting distributions"
foreach($app in $apps)
{
    Write-Logging -message "Distributing $($app.LocalizedDisplayName)"
    #Start-CMContentDistribution -ApplicationName $app.LocalizedDisplayName -DistributionPointGroupName $dpGroup -Verbose
}

foreach($package in $packages)
{
    Write-Logging -message "Distributing $($package.Name)"
    #Start-CMContentDistribution -PackageName $package.Name -DistributionPointName $dpGroup -Verbose
}

foreach($bootImage in $bootImages)
{
    Write-Logging -message "Distributing $($bootImage.Name)"
    #Start-CMContentDistribution -BootImageName $bootImage.Name -DistributionPointGroupName $dpGroup -Verbose
}

foreach($driverPackage in $driverPackages)
{
    Write-Logging -message "Distributing $($driverPackage.Name)"
    #Start-CMContentDistribution -DriverPackageName $driverPackage.Name -DistributionPointGroupName $dpGroup -Verbose
}

foreach($osImage in $osImages)
{
    Write-Logging -message "Distributing $($osImage.Name)"
    #Start-CMContentDistribution -OperatingSystemImageName $osImage.Name -DistributionPointGroupName $dpGroup -Verbose
}

foreach($osUpdatePackage in $osUpdatePackages)
{
    Write-Logging -message "Distributing $($osUpdatePackage.Name)"
    #Start-CMContentDistribution -OperatingSystemInstallerName $osUpdatePackage.Name -DistributionPointGroupName $dpGroup -Verbose
}
