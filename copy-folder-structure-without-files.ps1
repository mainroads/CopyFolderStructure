param (
    [Parameter(Mandatory=$true)]
    [string]$sourceDir,

    [Parameter(Mandatory=$true)]
    [string]$destDir,

    [int]$folderLevel = -1
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
    New-Item -ItemType Directory -Path $destDir -ErrorAction SilentlyContinue | Out-Null
}

# Get all subdirectories under the source directory up to the specified levels deep
if ($folderLevel -ge 0) {
    $sourceDirs = Get-ChildItem -Path $sourceDir -Recurse -Directory -Depth $folderLevel |
        Where-Object { ($_.FullName -ne $sourceDir) -and ($_.FullName.Split('\').Count -le $sourceDir.Split('\').Count + $folderLevel) }
} else {
    $sourceDirs = Get-ChildItem -Path $sourceDir -Recurse -Directory
}

foreach ($dir in $sourceDirs) {
    # Replace source directory path with destination in each subdirectory path
    $destSubDir = $dir.FullName.Replace($sourceDir, $destDir)

    # Create the subdirectory under destination if it does not exist
    New-Item -ItemType Directory -Path $destSubDir -ErrorAction SilentlyContinue | Out-Null
}
