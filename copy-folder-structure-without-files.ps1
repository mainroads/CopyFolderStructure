param (
    [Parameter(Mandatory=$true)]
    [string]$sourceDir,

    [Parameter(Mandatory=$true)]
    [string]$destDir
)

# Remove quotation marks from the directory paths
$sourceDir = $sourceDir.Trim('"')
$destDir = $destDir.Trim('"')

# Ensure that the source directory exists
if (!(Test-Path -Path $sourceDir -PathType Container)) {
    Write-Error "The source directory $sourceDir does not exist."
    return
}

# Ensure that the destination directory exists, create it if it doesn't
if (!(Test-Path -Path $destDir -PathType Container)) {
    New-Item -ItemType Directory -Path $destDir | Out-Null
}

# Get all subdirectories under the source directory
$sourceDirs = Get-ChildItem -Path $sourceDir -Recurse -Directory

foreach ($dir in $sourceDirs) {
    # Replace source directory path with destination in each subdirectory path
    $destSubDir = $dir.FullName.Replace($sourceDir, $destDir)

    # Create the subdirectory under destination if it does not exist
    if (!(Test-Path -Path $destSubDir -PathType Container)) {
        New-Item -ItemType Directory -Path $destSubDir | Out-Null
    }
}
