# Set Our Terminal
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -TabExpansion
# Use VI MODE
Set-PSReadLineOption -editmode vi
# Use Tab Completion
Set-PSReadLineKeyHandler -chord = -function Complete -vimode Command
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete
# Bind Fuzzy Finder to Ctrl t and r in our Terminal
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# -------------------------------------------------------------------------------------------------
# Remove Aliases
# Windows Built in Aliases , We need to Use Unix Counter part
Remove-Item alias:cat
Remove-Item alias:cp
Remove-Item alias:diff -Force
Remove-Item alias:echo
Remove-Item alias:rm
Remove-Item alias:ls
Remove-Item alias:gl -Force
# -------------------------------------------------------------------------------------------------
# Fuzzy Finder Commands
function Ccd ($cmdletname) {
	Set-Location (Get-ChildItem . -Recurse | Where-Object { $_.PSIsContainer } | Invoke-Fzf)
}
function ef ($cmdletname) {
	Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { code $_ }
}
# -------------------------------------------------------------------------------------------------
# UNIX Commands
function rf($filepath) { Remove-Item -Path $filepath -Recurse -Force }
function l { Get-ChildItem -Path . }
function ls { ls.exe --color=auto $args }
function ll { ls.exe -l --color=auto $args }
function la { ls.exe -a --color=auto $args }
function pkill($name) { get-process $name -ErrorAction SilentlyContinue | stop-process }
function pgrep { get-process $args }
# Should really be name=value like Unix version of export but not a big deal
function export($name, $value) {
	set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
	get-process $name -ErrorAction SilentlyContinue | stop-process
}
# Like Unix touch, creates new files and updates time on old ones
# PSCX has a touch, but it doesn't make empty files
function touch($file) {
	if ( Test-Path $file ) {
		Set-FileTime $file
	}
 else {
		New-Item $file -type file
	}
}
function e { nvim $args }
# From https://stackoverflow.com/questions/894430/creating-hard-and-soft-links-using-powershell
function ln($target, $link) {
	New-Item -ItemType SymbolicLink -Path $link -Value $target
}
# http://stackoverflow.com/questions/39148304/fuser-equivalent-in-powershell/39148540#39148540
function fuser($relativeFile) {
	$file = Resolve-Path $relativeFile
	write-output "Looking for processes using $file"
	foreach ( $Process in (Get-Process)) {
		foreach ( $Module in $Process.Modules) {
			if ( $Module.FileName -like "$file*" ) {
				$Process | select-object id, path
			}
		}
	}
}
function df { get-volume }
# Like a recursive sed
function edit-recursive($filePattern, $find, $replace) {
	$files = get-childitem . "$filePattern" -rec # -Exclude
	write-output $files
	foreach ($file in $files) {
		(Get-Content $file.PSPath) |
		Foreach-Object { $_ -replace "$find", "$replace" } |
		Set-Content $file.PSPath
	}
}
function find-file($name) {
	get-childitem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach-object {
		write-output($PSItem.FullName)
	}
}
function show-links($dir) {
	get-childitem $dir | where-object { $_.LinkType } | select-object FullName, LinkType, Target
}
function which($name) {
	Get-Command $name | Select-Object -ExpandProperty Definition
}
function reboot {
	shutdown /r /t 0
}
# Windows Path Shortcut CMD
function AddPath {
	param(
		[string]$Dir
	)
	if ( !(Test-Path $Dir) ) {
		Write-warning "Supplied directory was not found!"
		return
	}
	$PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine")
	if ( $PATH -notlike "*" + $Dir + "*" ) {
		[Environment]::SetEnvironmentVariable("PATH", "$PATH;$Dir", "Machine")
	}
}
# -------------------------------------------------------------------------------------------------
# Git Commands
# Show Git Status
function ss { git status }
# ignores paths you removed from your working tree.
function ga { git add --ignore-removal . }
# Stages everything, without Deleted Files
function gaa { git add . }
# Stages Everything
function gaA { git add -A }
# Stages only Modified Files
function gam { git add -u }
# Show git log of a specific commit
function gs { git show $args }
# Beautiful Git Log
function gl { git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all }
#Show list of commits
function gL { git log --all --decorate --oneline --graph }
# Show only file names in commits
function glf { git log --graph --oneline --name-only }
# Show full commits
function glF { git log -p }
# Remove File From Git Versioning but file still available Locally
function grf { git rm --cached $args }
# Remove All Changes
function nah { git reset --hard; git clean -df }
function Add-Tag { git tag -a -f $args }
function Remove-Tag-Remote { git push --delete origin $args }
function Remove-Tag-Local { git tag -d $args }
function Push-Tag { git push origin --tags --force }
function Add-Wip { "git add . && git commit -m 'wip'" }
# -------------------------------------------------------------------------------------------------
# Laravel Commands
function Invoke-Tinker-Command { php artisan tinker }
function Invoke-Artisan-Command { php artisan $args }
function Invoke-Fresh-Command { php artisan migrate:fresh --seed }
function Invoke-Phpunit { .\vendor\bin\phpunit $args }
# -------------------------------------------------------------------------------------------------
# Add All Alias to Commands Shortcuts
set-alias new-link ln
set-alias -Name j -Value jrnl.exe -Option AllScope
set-alias -Name tag -Value Add-Tag -Option AllScope
set-alias -Name ptag -Value Push-Tag -Option AllScope
Set-Alias -Name fresh -Value Invoke-Fresh-Command -Option AllScope
Set-Alias -Name wip -Value Add-Wip -Option AllScope
Set-Alias -Name tinker -Value Invoke-Tinker-Command -Option AllScope
Set-Alias -Name t -Value Invoke-Phpunit -Option AllScope
# -------------------------------------------------------------------------------------------------
# Directories Functions that will be Alias
function Set-Path-www { Set-Location -Path C:\Users\masterpowers\www }
function Set-Path-Laravel { Set-Location -Path C:\Users\masterpowers\Code\Laravel }
function Set-Path-App { Set-Location -Path C:\Users\masterpowers\App }
function Set-Path-Home { Set-Location -Path C:\Users\masterpowers }
function Set-Path-Win32 { Set-Location -Path C:\Windows\System32 }
function Get-Back-OneDIR { Set-Location -Path ../ }
function Get-Back-TwoDIR { Set-Location -Path ../../ }
function Get-Back-ThreeDIR { Set-Location -Path ../../../ }
function Get-Back-FourDIR { Set-Location -Path ../../../../ }
function Set-Path-Workspace { Set-Location -Path C:\Users\masterpowers\.workspace}

