$oldFragment = 'style="margin-bottom: var\(--space-3\); color: var\(--text-primary\); text-decoration: none;"'
$newFragment = 'style="margin-bottom: var(--space-3);"'

$files = Get-ChildItem -Recurse -Include *.html
foreach ($file in $files) {
    if ($file.Name -ne "404.html") {
        $content = Get-Content $file.FullName -Raw
        if ($content -match $oldFragment) {
            $newContent = $content -replace $oldFragment, $newFragment
            Set-Content $file.FullName $newContent -NoNewline
            Write-Host "Updated brand color in footer of $($file.Name)"
        }
    }
}
