$repoUrl = "ADD YOU GIT REPO URL HERE"
$maxCommits = 15

New-Item -ItemType Directory -Name "sunrise-gradient-ps"
Set-Location "sunrise-repo-ps"
git init

# Set the desired start date (Currently set to the First of January 2025)
$startDate = [datetime]::Parse("2025-01-01T12:00:00")

Write-Host "Generating commit history... this will take a few minutes."

# Loop throughout the year.
for ($i = 0; $i -le 364; $i++) {
    $currentDate = $startDate.AddDays($i)
    # Format date for Git's environment variable
    $formattedDate = $currentDate.ToString("yyyy-MM-ddTHH:mm:ss")

    $rawCommits = ($i / 364) * $maxCommits
    $numCommits = [math]::Round($rawCommits)

    Write-Host "Day ${i}: Making $numCommits commit(s) for date $formattedDate"

    for ($j = 1; $j -le $numCommits; $j++) {
        Set-Content -Path "content.txt" -Value "$i-$j"
        git add "content.txt"
        
        cmd /c "set GIT_AUTHOR_DATE=$formattedDate && set GIT_COMMITTER_DATE=$formattedDate && git commit --quiet -m `"commit $i-$j`""
    }
}

Write-Host "History generated. Pushing to GitHub..."

git remote add origin $repoUrl
git branch -M main
git push -f -u origin main

Write-Host "Done! Check your GitHub profile in a few moments."