# Directory Aliases
Set-Alias -Name www -Value Set-Path-www -Option AllScope
Set-Alias -Name wp -Value Set-Path-Workspace -Option AllScope
Set-Alias -Name app -Value Set-Path-App -Option AllScope
Set-Alias -Name h -Value Set-Path-Home -Option AllScope
Set-Alias -Name lv -Value Set-Path-Laravel -Option AllScope
Set-Alias -Name '..' -Value Get-Back-OneDIR -Option AllScope
Set-Alias -Name '..2' -Value Get-Back-TwoDIR -Option AllScope
Set-Alias -Name '..3' -Value Get-Back-ThreeDIR -Option AllScope
Set-Alias -Name '..4' -Value Get-Back-FourDIR -Option AllScope
Set-Alias -Name s32 -Value Set-Path-Win32 -Option AllScope
# -------------------------------------------------------------------------------------------------
# Config files Functions that will be Alias
function Open-Workspace($name){code "C:\Users\masterpowers\.workspace\${name}.code-workspace"}
function Open-Vs-Keys { code C:\Users\masterpowers\AppData\Roaming\Code\User\keybindings.json }
function Open-Vs-Settings { code C:\Users\masterpowers\AppData\Roaming\Code\User\settings.json }
function Open-Vim-Config { code C:\Users\masterpowers\AppData\Local\nvim\init.vim }
function Open-Alacritty-Config { code C:\Users\masterpowers\AppData\Roaming\alacritty\alacritty.yml }
function Open-Etc-Host { code C:\Windows\System32\Drivers\etc\hosts }
function Open-Profile { code  C:\Users\masterpowers\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 }

# Config Aliases
Set-Alias -Name cc -Value Open-Workspace -Option AllScope
Set-Alias -Name vskey -Value Open-Vs-Keys -Option AllScope
Set-Alias -Name vset -Value Open-Vs-Settings -Option AllScope
Set-Alias -Name cfv -Value Open-Vim-Config -Option AllScope
Set-Alias -Name etc -Value Open-Etc-Hosts -Option AllScope
Set-Alias -Name pro -Value Open-Profile -Option AllScope
# -------------------------------------------------------------------------------------------------
# Beautify our terminal
Invoke-Expression (&starship init powershell)
# FNM Node Js
fnm env --use-on-cd | Out-String | Invoke-Expression
