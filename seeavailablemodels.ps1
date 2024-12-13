$path = "$env:UserProfile\.cache\huggingface\hub"
$num = 0

Write-Host "Assuming HuggingFaceHub directory is $path..."

Get-ChildItem -Path $path -Directory | ForEach-Object {
    $folderName = $_.Name
    try {$modifiedName = $folderName.Substring(8)}
    catch {}

    $modifiedName = $modifiedName -replace "--", "/"

    Write-Host $modifiedName

    if (-not [string]::IsNullOrEmpty($modifiedName)) {
        $num++
    }
}

Write-Host ""
Write-Host "$num models found."
Write-Host ""

Read-Host -Prompt "Press Enter to continue"
