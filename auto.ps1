$ErrorActionPreference = "Stop"
$env:PYTHONIOENCODING = "utf-8"

# 配置
$RepoPath = "C:\Users\Xioa\Desktop\Blog"
$Branch = "main"
$ApiUrl = "https://api.deepseek.com/chat/completions"

# 确保在仓库目录
Set-Location $RepoPath

# 初始化 .env
if (-not (Test-Path ".env")) {
    $key = Read-Host "首次运行，请输入 DeepSeek API 密钥"
    @"
DEEPSEEK_API_KEY=$key
DEEPSEEK_MODEL=deepseek-chat
"@ | Out-File -FilePath ".env" -Encoding Default
    Write-Host ".env 已创建" -ForegroundColor Green
}
$envContent = Get-Content ".env" | Where-Object { $_ -match "=" }
foreach ($line in $envContent) {
    $parts = $line -split '=', 2
    Set-Variable -Name $parts[0] -Value $parts[1]
}

if (-not $DEEPSEEK_API_KEY) {
    Write-Host "[错误] .env 中未配置 DEEPSEEK_API_KEY" -ForegroundColor Red
    pause
    exit
}

# .gitignore 确保 .env 不被提交
if (-not (Test-Path ".gitignore")) {
    ".env" | Out-File ".gitignore"
} elseif (-not (Select-String -Path ".gitignore" -Pattern ".env")) {
    ".env" | Add-Content ".gitignore"
}

Write-Host "========================================"
Write-Host "     Git 博客自动同步 (DeepSeek AI)"
Write-Host "========================================"
Write-Host "  目录: $RepoPath"
Write-Host "  分支: $Branch"
Write-Host "  时间: $(Get-Date)"
Write-Host ""

# 检测变更
Write-Host "[扫描] 正在检测文件变更..." -ForegroundColor Cyan
git add . 2>$null
$diffOutput = git diff --cached --name-only
if (-not $diffOutput) {
    Write-Host "[完成] 没有检测到任何变更" -ForegroundColor Green
    pause
    exit
}

Write-Host "[发现] 变更的文件:" -ForegroundColor Yellow
$diffOutput | ForEach-Object { Write-Host "  $_" }

$choice = Read-Host "请选择: [A]AI生成提交信息 [M]手动输入 [C]取消"
if ($choice -eq 'C') { exit }

if ($choice -eq 'A') {
    Write-Host "[AI] 正在请求 DeepSeek 生成提交信息..." -ForegroundColor Cyan
    
    $changedFiles = ($diffOutput -join ", ")
    $systemPrompt = "你是Git提交信息生成器。根据变更文件生成简洁的中文commit，格式：类型: 简短描述，不超过50字。"
    $userPrompt = "变更文件: $changedFiles。请生成commit信息。"
    
    $body = @{
        model = $DEEPSEEK_MODEL
        messages = @(
            @{role="system"; content=$systemPrompt},
            @{role="user"; content=$userPrompt}
        )
        max_tokens = 50
        temperature = 0.7
    } | ConvertTo-Json -Depth 4

    try {
        $response = Invoke-RestMethod -Uri $ApiUrl -Method Post `
            -Headers @{
                "Content-Type" = "application/json"
                "Authorization" = "Bearer $DEEPSEEK_API_KEY"
            } -Body $body

        $COMMIT_MSG = $response.choices[0].message.content.Trim()
        Write-Host "[AI] 生成的信息: $COMMIT_MSG" -ForegroundColor Green
        $useChoice = Read-Host "是否使用? [Y]是 [N]手动输入 [R]重新生成"
        if ($useChoice -eq 'N') { $choice = 'M' }
        if ($useChoice -eq 'R') { $COMMIT_MSG = $null; $choice = 'A' }
    } catch {
        Write-Host "[错误] AI 生成失败: $($_.Exception.Message)" -ForegroundColor Red
        $COMMIT_MSG = "自动更新: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
}

if ($choice -eq 'M' -or -not $COMMIT_MSG) {
    $COMMIT_MSG = Read-Host "请输入提交信息"
    if (-not $COMMIT_MSG) { $COMMIT_MSG = "手动更新: $(Get-Date -Format 'yyyy-MM-dd HH:mm')" }
}

Write-Host "[提交] 正在提交变更..." -ForegroundColor Cyan
git commit -m $COMMIT_MSG

Write-Host "[推送] 正在推送到远程仓库..." -ForegroundColor Cyan
git push origin $Branch
if ($LASTEXITCODE -eq 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  成功! 同步完成"
    Write-Host "  提交信息: $COMMIT_MSG"
    Write-Host "========================================"
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  失败! 请检查网络或 Git 配置"
    Write-Host "========================================"
}

pause