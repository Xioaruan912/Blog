@echo off
setlocal DisableDelayedExpansion
chcp 65001 >nul
set "GIT_AUTO_FILE=%~f0"
set "GIT_AUTO_ARGS=%*"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$s=[IO.File]::ReadAllText($env:GIT_AUTO_FILE,[Text.Encoding]::UTF8); & ([scriptblock]::Create(($s -split '(?m)^# POWERSHELL_START\r?$',2)[1]))"
exit /b %errorlevel%
# POWERSHELL_START
# Single-file launcher: keep the batch header ASCII and save as UTF-8 without BOM.
$ErrorActionPreference = 'Stop'
$utf8 = New-Object Text.UTF8Encoding($false)
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8
$options = @($env:GIT_AUTO_ARGS -split '\s+' | Where-Object { $_ })
$noPause = $options -contains '--no-pause'
$yes = $options -contains '--yes'
$check = $options -contains '--check'
$exitCode = 0

function Say([string]$Text) { Write-Host $Text }
function Git([string[]]$Arguments, [switch]$AllowFailure) {
    # Native stderr is an ErrorRecord in Windows PowerShell, not status data.
    $saved = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $result = @(& git.exe -c core.quotepath=false @Arguments 2>&1)
        $code = $LASTEXITCODE
    } finally { $ErrorActionPreference = $saved }
    $diagnostic = ($result | Where-Object { $_ -is [Management.Automation.ErrorRecord] } | ForEach-Object { $_.ToString() }) -join "`n"
    $result = @($result | Where-Object { $_ -isnot [Management.Automation.ErrorRecord] })
    $script:gitCode = $code
    $output = $result -join "`n"
    if ($code -ne 0 -and -not $AllowFailure) {
        throw ("Git 操作失败：git {0}`n{1}`n{2}" -f ($Arguments -join ' '), $output, $diagnostic)
    }
    if ($code -eq 0 -and $diagnostic) { Write-Host $diagnostic.TrimEnd() }
    return $output
}
function RunGit([string[]]$Arguments) {
    $output = Git $Arguments
    if ($output) { Say $output }
}
function Read-TimedInput([string]$Prompt, [string]$Default = '') {
    Write-Host "$Prompt（5 秒未输入使用默认；开始输入后按回车确认）: " -NoNewline
    $timer = [Diagnostics.Stopwatch]::StartNew()
    $buffer = New-Object Text.StringBuilder
    if ([Console]::IsInputRedirected) {
        $line = [Console]::In.ReadLineAsync()
        while ($timer.Elapsed.TotalSeconds -lt 5) {
            if ($line.IsCompleted) {
                $value = $line.GetAwaiter().GetResult()
                if ($null -ne $value) {
                    Write-Host $value
                    if ([string]::IsNullOrWhiteSpace($value)) { return $Default }
                    return $value
                }
            }
            Start-Sleep -Milliseconds 50
        }
    } else {
        $started = $false
        while ($started -or $timer.Elapsed.TotalSeconds -lt 5) {
            if (-not [Console]::KeyAvailable) { Start-Sleep -Milliseconds 50; continue }
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq [ConsoleKey]::Enter) {
                Write-Host ''
                if ([string]::IsNullOrWhiteSpace($buffer.ToString())) { return $Default }
                return $buffer.ToString()
            }
            if ($key.Key -eq [ConsoleKey]::Backspace) {
                if ($buffer.Length -gt 0) {
                    $null = $buffer.Remove($buffer.Length - 1, 1)
                    Write-Host "`b `b" -NoNewline
                }
            } elseif (-not [char]::IsControl($key.KeyChar)) {
                $started = $true
                $null = $buffer.Append($key.KeyChar)
                Write-Host $key.KeyChar -NoNewline
            }
        }
    }
    Write-Host '[超时，使用默认值]'
    return $Default
}
function Sync-Repository {
    if ($options -contains '--help') {
        Say '可复制到任意仓库根目录或子目录，自动读取该仓库的 Git 配置。'
        Say '用法：Auto.bat [--check] [--yes] [--no-pause]'
        Say '  默认：确认与提交说明各等待 5 秒，无输入自动确认并使用默认摘要。'
        Say '  --check：仅本地检查；不联网、不暂存、不提交、不推送。'
        Say '  --yes：使用自动提交摘要，免交互确认。'
        Say '  --no-pause：结束后不等待，适合终端和自动化调用。'
        return
    }
    foreach ($option in $options) {
        if ($option -notin @('--check','--yes','--no-pause')) { throw "未知参数：$option；使用 --help 查看帮助。" }
    }
    if (-not (Get-Command git.exe -ErrorAction SilentlyContinue)) { throw '未找到 Git，请先安装 Git 并加入 PATH。' }
    # Bind discovery to this script, not the launching shell's repository overrides.
    foreach ($variable in @('GIT_DIR','GIT_WORK_TREE','GIT_COMMON_DIR','GIT_INDEX_FILE','GIT_OBJECT_DIRECTORY','GIT_ALTERNATE_OBJECT_DIRECTORIES','GIT_NAMESPACE','GIT_PREFIX','GIT_CEILING_DIRECTORIES')) {
        [Environment]::SetEnvironmentVariable($variable, $null, 'Process')
    }
    Set-Location -LiteralPath (Split-Path -LiteralPath $env:GIT_AUTO_FILE)
    Say '========== 通用仓库 · 智能 Git 同步 =========='
    # Git resolves both .git directories and .git files (worktrees/submodules).
    $inside = Git @('rev-parse','--is-inside-work-tree') -AllowFailure
    if ($gitCode -ne 0 -or $inside -ne 'true') {
        throw '未找到有效的 Git 工作区。请把 Auto.bat 放入目标仓库根目录（与 .git 同级）或其子目录；裸仓库不支持。'
    }
    $root = Git @('rev-parse','--show-toplevel')
    $gitDirectory = Git @('rev-parse','--absolute-git-dir')
    $repoName = Split-Path -Leaf $root
    Set-Location -LiteralPath $root
    $branch = Git @('symbolic-ref','--quiet','--short','HEAD') -AllowFailure
    if ($gitCode -ne 0) { throw '当前为游离 HEAD，请先切换到需要同步的分支。' }
    foreach ($state in @('MERGE_HEAD','rebase-merge','rebase-apply','CHERRY_PICK_HEAD','REVERT_HEAD','sequencer','index.lock')) {
        $path = Git @('rev-parse','--git-path',$state)
        if (Test-Path -LiteralPath $path) { throw "发现未完成操作或锁文件：$state。请先运行 git status 处理后重试。" }
    }
    $conflicts = Git @('diff','--name-only','--diff-filter=U')
    if ($conflicts) { throw "存在未解决冲突：`n$conflicts" }
    Say "[项目] $repoName"
    Say "[仓库] $root"
    Say "[Git 目录] $gitDirectory"
    Say "[当前分支] $branch"
    $status = Git @('status','--porcelain=v1','--untracked-files=all')
    $entries = @($status -split "`n" | Where-Object { $_ })
    Say "[改动] $($entries.Count) 项文件状态"
    if ($status) { Say $status }
    if ($check) {
        Say (Git @('status','--short','--branch'))
        Say '[只检查] 以上远端状态来自本地缓存，未联网更新。'
        return
    }
    $remote = Git @('config','--get',"branch.$branch.remote") -AllowFailure
    $merge = Git @('config','--get',"branch.$branch.merge") -AllowFailure
    if (-not $remote) {
        $remotes = @((Git @('remote')) -split "`n" | Where-Object { $_ })
        if ($remotes -contains 'origin') { $remote = 'origin' }
        elseif ($remotes.Count -eq 1) { $remote = $remotes[0] }
        else { throw '无法唯一确定远端，请先配置当前分支的 upstream 或 origin。' }
        $merge = "refs/heads/$branch"
    }
    if ($remote -eq '.' -or -not $merge -or -not $merge.StartsWith('refs/heads/')) { throw '当前上游不是远程分支，请先修正 upstream 配置。' }
    $target = $merge.Substring(11)
    $null = Git @('remote','get-url',$remote)
    Say "[分支] $branch  →  $remote/$target"
    if ($status) {
        $name = Git @('var','GIT_AUTHOR_IDENT') -AllowFailure
        if ($gitCode -ne 0) { throw '提交身份不可用，请配置 git config user.name 和 git config user.email。' }
    }
    Say '[检查] 正在读取远端分支；失败时保留本地改动。'
    $head = Git @('ls-remote','--heads',$remote,$merge)
    $remoteExists = -not [string]::IsNullOrWhiteSpace($head)
    if ($remoteExists) {
        RunGit @('fetch','--no-tags',$remote,$merge)
        $remoteHead = Git @('rev-parse','FETCH_HEAD')
    }
    $null = Git @('rev-parse','--verify','HEAD') -AllowFailure
    $hasHead = $gitCode -eq 0
    if (-not $hasHead -and $remoteExists) { throw '本地尚无提交，但远端已有历史。请先克隆远端仓库再复制项目文件，避免创建无关历史。' }
    if ($hasHead -and $remoteExists) {
        $null = Git @('merge-base','HEAD',$remoteHead) -AllowFailure
        if ($gitCode -ne 0) { throw '本地与远端没有共同历史，停止自动同步。' }
        $counts = (Git @('rev-list','--left-right','--count',"HEAD...$remoteHead")) -split '\s+'
        Say "[同步] 本地领先 $($counts[0]) 个提交，落后 $($counts[1]) 个提交。"
        if (-not $status -and $counts[0] -eq '0' -and $counts[1] -eq '0') {
            Say '[完成] 本地与远端已经一致，无需操作。'
            return
        }
    } else { Say '[同步] 远端目标分支尚不存在，将在推送时创建。' }
    if (-not $yes) {
        $answer = Read-TimedInput '确认自动提交全部改动、整合远端并推送？[Y/n]' 'y'
        if ($answer -notin @('y','Y')) { Say '[取消] 未暂存、提交或推送。'; return }
    }
    if ($status) {
        $added = @($entries | Where-Object { $_ -match '^(\?\?|A.|.A)' }).Count
        $deleted = @($entries | Where-Object { $_ -match '^(D.|.D)' }).Count
        $other = $entries.Count - $added - $deleted
        $message = "更新 ${repoName}：新增 $added，删除 $deleted，其他修改 $other（$(Get-Date -Format 'yyyy-MM-dd HH:mm')）"
        if (-not $yes) {
            Say "[默认摘要] $message"
            $custom = Read-TimedInput '提交说明（回车使用默认摘要）'
            if (-not [string]::IsNullOrWhiteSpace($custom)) { $message = $custom }
        }
        RunGit @('add','--all')
        $null = Git @('diff','--cached','--quiet') -AllowFailure
        if ($gitCode -eq 1) {
            $messageFile = [IO.Path]::GetTempFileName()
            try {
                [IO.File]::WriteAllText($messageFile, $message, $utf8)
                RunGit @('commit','-F',$messageFile)
            } finally { Remove-Item -LiteralPath $messageFile -ErrorAction SilentlyContinue }
        } elseif ($gitCode -ne 0) { throw '无法检查暂存区，停止操作。' }
    }
    if (Git @('status','--porcelain')) { throw '提交后工作区仍有改动（可能为子模块或钩子生成文件），请处理后重试。' }
    if ($remoteExists) {
        $counts = (Git @('rev-list','--left-right','--count',"HEAD...$remoteHead")) -split '\s+'
        if ([int]$counts[1] -gt 0) {
            if ([int]$counts[0] -eq 0) {
                Say '[整合] 仅落后远端，执行快进更新。'
                RunGit @('merge','--ff-only',$remoteHead)
            } else {
                $backup = 'refs/auto-backup/' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [Guid]::NewGuid().ToString('N').Substring(0,8)
                RunGit @('update-ref',$backup,'HEAD')
                Say "[保护] 变基前已保存本地提交：$backup"
                Say '[整合] 双方都有新提交，保留合并结构执行变基。'
                try { RunGit @('rebase','--rebase-merges',$remoteHead) }
                catch { throw "变基未完成，已停止推送。运行 git status 查看；解决后 git rebase --continue，或 git rebase --abort 返回变基前状态。`n$_" }
            }
        }
    }
    Say "[推送] $remote/$target"
    RunGit @('push','--set-upstream',$remote,"HEAD:$merge")
    Say '[完成] 同步成功。'
}
try { Sync-Repository }
catch {
    $exitCode = 1
    Write-Host "[失败] $_" -ForegroundColor Red
    Say '已停止后续操作。可根据上方错误处理后重新运行；本地已有提交会在下次继续同步。'
}
finally {
    if (-not $noPause -and -not [Console]::IsInputRedirected) {
        Write-Host '按回车立即关闭窗口，2 秒后自动关闭。'
        $closeTimer = [Diagnostics.Stopwatch]::StartNew()
        while ($closeTimer.Elapsed.TotalSeconds -lt 2) {
            if ([Console]::KeyAvailable) {
                if ([Console]::ReadKey($true).Key -eq [ConsoleKey]::Enter) { break }
            }
            Start-Sleep -Milliseconds 50
        }
    }
}
exit $exitCode
